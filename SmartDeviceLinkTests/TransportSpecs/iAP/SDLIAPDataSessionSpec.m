//
//  SDLIAPDataSessionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 4/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLIAPDataSession.h"

#import "EAAccessory+OCMock.m"
#import "SDLIAPConstants.h"
#import "SDLIAPSession.h"
#import "SDLIAPDataSessionDelegate.h"

@interface SDLIAPDataSession()
@property (weak, nonatomic) id<SDLIAPDataSessionDelegate> delegate;
@end

QuickSpecBegin(SDLIAPDataSessionSpec)

describe(@"SDLIAPDataSession", ^{
    __block SDLIAPDataSession *dataSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block SDLIAPSession *mockSession = nil;
    __block id<SDLIAPDataSessionDelegate> mockDelegate = nil;

    beforeEach(^{
        mockDelegate = OCMProtocolMock(@protocol(SDLIAPDataSessionDelegate));
        mockAccessory = [EAAccessory.class sdlCoreMock];
        mockSession = OCMClassMock([SDLIAPSession class]);
        OCMStub([mockSession accessory]).andReturn(mockAccessory);
    });

    describe(@"init", ^{
        context(@"with a valid session", ^{
            beforeEach(^{
                dataSession = [[SDLIAPDataSession alloc] initWithSession:mockSession delegate:mockDelegate];
            });

            it(@"Should get/set correctly", ^{
                expect(dataSession.session).toNot(beNil());
                expect(dataSession.connectionID).to(equal(5));
                expect(dataSession.delegate).to(equal(mockDelegate));
            });

            describe(@"When checking if the session is in progress", ^{
                it(@"Should not be in progress if the session is stopped", ^{
                    OCMStub([mockSession isStopped]).andReturn(NO);
                    expect(dataSession.isSessionInProgress).to(beTrue());
                });

                it(@"Should be in progress if the session is running", ^{
                    OCMStub([mockSession isStopped]).andReturn(YES);
                    expect(dataSession.isSessionInProgress).to(beFalse());
                });
            });
        });

        context(@"with a nil session", ^{
            beforeEach(^{
                dataSession = [[SDLIAPDataSession alloc] initWithSession:nil delegate:mockDelegate];
            });

            it(@"Should get/set correctly", ^{
                expect(dataSession.session).to(beNil());
                expect(dataSession.connectionID).to(equal(0));
                expect(dataSession.delegate).to(equal(mockDelegate));
            });

            describe(@"When checking if the session is in progress", ^{
                it(@"Should not be in progress if the session is stopped because the session is `nil`", ^{
                    OCMStub([mockSession isStopped]).andReturn(NO);
                    expect(dataSession.isSessionInProgress).to(beFalse());
                });

                it(@"Should be in progress if the session is running becasue the session is `nil`", ^{
                    OCMStub([mockSession isStopped]).andReturn(YES);
                    expect(dataSession.isSessionInProgress).to(beFalse());
                });
            });
        });
    });


    describe(@"Starting a session", ^{
        xdescribe(@"When a session starts successfully", ^{
            beforeEach(^{
                OCMStub([mockSession start]).andReturn(YES);
                dataSession = [[SDLIAPDataSession alloc] initWithSession:mockSession delegate:mockDelegate];
                [dataSession startSession];
            });

            it(@"Should not try to establish a new session", ^{
                OCMReject([mockDelegate retryDataSession]);
                OCMReject([mockDelegate dataReceived:[OCMArg any]]);
            });
        });

        describe(@"When a session does not start successfully", ^{
            beforeEach(^{
                OCMStub([mockSession start]).andReturn(NO);
                dataSession = [[SDLIAPDataSession alloc] initWithSession:mockSession delegate:mockDelegate];
                [dataSession startSession];
            });

            it(@"Should try to establish a new session", ^{
                OCMVerify([mockDelegate retryDataSession]);
                OCMReject([mockDelegate dataReceived:[OCMArg any]]);
            });

            it(@"Should should stop and destroy the session", ^{
                expect(dataSession.session).to(beNil());
                expect(dataSession.connectionID).to(equal(0));
                OCMVerify([mockSession stop]);
            });
        });

        describe(@"When a session can not be started because the session is nil", ^{
            beforeEach(^{
                dataSession = [[SDLIAPDataSession alloc] initWithSession:nil delegate:mockDelegate];
                [dataSession startSession];
            });

            it(@"Should return a connectionID of zero", ^{
                expect(dataSession.connectionID).to(equal(0));
            });

            it(@"Should try to establish a new session", ^{
                OCMVerify([mockDelegate retryDataSession]);
                OCMReject([mockDelegate dataReceived:[OCMArg any]]);
            });
        });
    });

    describe(@"Stopping a session", ^{
        context(@"That is nil", ^{
            beforeEach(^{
                dataSession = [[SDLIAPDataSession alloc] initWithSession:nil delegate:mockDelegate];
                [dataSession stopSession];
            });

            it(@"Should not try to stop the session", ^{
                expect(dataSession.session).to(beNil());
            });
        });

        context(@"That is started", ^{
            beforeEach(^{
                dataSession = [[SDLIAPDataSession alloc] initWithSession:mockSession delegate:mockDelegate];
                [dataSession stopSession];
            });

            it(@"Should try to stop and detroy the session", ^{
                expect(dataSession.session).to(beNil());
                expect(dataSession.session.streamDelegate).to(beNil());
                OCMVerify([mockSession stop]);
            });
        });
    });
});

QuickSpecEnd


