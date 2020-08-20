//
//  SDLLifecycleMobileHMIStateHandler.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/24/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLifecycleMobileHMIStateHandler.h"
#import "SDLNotificationConstants.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLMsgVersion.h"

#import "TestConnectionManager.h"

QuickSpecBegin(SDLLifecycleMobileHMIStateHandlerSpec)

describe(@"SDLLifecycleMobileHMIStateHandler tests", ^{
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLLifecycleMobileHMIStateHandler *testManager = nil;

    beforeEach(^{
        mockConnectionManager = [[TestConnectionManager alloc] init];
        testManager = [[SDLLifecycleMobileHMIStateHandler alloc] initWithConnectionManager:mockConnectionManager];
    });

    context(@"before a RAIR", ^{
        it(@"should do nothing if the app changes foreground states", ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];

            expect(mockConnectionManager.receivedRequests).to(beEmpty());
        });
    });

    context(@"after a RAIR", ^{
        context(@"with msg version < 4", ^{
            beforeEach(^{
                SDLRegisterAppInterfaceResponse *rair = [[SDLRegisterAppInterfaceResponse alloc] init];
                rair.sdlMsgVersion = [[SDLMsgVersion alloc] initWithMajorVersion:3 minorVersion:0 patchVersion:0];

                SDLRPCResponseNotification *responseNotification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:nil rpcResponse:rair];
                [[NSNotificationCenter defaultCenter] postNotification:responseNotification];
            });

            it(@"should do nothing if the app changes foreground states", ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];

                expect(mockConnectionManager.receivedRequests).to(beEmpty());
            });
        });

        context(@"with msg version >= 4", ^{
            beforeEach(^{
                SDLRegisterAppInterfaceResponse *rair = [[SDLRegisterAppInterfaceResponse alloc] init];
                rair.sdlMsgVersion = [[SDLMsgVersion alloc] initWithMajorVersion:5 minorVersion:0 patchVersion:0];

                SDLRPCResponseNotification *responseNotification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:nil rpcResponse:rair];
                [[NSNotificationCenter defaultCenter] postNotification:responseNotification];
            });

            it(@"should send an OnHMIStatus as well as another if the app changes foreground states", ^{
                expect(mockConnectionManager.receivedRequests).to(haveCount(1));

                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
                expect(mockConnectionManager.receivedRequests).to(haveCount(2));
            });

            describe(@"after the manager is stopped", ^{
                beforeEach(^{
                    [mockConnectionManager.receivedRequests removeAllObjects];
                    [testManager stop];
                });

                it(@"should do nothing if the app changes foreground states", ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];

                    expect(mockConnectionManager.receivedRequests).to(beEmpty());
                });
            });
        });
    });
});

QuickSpecEnd
