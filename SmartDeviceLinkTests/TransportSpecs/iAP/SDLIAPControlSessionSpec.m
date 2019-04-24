//
//  SDLIAPControlSessionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLIAPControlSession.h"

#import "EAAccessory+OCMock.m"
#import "SDLIAPConstants.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"


@interface SDLIAPControlSession()
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@end

QuickSpecBegin(SDLIAPControlSessionSpec)

describe(@"SDLIAPControlSession", ^{
    __block SDLIAPControlSession *controlSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block SDLIAPSession *mockSession = nil;
    __block BOOL retryHandlerCalled = nil;
    __block BOOL createDataSessionHandlerCalled = nil;

    beforeEach(^{
        retryHandlerCalled = NO;
        createDataSessionHandlerCalled = NO;

        mockAccessory = [EAAccessory.class sdlCoreMock];
        mockSession = OCMClassMock([SDLIAPSession class]);
        OCMStub([mockSession accessory]).andReturn(mockAccessory);
    });

    describe(@"init", ^{
        describe(@"When a session starts successfully", ^{
            beforeEach(^{
                OCMStub([mockSession start]).andReturn(YES);
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession retrySessionCompletionHandler:^{
                    retryHandlerCalled = YES;
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    createDataSessionHandlerCalled = YES;
                }];
            });

            it(@"Should set the session", ^{
                expect(controlSession.session).toNot(beNil());
                expect(controlSession.connectionID).to(equal(5));
            });

            it(@"Should create a timer", ^{
                expect(controlSession.protocolIndexTimer).toNot(beNil());
            });

            it(@"Should not try to establish a new session", ^{
                expect(retryHandlerCalled).to(beFalse());
                expect(createDataSessionHandlerCalled).to(beFalse());
            });

            describe(@"When checking if the session is in progress", ^{
                it(@"Should not be in progress if the session is stopped", ^{
                    OCMStub([mockSession isStopped]).andReturn(NO);
                    expect(controlSession.isSessionInProgress).to(beTrue());
                });

                it(@"Should be in progress if the session is running", ^{
                    OCMStub([mockSession isStopped]).andReturn(YES);
                    expect(controlSession.isSessionInProgress).to(beFalse());
                });
            });
        });

        describe(@"When a session does not start successfully", ^{
            beforeEach(^{
                OCMStub([mockSession start]).andReturn(NO);
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession retrySessionCompletionHandler:^{
                    retryHandlerCalled = YES;
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    createDataSessionHandlerCalled = YES;
                }];
            });

            it(@"Should not create a timer", ^{
                expect(controlSession.protocolIndexTimer).to(beNil());
            });

            it(@"Should try to establish a new session", ^{
                expect(retryHandlerCalled).to(beTrue());
                expect(createDataSessionHandlerCalled).to(beFalse());
            });

            it(@"Should should stop but not destroy the session", ^{
                expect(controlSession.session).toNot(beNil());
                expect(controlSession.connectionID).to(equal(5));

                OCMVerify([mockSession stop]);
            });
        });

        describe(@"When a session is nil", ^{
            beforeEach(^{
                mockSession = nil;
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession retrySessionCompletionHandler:^{
                    retryHandlerCalled = YES;
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    createDataSessionHandlerCalled = YES;
                }];
            });

            it(@"Should not set the session", ^{
                expect(controlSession.session).to(beNil());
            });

            it(@"Should not create a timer", ^{
                expect(controlSession.protocolIndexTimer).to(beNil());
            });

            it(@"Should return a connectionID of zero", ^{
                expect(controlSession.connectionID).to(equal(0));
            });

            it(@"Should try to establish a new session", ^{
                expect(retryHandlerCalled).to(beTrue());
                expect(createDataSessionHandlerCalled).to(beFalse());
            });

            describe(@"When checking if the session is in progress", ^{
                it(@"Should not be in progress if the session is nil", ^{
                    expect(controlSession.isSessionInProgress).to(beFalse());
                });
            });
        });
    });
});

QuickSpecEnd
