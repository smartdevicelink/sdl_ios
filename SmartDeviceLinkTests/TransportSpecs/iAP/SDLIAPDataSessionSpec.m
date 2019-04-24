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

QuickSpecBegin(SDLIAPDataSessionSpec)

describe(@"SDLIAPDataSession", ^{
    __block SDLIAPDataSession *dataSession = nil;
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

    describe(@"When a session starts successfully", ^{
        beforeEach(^{
            OCMStub([mockSession start]).andReturn(YES);
            dataSession = [[SDLIAPDataSession alloc] initWithSession:mockSession retrySessionCompletionHandler:^{
                retryHandlerCalled = YES;
            } dataReceivedCompletionHandler:^(NSData * _Nonnull dataIn) {
                createDataSessionHandlerCalled = YES;
            }];
        });

        it(@"Should set the sesion", ^{
            expect(dataSession.session).toNot(beNil());
            expect(dataSession.connectionID).to(equal(5));
            expect(retryHandlerCalled).to(beFalse());
            expect(createDataSessionHandlerCalled).to(beFalse());
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

    describe(@"When a session does not start successfully", ^{
        beforeEach(^{
            OCMStub([mockSession start]).andReturn(NO);
            dataSession = [[SDLIAPDataSession alloc] initWithSession:mockSession retrySessionCompletionHandler:^{
                retryHandlerCalled = YES;
            } dataReceivedCompletionHandler:^(NSData * _Nonnull dataIn) {
                createDataSessionHandlerCalled = YES;
            }];
        });

        it(@"Should attempt to create a new session", ^{
            expect(dataSession.session).toNot(beNil());
            expect(dataSession.connectionID).to(equal(5));
            expect(retryHandlerCalled).to(beTrue());
            expect(createDataSessionHandlerCalled).to(beFalse());
        });
    });
});

QuickSpecEnd


