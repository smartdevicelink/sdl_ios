//  SDLTCPTransport.m
//


#import "SDLTCPTransport.h"
#import "SDLLogConstants.h"
#import "SDLLogMacros.h"
#import "SDLLogManager.h"
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

NS_ASSUME_NONNULL_BEGIN

// C function forward declarations.
int call_socket(const char *hostname, const char *port);
static void TCPCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@interface SDLTCPTransport () {
    dispatch_queue_t _sendQueue;
}

@end


@implementation SDLTCPTransport

- (instancetype)init {
    if (self = [super init]) {
        _sendQueue = dispatch_queue_create("com.sdl.transport.tcp.transmit", DISPATCH_QUEUE_SERIAL);
        SDLLogD(@"TCP Transport initialization");
    }

    return self;
}

- (void)dealloc {
    [self disconnect];
}

- (void)connect {
    __weak typeof(self) weakself = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(self) strongself = weakself;
        SDLLogD(@"Attemping to connect");
        
        int sock_fd = call_socket([self.hostName UTF8String], [self.portNumber UTF8String]);
        if (sock_fd < 0) {
            SDLLogE(@"Server not ready, connection failed");
            return;
        }
        
        CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
        strongself->socket = CFSocketCreateWithNative(kCFAllocatorDefault, sock_fd, kCFSocketDataCallBack | kCFSocketConnectCallBack, (CFSocketCallBack)&TCPCallback, &socketCtxt);
        CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, strongself->socket, 0);
        CFRunLoopRef loop = CFRunLoopGetCurrent();
        CFRunLoopAddSource(loop, source, kCFRunLoopDefaultMode);
        CFRelease(source);
    }];
}

- (void)sendData:(NSData *)msgBytes {
    dispatch_async(_sendQueue, ^{
        @autoreleasepool {
            SDLLogBytes(msgBytes, SDLLogBytesDirectionTransmit);
            CFSocketError e = CFSocketSendData(self->socket, NULL, (__bridge CFDataRef)msgBytes, 10000);
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

                SDLLogE(@"Socket send error: %@", errorCause);
            }
        }
    });
}

- (void)disconnect {
    SDLLogD(@"Disconnect connection");
    
    if (socket != nil) {
        CFSocketInvalidate(socket);
        CFRelease(socket);
        socket = nil;
    }
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
            SDLLogW(@"Remote system terminated connection, data packet length 0");
            [transport.delegate onTransportDisconnected];

            return;
        }

        // Handle the data we received
        NSData *convertedData = [NSData dataWithBytes:(UInt8 *)CFDataGetBytePtr((CFDataRef)data) length:(NSUInteger)CFDataGetLength((CFDataRef)data)];
        SDLLogBytes(convertedData, SDLLogBytesDirectionReceive);
        [transport.delegate onDataReceived:convertedData];
    } else {
        SDLLogW(@"Unhandled callback type: %lu", type);
    }
}

NS_ASSUME_NONNULL_END
