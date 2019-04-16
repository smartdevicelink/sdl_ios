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
#import "SDLTimer.h"
#import "SDLIAPSession.h"

@interface SDLIAPControlSession ()
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
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

    describe(@"Creating a session", ^{
        __block SDLIAPSession *session = nil;

        beforeEach(^{
            session = [SDLIAPControlSession createSessionWithAccessory:mockAccessory];
        });

        it(@"Should init correctly", ^{
            expect(session).toNot(beNil());
        });
    });

    describe(@"Setting a session", ^{
        __block SDLIAPSession *session = nil;

        beforeEach(^{
            session = nil;
        });

        describe(@"When a session starts successfully", ^{
            beforeEach(^{
                session = OCMClassMock([SDLIAPSession class]);
                OCMStub([session start]).andReturn(YES);
                [controlSession setSession:session delegate:mockSessionDelegate retryCompletionHandler:^(BOOL retryEstablishSession) {
                    //TODO
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    //TODO
                }];
            });

            it(@"Should create a session", ^{
                expect(controlSession.session).toNot(beNil());
                expect(controlSession.accessoryID).toNot(beNil());
                expect(controlSession.protocolIndexTimer).toNot(beNil());
            });
        });

        describe(@"When a session does not start successfully", ^{
            beforeEach(^{
                session = OCMClassMock([SDLIAPSession class]);
                OCMStub([session start]).andReturn(NO);
                [controlSession setSession:session delegate:mockSessionDelegate retryCompletionHandler:^(BOOL retryEstablishSession) {
                    expect(retryEstablishSession).to(beTrue());
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    //TODO
                }];
            });

            it(@"Should not create a session", ^{
                expect(controlSession.session).to(beNil());
                expect(controlSession.accessoryID).to(equal(0));
                expect(controlSession.protocolIndexTimer).to(beNil());
            });
        });

        describe(@"When a session is nil", ^{
            beforeEach(^{
                session = nil;
                [controlSession setSession:session delegate:mockSessionDelegate retryCompletionHandler:^(BOOL retryEstablishSession) {
                    expect(retryEstablishSession).to(beTrue());
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                    //TODO
                }];
            });

            it(@"Should not create a session", ^{
                expect(controlSession.session).to(beNil());
                expect(controlSession.accessoryID).to(equal(0));
                expect(controlSession.protocolIndexTimer).to(beNil());
            });
        });
    });
});

QuickSpecEnd
