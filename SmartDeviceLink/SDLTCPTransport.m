//  SDLTCPTransport.m
//


#import "SDLTCPTransport.h"
#import "SDLDebugTool.h"
#import "SDLHexUtility.h"
#import <errno.h>
#import <netdb.h>
#import <netinet/in.h>
#import <signal.h>
#import <stdio.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <sys/wait.h>
#import <unistd.h>


// C function forward declarations.
int call_socket(const char *hostname, const char *port);
static void TCPCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@interface SDLTCPTransport () {
    BOOL _alreadyDestructed;
    dispatch_queue_t _sendQueue;
}

@end


@implementation SDLTCPTransport

- (instancetype)init {
    if (self = [super init]) {
        _alreadyDestructed = NO;
        _sendQueue = dispatch_queue_create("com.sdl.transport.tcp.transmit", DISPATCH_QUEUE_SERIAL);
        [SDLDebugTool logInfo:@"SDLTCPTransport Init"
                     withType:SDLDebugType_Transport_iAP
                     toOutput:SDLDebugOutput_All
                      toGroup:self.debugConsoleGroupName];
    }

    return self;
}


- (void)connect {
    [SDLDebugTool logInfo:@"TCP Transport attempt connect" withType:SDLDebugType_Transport_TCP];

    int sock_fd = call_socket([self.hostName UTF8String], [self.portNumber UTF8String]);
    if (sock_fd < 0) {
        [SDLDebugTool logInfo:@"Server Not Ready, Connection Failed" withType:SDLDebugType_Transport_TCP];
        return;
    }

    CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
    socket = CFSocketCreateWithNative(kCFAllocatorDefault, sock_fd, kCFSocketDataCallBack | kCFSocketConnectCallBack, (CFSocketCallBack)&TCPCallback, &socketCtxt);
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopRef loop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(loop, source, kCFRunLoopDefaultMode);
    CFRelease(source);
}

- (void)sendData:(NSData *)msgBytes {
    dispatch_async(_sendQueue, ^{
        @autoreleasepool {
            NSString *byteStr = [SDLHexUtility getHexString:msgBytes];
            [SDLDebugTool logInfo:[NSString stringWithFormat:@"Sent %lu bytes: %@", (unsigned long)msgBytes.length, byteStr] withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];

            CFSocketError e = CFSocketSendData(socket, NULL, (__bridge CFDataRef)msgBytes, 10000);
            if (e != kCFSocketSuccess) {
                NSString *errorCause = nil;
                switch (e) {
                    case kCFSocketTimeout:
                        errorCause = @"Socket Timeout Error.";
                        break;

                    case kCFSocketError:
                    default:
                        errorCause = @"Socket Error.";
                        break;
                }

                [SDLDebugTool logInfo:[NSString stringWithFormat:@"Socket sendData error: %@", errorCause] withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];
            }
        }
    });
}

- (void)destructObjects {
    [SDLDebugTool logInfo:@"SDLTCPTransport invalidate and dispose"];

    if (!_alreadyDestructed) {
        _alreadyDestructed = YES;
        if (socket != nil) {
            CFSocketInvalidate(socket);
            CFRelease(socket);
        }
    }
}

- (void)disconnect {
    [self dispose];
}

- (void)dispose {
    [self destructObjects];
}

- (void)dealloc {
    [self destructObjects];
}

@end

// C functions
int call_socket(const char *hostname, const char *port) {
    int status, sock;
    struct addrinfo hints;
    struct addrinfo *servinfo;

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    //no host name?, no problem, get local host
    if (hostname == nil) {
        char localhost[128];
        gethostname(localhost, sizeof localhost);
        hostname = (const char *)&localhost;
    }

    //getaddrinfo setup
    if ((status = getaddrinfo(hostname, port, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(status));
        return (-1);
    }

    //get socket
    if ((sock = socket(servinfo->ai_family, servinfo->ai_socktype, servinfo->ai_protocol)) < 0)
        return (-1);

    //connect
    if (connect(sock, servinfo->ai_addr, servinfo->ai_addrlen) < 0) {
        close(sock);
        return (-1);
    }

    freeaddrinfo(servinfo); // free the linked-list
    return (sock);
}

static void TCPCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    if (kCFSocketConnectCallBack == type) {
        SDLTCPTransport *transport = (__bridge SDLTCPTransport *)info;
        [transport.delegate onTransportConnected];
    } else if (kCFSocketDataCallBack == type) {
        SDLTCPTransport *transport = (__bridge SDLTCPTransport *)info;

        // Check if Core disconnected from us
        if (CFDataGetLength((CFDataRef)data) <= 0) {
            [SDLDebugTool logInfo:@"TCPCallback Got a data packet with length 0, the connection was terminated on the other side"];
            [transport.delegate onTransportDisconnected];

            return;
        }

        // Handle the data we received
        NSMutableString *byteStr = [NSMutableString stringWithCapacity:((int)CFDataGetLength((CFDataRef)data) * 2)];
        for (int i = 0; i < (int)CFDataGetLength((CFDataRef)data); i++) {
            [byteStr appendFormat:@"%02X", ((Byte *)(UInt8 *)CFDataGetBytePtr((CFDataRef)data))[i]];
        }

        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Read %d bytes: %@", (int)CFDataGetLength((CFDataRef)data), byteStr] withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];

        [transport.delegate onDataReceived:[NSData dataWithBytes:(UInt8 *)CFDataGetBytePtr((CFDataRef)data) length:(int)CFDataGetLength((CFDataRef)data)]];
    } else {
        NSString *logMessage = [NSString stringWithFormat:@"unhandled TCPCallback: %lu", type];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];
    }
}
