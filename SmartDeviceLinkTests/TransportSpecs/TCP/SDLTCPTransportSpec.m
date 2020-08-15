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
#import "TestTCPServer.h"

#import <stdio.h>

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

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
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

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
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
        OCMVerifyAllWithDelay(transportDelegateMock, 30.5);

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
    });

    it(@"Should invoke onError delegate when input parameter is invalid", ^ {
        OCMExpect([transportDelegateMock onError:[OCMArg checkWithBlock:^BOOL(NSError *error) {
            if (error.domain == SDLErrorDomainTransport && error.code == SDLTransportErrorUnknown) {
                return YES;
            } else {
                return NO;
            }
        }]]);

        transport.portNumber = @"abcde";
        [transport connect];

        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
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
        expect([receivedData isEqualToData:testData]);

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
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
        [transport sendData:testData1];
        [transport sendData:testData2];

        OCMVerifyAllWithDelay(serverDelegateMock, 0.5);
        OCMVerifyAllWithDelay(transportDelegateMock, 0.5);
        expect([receivedData isEqualToData:expectedData]);

        // don't receive further delegate events
        server.delegate = nil;

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
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
        expect([receivedData isEqualToData:expectedData]);

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
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

        waitUntilTimeout(1, ^(void (^done)(void)){
            [transport disconnectWithCompletionHandler:^{
                expect(transport.ioThread.isCancelled).to(beTrue());
                expect(transport.inputStream).to(beNil());
                expect(transport.outputStream).to(beNil());

                done();
            }];
        });
    });
});

QuickSpecEnd
