//
//  SDLLifecycleSystemRequestHandlerSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/24/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLCacheFileManager.h"
#import "SDLFileType.h"
#import "SDLLifecycleSystemRequestHandler.h"
#import "SDLNotificationConstants.h"
#import "SDLOnSystemRequest.h"
#import "SDLPolicyDataParser.h"
#import "SDLPutFile.h"
#import "SDLRequestType.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSystemRequest.h"

#import "TestConnectionManager.h"

@interface SDLLifecycleSystemRequestHandler ()

@property (strong, nonatomic) SDLCacheFileManager *cacheFileManager;
@property (strong, nonatomic) NSURLSession *urlSession;

@property (strong, nonatomic) SDLPolicyDataParser *policyDataParser;

@end

QuickSpecBegin(SDLLifecycleSystemRequestHandlerSpec)

describe(@"SDLLifecycleSystemRequestHandler tests", ^{
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLLifecycleSystemRequestHandler *testManager = nil;
    __block id mockSession = nil;
    __block id mockCacheManager = nil;
    __block id mockPolicyParser = nil;

    beforeEach(^{
        mockCacheManager = OCMClassMock([SDLCacheFileManager class]);
        mockSession = OCMStrictClassMock([NSURLSession class]);
        mockPolicyParser = OCMClassMock([SDLPolicyDataParser class]);

        mockConnectionManager = [[TestConnectionManager alloc] init];

        testManager = [[SDLLifecycleSystemRequestHandler alloc] initWithConnectionManager:mockConnectionManager];
        testManager.urlSession = mockSession;
        testManager.cacheFileManager = mockCacheManager;
    });

    describe(@"when receiving an OnSystemRequest", ^{
        __block SDLOnSystemRequest *receivedSystemRequest = nil;
        beforeEach(^{
            receivedSystemRequest = [[SDLOnSystemRequest alloc] init];
        });

        context(@"of type PROPRIETARY", ^{
            beforeEach(^{
                receivedSystemRequest.requestType = SDLRequestTypeProprietary;
                receivedSystemRequest.url = @"https://www.google.com";

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemRequestNotification object:nil rpcNotification:receivedSystemRequest];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should send a SystemRequest", ^{

            });
        });

        context(@"of type LOCK_SCREEN_URL", ^{
            __block id lockScreenIconObserver = nil;

            beforeEach(^{
                receivedSystemRequest.requestType = SDLRequestTypeLockScreenIconURL;

                UIImage *testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
                OCMStub([mockCacheManager retrieveImageForRequest:[OCMArg any] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);

                lockScreenIconObserver = OCMObserverMock();
                [[NSNotificationCenter defaultCenter] addMockObserver:lockScreenIconObserver name:SDLDidReceiveLockScreenIcon object:nil];
                [[lockScreenIconObserver expect] notificationWithName:SDLDidReceiveLockScreenIcon object:[OCMArg any] userInfo:[OCMArg any]];

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemRequestNotification object:nil rpcNotification:receivedSystemRequest];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should pass the url to the cache manager and then send a notification", ^{
                OCMVerifyAll(lockScreenIconObserver);
            });
        });

        context(@"of type ICON_URL", ^{
            beforeEach(^{
                receivedSystemRequest.requestType = SDLRequestTypeIconURL;
                receivedSystemRequest.url = @"https://www.google.com";

                NSData *data = [@"1234" dataUsingEncoding:NSASCIIStringEncoding];
                OCMStub([mockSession dataTaskWithURL:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:data, [NSURLResponse new], [NSNull null], nil])]);

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemRequestNotification object:nil rpcNotification:receivedSystemRequest];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should send a SystemRequest", ^{
                expect(mockConnectionManager.receivedRequests).to(haveCount(1));
                expect(mockConnectionManager.receivedRequests[0]).to(beAnInstanceOf([SDLSystemRequest class]));
            });
        });

        context(@"of type HTTP", ^{
            __block NSData *urlReceivedData = nil;

            beforeEach(^{
                receivedSystemRequest.requestType = SDLRequestTypeHTTP;
                receivedSystemRequest.url = @"https://www.google.com";
                receivedSystemRequest.bulkData = [@"1234" dataUsingEncoding:NSASCIIStringEncoding];

                urlReceivedData = [NSJSONSerialization dataWithJSONObject:@{@"data": @[@"1234"]} options:kNilOptions error:nil];
                OCMStub([mockSession uploadTaskWithRequest:[OCMArg any] fromData:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:urlReceivedData, [[NSURLResponse alloc] init], [NSNull null], nil])]).andReturn(nil);

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemRequestNotification object:nil rpcNotification:receivedSystemRequest];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should send a PutFile after receiving a response", ^{
                expect(mockConnectionManager.receivedRequests).to(haveCount(1));

                SDLPutFile *putFile = mockConnectionManager.receivedRequests[0];
                expect(putFile.fileType).to(equal(SDLFileTypeJSON));
                expect(putFile.sdlFileName).to(equal(@"response_data"));
                expect(putFile.bulkData).to(equal(urlReceivedData));
            });
        });

        context(@"of type LAUNCH_APP", ^{
            __block id mockedApplication = nil;

            beforeEach(^{
                receivedSystemRequest.requestType = SDLRequestTypeLaunchApp;
                receivedSystemRequest.url = @"myApp://";

                mockedApplication = OCMClassMock([UIApplication class]);
                OCMStub([mockedApplication sharedApplication]).andReturn(mockedApplication);
                OCMExpect([mockedApplication openURL:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [((NSURL *)obj).absoluteString isEqualToString:@"myApp://"];
                }]]);

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemRequestNotification object:nil rpcNotification:receivedSystemRequest];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [NSThread sleepForTimeInterval:0.5];
            });

            it(@"should have attempted to open the URL", ^{
                OCMVerifyAll(mockedApplication);
            });

            afterEach(^{
                [mockedApplication stopMocking];
            });
        });

        context(@"of another type", ^{
            beforeEach(^{
                receivedSystemRequest.requestType = SDLRequestTypeFOTA;
            });

            it(@"should do nothing", ^{
                // TODO
            });
        });
    });
});

QuickSpecEnd
