//
//  SDLTCPTransportSpec.m
//  SmartDeviceLinkTests
//
//  Created by Sho Amano on 2018/04/24.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLTCPTransport.h"
#import "SDLError.h"

#import <sys/types.h>
#import <sys/socket.h>
#import <netdb.h>
#import <sys/select.h>
#import <sys/time.h>
#import <fcntl.h>
#import <stdio.h>
#import <string.h>
#import <errno.h>

#define RECV_BUF_SIZE           (1024)
#define MAX_SERVER_SOCKET_NUM   (16)
#define THREAD_STOP_WAIT_SEC    (1.0)

@protocol TestTCPServerDelegate
- (void)onClientConnected;
- (void)onClientDataReceived:(NSData *)data;
- (void)onClientShutdown;
- (void)onClientError;
@end

@interface TestTCPServer : NSObject {
    int _serverSockets[MAX_SERVER_SOCKET_NUM];
    int _internalSockets[2];
    int _clientSocket;  // supports only one client
}

@property (nullable, nonatomic, weak) id<TestTCPServerDelegate> delegate;
@property (nullable, nonatomic, strong) NSThread *thread;
@property (nonatomic, strong) dispatch_semaphore_t threadStoppedSemaphore;
@property (nonatomic, strong) NSMutableArray<NSMutableData*> *sendData;
@property (nonatomic, assign) BOOL enableSOReuseAddr;
@end

@implementation TestTCPServer

- (instancetype)init {
    if (self = [super init]) {
        for (unsigned int i = 0; i < MAX_SERVER_SOCKET_NUM; i++) {
            _serverSockets[i] = -1;
        }
        _sendData = [[NSMutableArray alloc] init];
        _enableSOReuseAddr = YES;
    }
    return self;
}

- (void)dealloc {
    [self teardown];
}

- (BOOL)setup:(NSString *)hostName port:(NSString *)port {
    int ret = socketpair(PF_UNIX, SOCK_STREAM, 0, _internalSockets);
    if (ret < 0) {
        NSLog(@"SDLTCPTransportSpec: socketpair() failed");
        return NO;
    }
    if (!([self configureSocket:_internalSockets[0]] && [self configureSocket:_internalSockets[1]])) {
        return NO;
    }

    struct addrinfo hints, *res;
    hints.ai_family = PF_INET6;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE              /* server socket */
                     | AI_NUMERICSERV        /* 2nd arg is numeric port number */
                     | AI_ALL | AI_V4MAPPED; /* return both IPv4 and IPv6 addresses */

    ret = getaddrinfo([hostName UTF8String], [port UTF8String], &hints, &res);
    if (ret != 0) {
        NSLog(@"Error: SDLTCPTransportSpec getaddrinfo() failed, %s", gai_strerror(ret));
        return NO;
    }

    int socketNum = 0;
    for (struct addrinfo *info = res; info != NULL && socketNum < (MAX_SERVER_SOCKET_NUM - 1); info = info->ai_next) {
        int sock = socket(info->ai_family, info->ai_socktype, info->ai_protocol);
        if (sock < 0) {
            NSLog(@"Error SDLTCPTransportSpec server socket creation failed");
            continue;
        }

        if (![self configureServerSocket:sock]) {
            close(sock);
            continue;
        }

        ret = bind(sock, info->ai_addr, info->ai_addrlen);
        if (ret < 0) {
            NSLog(@"Error SDLTCPTransportSpec server socket bind() failed: %s", strerror(errno));
            close(sock);
            continue;
        }

        ret = listen(sock, 5);
        if (ret < 0) {
            NSLog(@"Error SDLTCPTransportSpec server socket listen() failed: %s", strerror(errno));
            close(sock);
            continue;
        }

        _serverSockets[socketNum] = sock;
        socketNum++;
    }
    freeaddrinfo(res);

    _clientSocket = -1;

    // create a thread and run
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
    self.threadStoppedSemaphore = dispatch_semaphore_create(0);
    NSLog(@"SDLTCPTransportSpec starting TCP server");
    [self.thread start];

    return YES;
}

- (BOOL)teardown {
    if (self.thread == nil) {
        return YES;
    }

    BOOL result = YES;

    // wake up select() and let it stop
    shutdown(_internalSockets[1], SHUT_WR);

    long ret = dispatch_semaphore_wait(self.threadStoppedSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(THREAD_STOP_WAIT_SEC * NSEC_PER_SEC)));
    if (ret != 0) {
        NSLog(@"Error: SDLTCPTransportSpec thread doesn't stop");
        result = NO;
    }
    self.thread = nil;

    for (unsigned int i = 0; i < MAX_SERVER_SOCKET_NUM; i++) {
        if (_serverSockets[i] >= 0) {
            close(_serverSockets[i]);
            _serverSockets[i] = -1;
        }
    }
    if (_internalSockets[0] >= 0) {
        close(_internalSockets[0]);
        _internalSockets[0] = -1;
    }
    if (_internalSockets[1] >= 0) {
        close(_internalSockets[1]);
        _internalSockets[1] = -1;
    }

    [self.sendData removeAllObjects];
    return result;
}

- (void)send:(NSData *)data {
    [self.sendData addObject:[data mutableCopy]];

    // wake up select()
    char buf[1] = {'a'};
    send(_internalSockets[1], buf, sizeof(buf), 0);
}

- (BOOL)shutdownClient {
    if (_clientSocket < 0) {
        // client is not connected
        return NO;
    }
    int ret = shutdown(_clientSocket, SHUT_WR);
    if (ret != 0) {
        NSLog(@"SDLTCPTransportSpec shutdown() for client socket failed: %s", strerror(errno));
        return NO;
    }
    return YES;
}

- (void)run:(id)userInfo {
    BOOL running = YES;
    BOOL internalFailure = NO;
    int ret;

    while (running) {
        fd_set readfds;
        fd_set writefds;
        int maxFd = 0;

        FD_ZERO(&readfds);
        FD_ZERO(&writefds);

        for (unsigned int i = 0; _serverSockets[i] >= 0; i++) {
            FD_SET(_serverSockets[i], &readfds);
            if (_serverSockets[i] > maxFd) {
                maxFd = _serverSockets[i];
            }
        }
        FD_SET(_internalSockets[0], &readfds);
        if (_internalSockets[0] > maxFd) {
            maxFd = _internalSockets[0];
        }

        if (_clientSocket >= 0) {
            FD_SET(_clientSocket, &readfds);
            if ([self.sendData count] > 0) {
                FD_SET(_clientSocket, &writefds);
            }

            if (_clientSocket > maxFd) {
                maxFd = _clientSocket;
            }
        }

        ret = select(maxFd + 1, &readfds, &writefds, NULL, NULL);
        if (ret < 0) {
            NSLog(@"Error: SDLTCPTransportSpec TCP server select() failed");
            internalFailure = YES;
            break;
        }

        // client socket check
        if (_clientSocket >= 0) {
            if (FD_ISSET(_clientSocket, &readfds)) {
                char buf[RECV_BUF_SIZE];
                ssize_t recvLen = recv(_clientSocket, buf, sizeof(buf), 0);
                if (recvLen < 0) {
                    if (errno == EAGAIN || errno == EWOULDBLOCK) {
                        // this is not an error
                    } else {
                        NSLog(@"SDLTCPTransportSpec recv() for client socket failed: %s", strerror(errno));
                        [self.delegate onClientError];
                        close(_clientSocket);
                        _clientSocket = -1;
                    }
                } else if (recvLen == 0) {
                    [self.delegate onClientShutdown];
                    // keep the socket open in case we have some more data to send
                } else {
                    NSData *data = [NSData dataWithBytes:buf length:recvLen];
                    [self.delegate onClientDataReceived:data];
                }
            }
            if (FD_ISSET(_clientSocket, &writefds)) {
                NSMutableData *data = self.sendData[0];
                ssize_t sentLen = send(_clientSocket, data.bytes, data.length, 0);
                if (sentLen < 0) {
                    if (errno == EAGAIN || errno == EWOULDBLOCK) {
                        // this is not an error
                    } else {
                        NSLog(@"SDLTCPTransportSpec send() for client socket failed: %s", strerror(errno));
                        [self.delegate onClientError];
                        close(_clientSocket);
                        _clientSocket = -1;
                    }
                } else if (sentLen > 0) {
                    if (data.length == (NSUInteger)sentLen) {
                        [self.sendData removeObjectAtIndex:0];
                    } else {
                        [data replaceBytesInRange:NSMakeRange(0, sentLen) withBytes:NULL length:0];
                    }
                }
            }
        }

        // server socket check
        for (unsigned int i = 0; _serverSockets[i] >= 0; i++) {
            int sock = _serverSockets[i];
            if (FD_ISSET(sock, &readfds)) {
                struct sockaddr_storage addr;
                socklen_t addrlen;
                ret = accept(sock, (struct sockaddr *)&addr, &addrlen);
                if (ret < 0) {
                    if (errno == EAGAIN || errno == EWOULDBLOCK) {
                        // this is not an error
                        continue;
                    } else {
                        NSLog(@"Error: SDLTCPTransportSpec TCP server accept() failed: %s", strerror(errno));
                        internalFailure = YES;
                        running = NO;
                        break;
                    }
                }

                if (_clientSocket >= 0) {
                    NSLog(@"Error: SDLTCPTransportSpec TCP server received more than one connections");
                }

                if (![self configureSocket:ret]) {
                    close(ret);
                    internalFailure = YES;
                    running = NO;
                    break;
                };

                _clientSocket = ret;
                [self.delegate onClientConnected];
            }
        }

        // internal pipe check
        if (FD_ISSET(_internalSockets[0], &readfds)) {
            char buf[16];
            ssize_t recvLen = recv(_internalSockets[0], buf, sizeof(buf), 0);
            if (recvLen < 0) {
                if (errno == EAGAIN || errno == EWOULDBLOCK) {
                    // this is not an error
                } else {
                    NSLog(@"Error: SDLTCPTransportSpec TCP server recv() failed for internal pipe: %s", strerror(errno));
                    internalFailure = YES;
                    break;
                }
            } else if (recvLen == 0) {
                NSLog(@"SDLTCPTransportSpec stopping TCP server");
                break;
            }
        }
    }

    if (_clientSocket >= 0) {
        close(_clientSocket);
        _clientSocket = -1;
    }

    expect(internalFailure == NO);

    dispatch_semaphore_signal(self.threadStoppedSemaphore);
}

- (BOOL)configureSocket:(int)sock {
    // make the socket non-blocking
    int flags;
    flags = fcntl(sock, F_GETFL, 0);
    if (flags == -1) {
        NSLog(@"Error: SDLTCPTransportSpec fcntl (F_GETFL) failed");
        return NO;
    }
    int ret = fcntl(sock, F_SETFL, flags | O_NONBLOCK);
    if (ret == -1) {
        NSLog(@"Error: SDLTCPTransportSpec fcntl (F_SETFL) failed: %s", strerror(errno));
        return NO;
    }

    // don't generate SIGPIPE signal
    int val = 1;
    ret = setsockopt(sock, SOL_SOCKET, SO_NOSIGPIPE, &val, sizeof(val));
    if (ret != 0) {
        NSLog(@"Error: SDLTCPTransportSpec setsockopt() failed");
        return NO;
    }

    return YES;
}

- (BOOL)configureServerSocket:(int)sock {
    if (![self configureSocket:sock]) {
        return NO;
    }

    if (self.enableSOReuseAddr) {
        int val = 1;
        int ret = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
        if (ret != 0) {
            NSLog(@"Error: SDLTCPTransportSpec setsockopt() failed");
            return NO;
        }
    }

    return YES;
}
@end

@interface SDLTCPTransport ()
// verify some internal properties
@property (nullable, nonatomic, strong) NSThread *ioThread;
@property (nullable, nonatomic, strong) NSInputStream *inputStream;
@property (nullable, nonatomic, strong) NSOutputStream *outputStream;
@end

QuickSpecBegin(SDLTCPTransportSpec)

describe(@"SDLTCPTransport", ^ {
    __block SDLTCPTransport *transport = nil;
    __block id transportDelegateMock = nil;
    __block TestTCPServer *server = nil;
    __block id serverDelegateMock = nil;

    beforeEach(^{
        transport = [[SDLTCPTransport alloc] init];
        transport.hostName = @"localhost";
        transport.portNumber = @"12345";
        transportDelegateMock = OCMProtocolMock(@protocol(SDLTransportDelegate));
        transport.delegate = transportDelegateMock;

        server = [[TestTCPServer alloc] init];
        serverDelegateMock = OCMProtocolMock(@protocol(TestTCPServerDelegate));
        server.delegate = serverDelegateMock;
    });

    afterEach(^{
        transport.delegate = nil;
        server.delegate = nil;

        [transport disconnect];
        transport = nil;
        transportDelegateMock = nil;

        [server teardown];
        server = nil;
        serverDelegateMock = nil;
    });

    it(@"Should be able to connect to specified TCP server and disconnect from it", ^ {
        BOOL ret = [server setup:@"localhost" port:@"12345"];
        expect(ret);

        OCMExpect([serverDelegateMock onClientConnected]);
        OCMExpect([transportDelegateMock onTransportConnected]);

        [transport connect];

        OCMVerifyAllWithDelay(serverDelegateMock, 0.5);
        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        expect(transport.ioThread != nil);
        expect(transport.inputStream != nil);
        expect(transport.outputStream != nil);

        [transport disconnect];

        expect(transport.ioThread == nil);
        expect(transport.inputStream == nil);
        expect(transport.outputStream == nil);
    });

    it(@"Should invoke onError delegate when connection is refused", ^ {
        // Start the server without SO_REUSEADDR then close it. Then the port will not be owned by anybody for a while.
        server.enableSOReuseAddr = NO;
        BOOL ret = [server setup:@"localhost" port:@"12346"];
        expect(ret);
        [server teardown];
        server = nil;

        OCMExpect([transportDelegateMock onError:[OCMArg checkWithBlock:^BOOL(NSError *error) {
            if (error.domain == SDLErrorDomainTransport && error.code == SDLTransportErrorConnectionRefused) {
                return YES;
            } else {
                return NO;
            }
        }]]);

        transport.portNumber = @"12346";
        [transport connect];

        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        [transport disconnect];

        expect(transport.ioThread == nil);
        expect(transport.inputStream == nil);
        expect(transport.outputStream == nil);
    });

    it(@"Should invoke onError delegate when connection is timed out", ^ {
        OCMExpect([transportDelegateMock onError:[OCMArg checkWithBlock:^BOOL(NSError *error) {
            if (error.domain == SDLErrorDomainTransport && error.code == SDLTransportErrorConnectionTimedOut) {
                return YES;
            } else {
                return NO;
            }
        }]]);

        transport.hostName = @"127.0.0.2";
        [transport connect];

        // timeout value should be longer than 'ConnectionTimeoutSecs' in SDLTCPTransport
        OCMVerifyAllWithDelay(transportDelegateMock, 60.0);

        [transport disconnect];

        expect(transport.ioThread == nil);
        expect(transport.inputStream == nil);
        expect(transport.outputStream == nil);
    });

    it(@"Should invoke onError delegate when input parameter is invalid", ^ {
        OCMExpect([transportDelegateMock onError:[OCMArg checkWithBlock:^BOOL(NSError *error) {
            if (error.domain == SDLErrorDomainTransport && error.code == SDLTransportErrorOthers) {
                return YES;
            } else {
                return NO;
            }
        }]]);

        transport.portNumber = @"abcde";
        [transport connect];

        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        [transport disconnect];

        expect(transport.ioThread == nil);
        expect(transport.inputStream == nil);
        expect(transport.outputStream == nil);
    });

    it(@"Should send out data when send is called", ^ {
        BOOL ret = [server setup:@"localhost" port:@"12345"];
        expect(ret);

        char buf[256];
        snprintf(buf, sizeof(buf), "This is dummy message.");
        NSData *testData = [NSData dataWithBytes:buf length:strlen(buf)];
        NSMutableData *receivedData = [[NSMutableData alloc] init];

        OCMExpect([serverDelegateMock onClientConnected]);
        OCMStub([serverDelegateMock onClientDataReceived:OCMOCK_ANY]).andDo(^(NSInvocation *invocation) {
            __unsafe_unretained NSData *data;
            [invocation getArgument:&data atIndex:2];   // first argument is index 2
            [receivedData appendData:data];
            NSLog(@"mock server received %lu bytes", data.length);
        });

        OCMExpect([transportDelegateMock onTransportConnected]);

        [transport connect];
        [transport sendData:testData];

        OCMVerifyAllWithDelay(serverDelegateMock, 0.5);
        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        [NSThread sleepForTimeInterval:0.5];
        expect([receivedData isEqualToData:testData]);

        [transport disconnect];
    });

    it(@"Should send out data even if send is called some time after", ^ {
        BOOL ret = [server setup:@"localhost" port:@"12345"];
        expect(ret);

        char buf1[256], buf2[256];
        snprintf(buf1, sizeof(buf1), "This is another dummy message.");
        snprintf(buf2, sizeof(buf2), "followed by 12345678901234567890123456");
        NSData *testData1 = [NSData dataWithBytes:buf1 length:strlen(buf1)];
        NSData *testData2 = [NSData dataWithBytes:buf2 length:strlen(buf2)];
        NSMutableData *expectedData = [NSMutableData dataWithData:testData1];
        [expectedData appendData:testData2];

        __block NSMutableData *receivedData = [[NSMutableData alloc] init];

        OCMExpect([serverDelegateMock onClientConnected]);
        OCMStub([serverDelegateMock onClientDataReceived:OCMOCK_ANY]).andDo(^(NSInvocation *invocation) {
            __unsafe_unretained NSData *data;
            [invocation getArgument:&data atIndex:2];   // first argument is index 2
            [receivedData appendData:data];
            NSLog(@"mock server received %lu bytes", data.length);
        });

        OCMExpect([transportDelegateMock onTransportConnected]);

        [transport connect];

        // check that transport still sends out data long after NSStreamEventHasSpaceAvailable event
        [NSThread sleepForTimeInterval:1.0];
        [transport sendData:testData1];
        [transport sendData:testData2];

        OCMVerifyAllWithDelay(serverDelegateMock, 0.5);
        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        [NSThread sleepForTimeInterval:0.5];
        expect([receivedData isEqualToData:expectedData]);

        // don't receive further delegate events
        server.delegate = nil;

        [transport disconnect];
    });

    it(@"Should invoke onDataReceived delegate when received some data", ^ {
        BOOL ret = [server setup:@"localhost" port:@"12345"];
        expect(ret);

        char buf1[256], buf2[256];
        snprintf(buf1, sizeof(buf1), "This is test data.");
        snprintf(buf2, sizeof(buf2), "This is another chunk of data.");
        NSData *testData1 = [NSData dataWithBytes:buf1 length:strlen(buf1)];
        NSData *testData2 = [NSData dataWithBytes:buf2 length:strlen(buf2)];
        NSMutableData *expectedData = [NSMutableData dataWithData:testData1];
        [expectedData appendData:testData2];

        OCMExpect([transportDelegateMock onTransportConnected]);

        NSMutableData *receivedData = [[NSMutableData alloc] init];
        OCMStub([transportDelegateMock onDataReceived:OCMOCK_ANY]).andDo(^(NSInvocation *invocation) {
            __unsafe_unretained NSData *data;
            [invocation getArgument:&data atIndex:2];   // first argument is index 2
            [receivedData appendData:data];
            NSLog(@"client received %lu bytes", data.length);
        });

        OCMExpect([serverDelegateMock onClientConnected]);

        [transport connect];

        // wait until connected
        OCMVerifyAllWithDelay(serverDelegateMock, 0.5);
        [server send:testData1];
        [server send:testData2];

        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        [NSThread sleepForTimeInterval:0.5];
        expect([receivedData isEqualToData:expectedData]);

        [transport disconnect];
    });

    it(@"Should generate disconnected event after peer closed connection", ^ {
        BOOL ret = [server setup:@"localhost" port:@"12345"];
        expect(ret);

        OCMExpect([serverDelegateMock onClientConnected]);
        OCMExpect([transportDelegateMock onTransportConnected]);

        [transport connect];

        OCMVerifyAllWithDelay(serverDelegateMock, 0.5);
        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        OCMExpect([transportDelegateMock onTransportDisconnected]);

        // Close the writing connection. This will notify the client that peer closed the connection.
        ret = [server shutdownClient];
        expect(ret);

        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        [transport disconnect];
    });
});

QuickSpecEnd
