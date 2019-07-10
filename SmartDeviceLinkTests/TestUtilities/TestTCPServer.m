//
//  TestTCPServer.m
//  SmartDeviceLinkTests
//
//  Created by Sho Amano on 2018/07/27.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>

#import "TestTCPServer.h"

#import <sys/types.h>
#import <sys/socket.h>
#import <netdb.h>
#import <sys/select.h>
#import <sys/time.h>
#import <fcntl.h>
#import <string.h>
#import <errno.h>

#define MAX_SERVER_SOCKET_NUM   (16)
#define RECV_BUF_SIZE           (1024)
#define THREAD_STOP_WAIT_SEC    (1.0)

@interface TestTCPServer() {
    int _serverSockets[MAX_SERVER_SOCKET_NUM];
    int _internalSockets[2];
    int _clientSocket;  // supports only one client
}

@property (nullable, nonatomic, strong) NSThread *thread;
@property (nonatomic, strong) dispatch_semaphore_t threadStoppedSemaphore;
@property (nonatomic, strong) NSMutableArray<NSMutableData*> *sendData;
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
        NSLog(@"TestTCPServer: socketpair() failed");
        return NO;
    }
    if (!([self configureSocket:_internalSockets[0]] && [self configureSocket:_internalSockets[1]])) {
        return NO;
    }

    struct addrinfo hints, *res;
    hints.ai_family = PF_INET6;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE     /* server socket */
    | AI_NUMERICSERV                /* 2nd arg is numeric port number */
    | AI_ALL | AI_V4MAPPED;         /* return both IPv4 and IPv6 addresses */

    ret = getaddrinfo([hostName UTF8String], [port UTF8String], &hints, &res);
    if (ret != 0) {
        NSLog(@"Error: TestTCPServer getaddrinfo() failed, %s", gai_strerror(ret));
        return NO;
    }

    int socketNum = 0;
    for (struct addrinfo *info = res; info != NULL && socketNum < (MAX_SERVER_SOCKET_NUM - 1); info = info->ai_next) {
        int sock = socket(info->ai_family, info->ai_socktype, info->ai_protocol);
        if (sock < 0) {
            NSLog(@"Error: TestTCPServer server socket creation failed");
            continue;
        }

        if (![self configureServerSocket:sock]) {
            close(sock);
            continue;
        }

        ret = bind(sock, info->ai_addr, info->ai_addrlen);
        if (ret < 0) {
            NSLog(@"Error: TestTCPServer server socket bind() failed: %s", strerror(errno));
            close(sock);
            continue;
        }

        ret = listen(sock, 5);
        if (ret < 0) {
            NSLog(@"Error: TestTCPServer server socket listen() failed: %s", strerror(errno));
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
    NSLog(@"TestTCPServer: starting TCP server");
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
        NSLog(@"Error: TestTCPServer thread doesn't stop");
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
        NSLog(@"TestTCPServer: shutdown() for client socket failed: %s", strerror(errno));
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
            NSLog(@"Error: TestTCPServer TCP server select() failed");
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
                        NSLog(@"TestTCPServer: recv() for client socket failed: %s", strerror(errno));
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
                        NSLog(@"TestTCPServer: send() for client socket failed: %s", strerror(errno));
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
                        NSLog(@"Error: TestTCPServer TCP server accept() failed: %s", strerror(errno));
                        internalFailure = YES;
                        running = NO;
                        break;
                    }
                }

                if (_clientSocket >= 0) {
                    NSLog(@"Error: TestTCPServer TCP server received more than one connections");
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
                    NSLog(@"Error: TestTCPServer TCP server recv() failed for internal pipe: %s", strerror(errno));
                    internalFailure = YES;
                    break;
                }
            } else if (recvLen == 0) {
                NSLog(@"TestTCPServer: stopping TCP server");
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
        NSLog(@"Error: TestTCPServer fcntl (F_GETFL) failed");
        return NO;
    }
    int ret = fcntl(sock, F_SETFL, flags | O_NONBLOCK);
    if (ret == -1) {
        NSLog(@"Error: TestTCPServer fcntl (F_SETFL) failed: %s", strerror(errno));
        return NO;
    }

    // don't generate SIGPIPE signal
    int val = 1;
    ret = setsockopt(sock, SOL_SOCKET, SO_NOSIGPIPE, &val, sizeof(val));
    if (ret != 0) {
        NSLog(@"Error: TestTCPServer setsockopt() failed");
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
            NSLog(@"Error: TestTCPServer setsockopt() failed");
            return NO;
        }
    }

    return YES;
}
@end
