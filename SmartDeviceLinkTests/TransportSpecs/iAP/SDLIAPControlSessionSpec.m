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

#import "EAAccessory+OCMock.m"
#import "SDLIAPControlSession.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"

//#import "SDLIAPControlSession.h"

//@interface SDLIAPControlSession ()
//@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
//@end

@interface SDLIAPControlSession()
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (nullable, strong, nonatomic) SDLIAPControlSessionRetryCompletionHandler retrySessionHandler;
@property (nullable, strong, nonatomic) SDLIAPControlSessionCreateDataSessionCompletionHandler createDataSessionHandler;
@end

QuickSpecBegin(SDLIAPControlSessionSpec)

describe(@"SDLIAPControlSession", ^{
    __block SDLIAPControlSession *controlSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block id mockSessionDelegate = nil;

    beforeEach(^{
        controlSession = [SDLIAPControlSession new];
        mockAccessory = [EAAccessory.class sdlCoreMock];
        mockSessionDelegate = OCMProtocolMock(@protocol(SDLIAPSessionDelegate));
    });

    describe(@"Initialization", ^{
        it(@"Should init correctly", ^{
            expect(controlSession.session).to(beNil());
            expect(controlSession.protocolIndexTimer).to(beNil());
        });
    });

    describe(@"Setting a session", ^{
        __block SDLIAPSession *session = nil;
        __block BOOL retryHandlerCalled = nil;
        __block BOOL createDataSessionHandlerCalled = nil;

        beforeEach(^{
            session = nil;
            retryHandlerCalled = NO;
            createDataSessionHandlerCalled = NO;
        });

        describe(@"When a session starts successfully", ^{
            beforeEach(^{
                session = OCMClassMock([SDLIAPSession class]);
                OCMStub([session start]).andReturn(YES);
                [controlSession setSession:session retryCompletionHandler:^(BOOL retryEstablishSession) {
                    retryHandlerCalled = YES;
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    createDataSessionHandlerCalled = YES;
                }];
            });

            it(@"Should create a session", ^{
                expect(controlSession.session).toNot(beNil());
                expect(controlSession.accessoryID).toNot(beNil());
                expect(controlSession.protocolIndexTimer).toNot(beNil());
                expect(retryHandlerCalled).to(beFalse());
                expect(createDataSessionHandlerCalled).to(beFalse());
            });
        });

        describe(@"When a session does not start successfully", ^{
            beforeEach(^{
                session = OCMClassMock([SDLIAPSession class]);
                OCMStub([session start]).andReturn(NO);
                [controlSession setSession:session retryCompletionHandler:^(BOOL retryEstablishSession) {
                    retryHandlerCalled = YES;
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    createDataSessionHandlerCalled = YES;
                }];
            });

            it(@"Should not create a session", ^{
                expect(controlSession.session).to(beNil());
                expect(controlSession.accessoryID).to(equal(0));
                expect(controlSession.protocolIndexTimer).to(beNil());
                expect(retryHandlerCalled).to(beTrue());
                expect(createDataSessionHandlerCalled).to(beFalse());
            });
        });

        describe(@"When a session is nil", ^{
            beforeEach(^{
                session = nil;
                [controlSession setSession:session retryCompletionHandler:^(BOOL retryEstablishSession) {
                    retryHandlerCalled = YES;
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    createDataSessionHandlerCalled = YES;
                }];
            });

            it(@"Should not create a session", ^{
                expect(controlSession.session).to(beNil());
                expect(controlSession.accessoryID).to(equal(0));
                expect(controlSession.protocolIndexTimer).to(beNil());
                expect(retryHandlerCalled).to(beTrue());
                expect(createDataSessionHandlerCalled).to(beFalse());
            });
        });
    });
});

QuickSpecEnd
