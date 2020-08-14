//
//  SDLLifecycleSyncPDataHandler.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/24/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLEncodedSyncPData.h"
#import "SDLLifecycleSyncPDataHandler.h"
#import "SDLNotificationConstants.h"
#import "SDLOnEncodedSyncPData.h"
#import "SDLRPCNotificationNotification.h"

#import "TestConnectionManager.h"

@interface SDLLifecycleSyncPDataHandler ()

@property (strong, nonatomic) NSURLSession *urlSession;

@end

QuickSpecBegin(SDLLifecycleSyncPDataHandlerSpec)

describe(@"Test SDLLifecycleSyncPDataHandler", ^{
    __block SDLLifecycleSyncPDataHandler *testHandler = nil;
    __block TestConnectionManager *mockConnectionManager = nil;
    __block NSURLSession *mockSession = nil;

    beforeEach(^{
        mockSession = OCMClassMock([NSURLSession class]);

        NSData *receivedData = [NSJSONSerialization dataWithJSONObject:@{@"data": @[@"1234"]} options:kNilOptions error:nil];
        OCMStub([mockSession uploadTaskWithRequest:[OCMArg any] fromData:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:receivedData, [[NSURLResponse alloc] init], [NSNull null], nil])]);

        mockConnectionManager = [[TestConnectionManager alloc] init];
        testHandler = [[SDLLifecycleSyncPDataHandler alloc] initWithConnectionManager:mockConnectionManager];
        testHandler.urlSession = mockSession;
    });

    describe(@"when a OnEncodedSyncPData request comes in", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        __block SDLOnEncodedSyncPData *testRPC = nil;
#pragma clang diagnostic pop
        beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRPC = [[SDLOnEncodedSyncPData alloc] init];
#pragma clang diagnostic pop
            testRPC.URL = @"https://www.google.com";
            testRPC.Timeout = @(30);
            testRPC.data = @[@"1234/5678"];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveEncodedDataNotification object:nil rpcNotification:testRPC];
#pragma clang diagnostic pop
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should send a EncodedSyncPData request", ^{
            expect(mockConnectionManager.receivedRequests).to(haveCount(1));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLEncodedSyncPData *sentRequest = mockConnectionManager.receivedRequests[0];
#pragma clang diagnostic pop
            expect(sentRequest.data).to(equal(@[@"1234"]));
        });
    });
});

QuickSpecEnd
