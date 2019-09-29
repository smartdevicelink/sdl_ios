//
//  SDLAsynchronousRPCOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/20/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceData.h"
#import "SDLAsynchronousRPCOperation.h"
#import "SDLGetAppServiceDataResponse.h"
#import "SDLGlobals.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLAsynchronousRPCOperationSpec)

describe(@"sending responses and notifications", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLAsynchronousRPCOperation *testOperation = nil;
    __block NSOperationQueue *testOperationQueue = nil;

    beforeEach(^{
        testOperation = nil;
        testConnectionManager = [[TestConnectionManager alloc] init];

        testOperationQueue = [[NSOperationQueue alloc] init];
        testOperationQueue.name = @"com.sdl.RPCResponse.testqueue";
        testOperationQueue.underlyingQueue = [SDLGlobals sharedGlobals].sdlProcessingQueue;
    });

    context(@"when a single request succeeds", ^{
        __block __kindof SDLRPCMessage *sendRPC = nil;

        beforeEach(^{
            sendRPC = [[SDLGetAppServiceDataResponse alloc] initWithAppServiceData:[[SDLAppServiceData alloc] init]];
        });

        it(@"should correctly send the rpc", ^{
            testOperation = [[SDLAsynchronousRPCOperation alloc] initWithConnectionManager:testConnectionManager rpc:sendRPC];

            [testOperationQueue addOperation:testOperation];
            [NSThread sleepForTimeInterval:0.1];

            expect(testConnectionManager.receivedRequests).toEventually(contain(sendRPC));
        });
    });

    context(@"when multiple request succeed", ^{
        __block NSMutableArray< __kindof SDLRPCMessage *> *sendRPCs = nil;
        int rpcCount = 9;

        beforeEach(^{
            sendRPCs = [NSMutableArray array];
            for (int i = 0; i < rpcCount; i += 1) {
                [sendRPCs addObject:[[SDLGetAppServiceDataResponse alloc] initWithAppServiceData:[[SDLAppServiceData alloc] init]]];
            }
        });

        it(@"should correctly send all of the rpcs", ^{
            for (int i = 0; i < rpcCount; i += 1) {
                testOperation = [[SDLAsynchronousRPCOperation alloc] initWithConnectionManager:testConnectionManager rpc:sendRPCs[i]];
                [testOperationQueue addOperation:testOperation];
            }

            expect(testConnectionManager.receivedRequests.count).toEventually(equal(rpcCount));
            expect(testConnectionManager.receivedRequests).toEventually(equal(sendRPCs));
        });
    });

    context(@"when a requst is cancelled", ^{
        __block __kindof SDLRPCMessage *sendRPC = nil;

        beforeEach(^{
            sendRPC = [[SDLGetAppServiceDataResponse alloc] initWithAppServiceData:[[SDLAppServiceData alloc] init]];
        });

        it(@"should not send the rpc", ^{
            testOperation = [[SDLAsynchronousRPCOperation alloc] initWithConnectionManager:testConnectionManager rpc:sendRPC];

            [testOperationQueue addOperation:testOperation];
            [testOperationQueue cancelAllOperations];

            [NSThread sleepForTimeInterval:1.0];

            expect(testConnectionManager.receivedRequests).toEventually(beEmpty());
        });
    });
});

QuickSpecEnd

