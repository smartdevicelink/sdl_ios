#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnCommand.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCRequestNotification.h"
#import "SDLRPCResponseNotification.h"

QuickSpecBegin(SDLNotificationDispatcherSpec)

describe(@"a notification dispatcher", ^{
    __block SDLNotificationDispatcher *testDispatcher = nil;
    
    beforeEach(^{
        testDispatcher = [[SDLNotificationDispatcher alloc] init];
    });
    
    describe(@"when told to post a notification", ^{
        __block NSString *testNotificationName = nil;
        __block NSString *testUserInfo = nil;
        __block NSNotification *returnNotification = nil;
        
        beforeEach(^{
            testNotificationName = @"com.test.notification";
            testUserInfo = @"testuserinfo";
            
            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                returnNotification = note;
            }];
            
            [testDispatcher postNotificationName:testNotificationName infoObject:testUserInfo];
        });
        
        it(@"should post", ^{
            expect(returnNotification.userInfo[SDLNotificationUserInfoObject]).toEventually(match(testUserInfo));
            expect(returnNotification.object).toEventually(equal(testDispatcher));
        });
    });

    describe(@"when told to post a response", ^{
        __block NSString *testNotificationName = nil;
        __block SDLAddCommandResponse *testResponse = nil;
        __block SDLRPCResponseNotification *testNotification = nil;

        beforeEach(^{
            testNotificationName = SDLDidReceiveAddCommandResponse;
            testResponse = [[SDLAddCommandResponse alloc] init];

            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                SDLRPCResponseNotification *requestNotification = (SDLRPCResponseNotification *)note;
                testNotification = requestNotification;
            }];

            [testDispatcher postRPCResponseNotification:testNotificationName response:testResponse];
        });

        it(@"should successfully post a response", ^{
            expect(testNotification.name).toEventually(equal(testNotificationName));
            expect(testNotification.response).toEventually(equal(testResponse));
            expect(testNotification.object).toEventually(equal(testDispatcher));
        });
    });

    describe(@"when told to post a request", ^{
        __block NSString *testNotificationName = nil;
        __block SDLAddCommand *testRequest = nil;
        __block SDLRPCRequestNotification *testNotification = nil;

        beforeEach(^{
            testNotificationName = SDLDidReceiveAddCommandRequest;
            testRequest = [[SDLAddCommand alloc] init];

            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                SDLRPCRequestNotification *requestNotification = (SDLRPCRequestNotification *)note;
                testNotification = requestNotification;
            }];

            [testDispatcher postRPCRequestNotification:testNotificationName request:testRequest];
        });

        it(@"should successfully post a request", ^{
            expect(testNotification.name).toEventually(equal(testNotificationName));
            expect(testNotification.request).toEventually(equal(testRequest));
            expect(testNotification.object).toEventually(equal(testDispatcher));
        });
    });

    describe(@"when told to post a notification", ^{
        __block NSString *testNotificationName = nil;
        __block SDLOnCommand *testNotificationRequest = nil;
        __block SDLRPCNotificationNotification *testNotification = nil;

        beforeEach(^{
            testNotificationName = SDLDidReceiveCommandNotification;
            testNotificationRequest = [[SDLOnCommand alloc] init];

            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                SDLRPCNotificationNotification *requestNotification = (SDLRPCNotificationNotification *)note;
                testNotification = requestNotification;
            }];

            [testDispatcher postRPCNotificationNotification:testNotificationName notification:testNotificationRequest];
        });

        it(@"should successfully post a notification", ^{
            expect(testNotification.name).toEventually(equal(testNotificationName));
            expect(testNotification.notification).toEventually(equal(testNotificationRequest));
            expect(testNotification.object).toEventually(equal(testDispatcher));
        });
    });
});

QuickSpecEnd
