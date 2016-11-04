//  SDLSiphonServer.m
//


/*******************************
 * Description:
 * This class opens a socket on port 7474.
 * The 'sendSiphonData' Function will
 * write to the socket that the SDL Relay Sniffer is
 * listening on.
 ******************************/

//#define ZERO_CONFIG //Uncomment when implementing zero-config.
//#define DEBUG_SIPHON //Uncomment to have output to SDLDebugTool.

#import "SDLSiphonServer.h"
#import "SDLDebugTool.h"
#include <CFNetwork/CFNetwork.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

typedef enum {
    fromApp = 0x01,
    fromSDL = 0x00,
    appLog = 0x02,
    formattedTrace = 0x03
} SiphonDataType;

const Byte siphonMsgVersionNumber = 1;
volatile int siphonSocket = 0;
NSObject *siphonLock = nil;
CFSocketRef _listeningSocket;
NSNetService *netService = nil;
volatile bool initStarted = false;
bool siphonServerEnabled = false;
bool sendingFormattedTrace = false;
NSDate *startTimeStamp;
int FIRST_PORT_TO_ATTEMPT_CONNECTION = 7474;

void _closeSiphonSocket();
bool _sendDataToSiphonSocket(int soc, const void *pData, int dataLength);
bool _sendSiphonData(const void *dataBytes, int dataBytesLength, SiphonDataType siphonDataType);
void _startServerOnPort(int port);
void _stopServer(NSString *reason);


@implementation SDLSiphonServer

// Model currently counts on init being called before any apps call _siphonNSLogData()
// The following is not thread safe (i.e. two threads could create siphon lock),
// but will assume for now that we won't have two transports created in the same proxy.
+ (void)init {
    if (initStarted) {
        return;
    } // end-if

    if (!siphonLock) {
        siphonLock = [NSData alloc];
    } // end-if

    @synchronized(siphonLock) {
        if (initStarted) {
            return;
        }

        initStarted = true;

        startTimeStamp = [NSDate date];

        _closeSiphonSocket();

        _startServerOnPort(FIRST_PORT_TO_ATTEMPT_CONNECTION);
    }
}

+ (void)enableSiphonDebug {
    siphonServerEnabled = true;
}

+ (void)disableSiphonDebug {
    siphonServerEnabled = false;
}

void _closeSiphonSocket() {
#ifdef DEBUG_SIPHON
    [SDLDebugTool logInfo:@"siphon: Resetting siphon socket ..."];
#endif
    if (siphonLock) {
        @synchronized(siphonLock) {
            if (siphonSocket) {
                close(siphonSocket);
                siphonSocket = 0;
            } // end-if
        } // end-lock
    } // end-if
#ifdef DEBUG_SIPHON
    [SDLDebugTool logInfo:@"siphon: siphon socket reset complete"];
#endif
} // end-method

+ (void)dealloc {
#ifdef ZERO_CONFIG
    _stopServer(@"Shutting Down");
#endif
}

+ (bool)_siphonIsActive {
    if (siphonSocket == 0) {
        return NO;
    }
    return YES;
}


+ (bool)_siphonFormattedTraceData:(NSString *)traceData {
    if ((traceData == NULL) || (traceData.length == 0)) {
        return NO;
    } // end-if

    NSData *traceBytes = [traceData dataUsingEncoding:NSUTF8StringEncoding];

    if (traceBytes == nil) {
        return NO;
    } // end-if

    bool dataSent = NO;

    sendingFormattedTrace = true;

    dataSent = _sendSiphonData(traceBytes.bytes, (int)traceBytes.length, formattedTrace);

    return dataSent;
} // end-method

+ (bool)_siphonNSLogData:(NSString *)textToLog {
    if ((textToLog == NULL) || (textToLog.length == 0)) {
        return NO;
    } // end-if

    NSData *textBytes = [textToLog dataUsingEncoding:NSUTF8StringEncoding];

    if (textBytes == nil) {
        return NO;
    } // end-if

    bool dataSent = NO;

    dataSent = _sendSiphonData(textBytes.bytes, (int)textBytes.length, appLog);

    return dataSent;
} // end-method

+ (bool)_siphonRawTransportDataFromApp:(const void *)msgBytes msgBytesLength:(int)msgBytesLength {
    if (sendingFormattedTrace) {
        return false;
    } // end-if

    if (msgBytes == NULL || msgBytesLength == 0) {
        return false;
    } // end-if

    return _sendSiphonData(msgBytes, msgBytesLength, fromApp);
}

+ (bool)_siphonRawTransportDataFromSDL:(const void *)msgBytes msgBytesLength:(int)msgBytesLength {
    if (sendingFormattedTrace) {
        return false;
    } // end-if

    if (msgBytes == NULL || msgBytesLength == 0) {
        return false;
    } // end-if

    return _sendSiphonData(msgBytes, msgBytesLength, fromSDL);
}

bool _sendSiphonData(const void *dataBytes, int dataBytesLength, SiphonDataType siphonDataType) {
    bool wasSent = NO;

    if (dataBytes == NULL || dataBytesLength == 0 || !siphonServerEnabled) {
        return false;
    } // end-if

    NSDate *currentTime = [NSDate date];
    NSTimeInterval deltaTimeMillis = ([currentTime timeIntervalSinceDate:startTimeStamp] * 1000.0);
    uint32_t integerDeltaTimeMillis = ((uint32_t)deltaTimeMillis);

    integerDeltaTimeMillis = htonl(integerDeltaTimeMillis);

    if (siphonLock) {
        @synchronized(siphonLock) {
            if (siphonSocket) {
                Byte sdt = (Byte)siphonDataType;
                sdt = (Byte)0x80 | sdt;
                uint32_t sizeBytes = htonl(dataBytesLength + sizeof(sdt) + sizeof(integerDeltaTimeMillis) + sizeof(siphonMsgVersionNumber));

                wasSent = _sendDataToSiphonSocket(siphonSocket, &sizeBytes, sizeof(sizeBytes));

                if (wasSent) {
                    wasSent = _sendDataToSiphonSocket(siphonSocket, &sdt, sizeof(sdt));
                }

                if (wasSent) {
                    wasSent = _sendDataToSiphonSocket(siphonSocket, &siphonMsgVersionNumber, sizeof(siphonMsgVersionNumber));
                }

                if (wasSent) {
                    wasSent = _sendDataToSiphonSocket(siphonSocket, &integerDeltaTimeMillis, sizeof(integerDeltaTimeMillis));
                }

                if (wasSent) {
                    wasSent = _sendDataToSiphonSocket(siphonSocket, dataBytes, dataBytesLength);
                }

                if (wasSent) {
                    return YES;
                } else {
#ifdef DEBUG_SIPHON
                    [SDLDebugTool logInfo:@"siphon: failure sending to siphon socket"];
#endif
                    _closeSiphonSocket();
                    return NO;
                } // end-if
            } else {
#ifdef DEBUG_SIPHON
                [SDLDebugTool logInfo:@"siphon: siphon socket is NULL"];
#endif
            } // end-if
        } //end  Synchronized
    } // end-if
    return NO;

} // end-method

bool _sendDataToSiphonSocket(int soc, const void *pData, int dataLength) {
    int bytesRemainingToSend = dataLength;
    ssize_t bytesSent = 0;
    const UInt8 *pd = pData;

    if (pData == NULL || dataLength == 0) {
        return false;
    } // end-if

    while (bytesRemainingToSend > 0) {
        if (soc) {
            bytesSent = send(soc, pd, bytesRemainingToSend, 0);

            if (bytesSent == -1) {
#ifdef DEBUG_SIPHON
                [SDLDebugTool logInfo:@"siphon: got bytesSent==-1 on send(siphonSocket)"];
#endif
                return NO;
            } // end-if

            bytesRemainingToSend -= bytesSent;
            pd += bytesSent;
        } // end-if

    } // end-while

    return YES;

} // end-method


void _serverDidStartOnPort(int port) {
#ifdef DEBUG_SIPHON
    [SDLDebugTool logInfo:@"siphon: server started on port: %d", port];
#endif
}

#ifdef ZERO_CONFIG

#pragma mark
#pragma mark Server

- (void)_didSendData:(NSData *)data {
}

void _serverDidStopWithReason(NSString *reason) {
}

- (void)_updateStatus:(NSString *)statusString {
    [SDLDebugTool logFormat:@"siphon: %@", statusString];
}

- (void)_SendDidStopWithStatus:(NSString *)statusString {
    [SDLDebugTool logInfo:@"siphon: server configured for output"];
}

- (BOOL)isStarted {
    return (netService != nil);
}
#endif


void _acceptConnection(int fd) {
    if (siphonLock) {
        @synchronized(siphonLock) {
            int socketOps = 1;

            _closeSiphonSocket();
#ifdef DEBUG_SIPHON
            [SDLDebugTool logFormat:@"siphon: storing newly accepted siphon socket handle %08x ...", fd];
#endif
            siphonSocket = fd;

            setsockopt(siphonSocket, SOL_SOCKET, SO_NOSIGPIPE, (void *)&socketOps, sizeof(int));
            [SDLDebugTool logInfo:@"Siphon connected." withType:SDLDebugType_Debug];

        } // end-lock
    } // end-if
    return;
}

static void AcceptCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
#ifdef DEBUG_SIPHON
    [SDLDebugTool logInfo:@"siphon: accepted siphon connection ..."];
#endif

#pragma unused(type)
    assert(type == kCFSocketAcceptCallBack);
#pragma unused(address)
    assert(data != NULL);

#pragma unused(s)
    assert(s == _listeningSocket);

    _acceptConnection(*(int *)data);
}


#ifdef ZERO_CONFIG
- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
#pragma unused(sender)
    assert(sender == netService);
#pragma unused(errorDict)

    _stopServer(@"Registration failed");
}
#endif

void _startServerOnPort(int port) {
    BOOL success;
    int err;
    int fd;
    struct sockaddr_in addr;
    int const retryLimit = 1000;

    fd = socket(AF_INET, SOCK_STREAM, 0);
    success = (fd != -1);

    if (success) {
        memset(&addr, 0, sizeof(addr));
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;

        addr.sin_addr.s_addr = INADDR_ANY;

        bool openPortFound = false;
        short bindPort = (short)port;
        success = false;
        for (int retryCount = 0; retryCount < retryLimit && !openPortFound; retryCount++) {
            addr.sin_port = htons(bindPort);
            err = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
            if (err == 0) {
                openPortFound = true;
                success = (err == 0);
                //                port = bindPort;
            } else {
                bindPort++;
            }
        } // end-for
    }
    if (success) {
        err = listen(fd, 5);
        success = (err == 0);
    }
    if (success) {
        socklen_t addrLen;

        addrLen = sizeof(addr);
        err = getsockname(fd, (struct sockaddr *)&addr, &addrLen);
        success = (err == 0);

        if (success) {
            assert(addrLen == sizeof(addr));
            //            port = ntohs(addr.sin_port);
        }
#ifdef DEBUG_SIPHON
        [SDLDebugTool logFormat:@"siphon: my port is %d ", port];
#endif
    }
    if (success) {
        _listeningSocket = CFSocketCreateWithNative(
            NULL,
            fd,
            kCFSocketAcceptCallBack,
            AcceptCallback,
            NULL);
        success = (_listeningSocket != NULL);

        if (success) {
            CFRunLoopSourceRef rls;
            //            fd = -1;
            rls = CFSocketCreateRunLoopSource(NULL, _listeningSocket, 0);
            assert(rls != NULL);
            CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
            CFRelease(rls);
        }
    }

#ifdef ZERO_CONFIG

    if (success) {
        UIDevice *device = [UIDevice currentDevice];
        ;
        NSString *serviceName = [NSString stringWithFormat:@"%@_%d ", device.name, port];
        netService = [[[NSNetService alloc] initWithDomain:@"local." type:@"_sync._tcp." name:serviceName port:port] autorelease];
        success = (netService != nil);
    }
    if (success) {
        [netService publishWithOptions:NSNetServiceNoAutoRename];
    }

    if (success) {
        assert(port != 0);
        _serverDidStartOnPort(port);
    } else {
        _stopServer(@"Start failed");
        if (fd != -1) {
            assert(startFailed == 0);
        }
    }

#endif
}

void _stopServer(NSString *reason) {
#ifdef ZERO_CONFIG
    if (netService != nil) {
        [netService stop];
        netService = nil;
    }
    _serverDidStopWithReason(reason);
#endif
}

@end
