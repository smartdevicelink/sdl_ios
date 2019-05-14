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
#import "SDLIAPControlSessionDelegate.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"


@interface SDLIAPControlSession()
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (weak, nonatomic) id<SDLIAPControlSessionDelegate> delegate;
@end

QuickSpecBegin(SDLIAPControlSessionSpec)

describe(@"SDLIAPControlSession", ^{
    __block SDLIAPControlSession *controlSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block SDLIAPSession *mockSession = nil;
    __block id<SDLIAPControlSessionDelegate> mockDelegate = nil;

    beforeEach(^{
        mockDelegate = OCMProtocolMock(@protocol(SDLIAPControlSessionDelegate));
        mockAccessory = [EAAccessory.class sdlCoreMock];
        mockSession = OCMClassMock([SDLIAPSession class]);
        OCMStub([mockSession accessory]).andReturn(mockAccessory);
    });

    describe(@"init", ^{
        context(@"with a valid session", ^{
            beforeEach(^{
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession delegate:mockDelegate];
            });

            it(@"Should get/set correctly", ^{
                expect(controlSession.session).toNot(beNil());
                expect(controlSession.connectionID).to(equal(5));
                expect(controlSession.delegate).to(equal(mockDelegate));
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

        context(@"with a nil session", ^{
            beforeEach(^{
                controlSession = [[SDLIAPControlSession alloc] initWithSession:nil delegate:mockDelegate];
            });

            it(@"Should get/set correctly", ^{
                expect(controlSession.session).to(beNil());
                expect(controlSession.connectionID).to(equal(0));
                expect(controlSession.delegate).to(equal(mockDelegate));
            });

            describe(@"When checking if the session is in progress", ^{
                it(@"Should not be in progress if the session is stopped because the session is `nil`", ^{
                    OCMStub([mockSession isStopped]).andReturn(NO);
                    expect(controlSession.isSessionInProgress).to(beFalse());
                });

                it(@"Should be in progress if the session is running becasue the session is `nil`", ^{
                    OCMStub([mockSession isStopped]).andReturn(YES);
                    expect(controlSession.isSessionInProgress).to(beFalse());
                });
            });
        });
    });

    describe(@"Starting a session", ^{
        describe(@"When a session starts successfully", ^{
            beforeEach(^{
                OCMStub([mockSession start]).andReturn(YES);
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession delegate:mockDelegate];
                [controlSession startSession];
            });

            it(@"Should create a timer", ^{
                expect(controlSession.protocolIndexTimer).toNot(beNil());
            });

            it(@"Should not try to establish a new session", ^{
                OCMReject([mockDelegate retryControlSession]);
                OCMReject([mockDelegate controlSession:[OCMArg any] didGetProtocolString:[OCMArg any] forConnectedAccessory:[OCMArg any]]);
            });
        });

        describe(@"When a session does not start successfully", ^{
            beforeEach(^{
                OCMStub([mockSession start]).andReturn(NO);
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession delegate:mockDelegate];
                [controlSession startSession];
            });

            it(@"Should not create a timer", ^{
                expect(controlSession.protocolIndexTimer).to(beNil());
            });

            it(@"Should try to establish a new session", ^{
                OCMVerify([mockDelegate retryControlSession]);
                OCMReject([mockDelegate controlSession:[OCMArg any] didGetProtocolString:[OCMArg any] forConnectedAccessory:[OCMArg any]]);
            });

            it(@"Should should stop and destroy the session", ^{
                expect(controlSession.session).to(beNil());
                expect(controlSession.connectionID).to(equal(0));
            });

            it(@"Should should stop but not destroy the session", ^{
                OCMVerify([mockSession stop]);
            });
        });

        describe(@"When a session can not be started because the session is nil", ^{
            beforeEach(^{
                controlSession = [[SDLIAPControlSession alloc] initWithSession:nil delegate:mockDelegate];
                [controlSession startSession];
            });

            it(@"Should not create a timer", ^{
                expect(controlSession.protocolIndexTimer).to(beNil());
            });

            it(@"Should return a connectionID of zero", ^{
                expect(controlSession.connectionID).to(equal(0));
            });

            it(@"Should try to establish a new session", ^{
                OCMVerify([mockDelegate retryControlSession]);
                OCMReject([mockDelegate controlSession:[OCMArg any] didGetProtocolString:[OCMArg any] forConnectedAccessory:[OCMArg any]]);
            });
        });
    });

    describe(@"Stopping a session", ^{
        context(@"That is nil", ^{
            beforeEach(^{
                mockSession = nil;
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession delegate:mockDelegate];
                [controlSession stopSession];
            });

            it(@"Should not try to stop the session", ^{
                expect(controlSession.session).to(beNil());
                OCMReject([mockSession stop]);
            });
        });

        context(@"That is started", ^{
            beforeEach(^{
                controlSession = [[SDLIAPControlSession alloc] initWithSession:mockSession delegate:mockDelegate];
                [controlSession stopSession];
            });

            it(@"Should try to stop the session", ^{
                expect(controlSession.session).to(beNil());
                expect(controlSession.session.streamDelegate).to(beNil());
                OCMVerify([mockSession stop]);
            });
        });
    });
});

QuickSpecEnd
