#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLLifecycleManager.h"

#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLManagerDelegate.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnHashChange.h"
#import "SDLOnHMIStatus.h"
#import "SDLPermissionManager.h"
#import "SDLProxy.h"
#import "SDLProxyFactory.h"
#import "SDLRegisterAppInterface.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCRequestFactory.h"
#import "SDLShow.h"
#import "SDLStateMachine.h"
#import "SDLTextAlignment.h"
#import "SDLUnregisterAppInterface.h"
#import "SDLUnregisterAppInterfaceResponse.h"


typedef NSString SDLLifecycleState;
SDLLifecycleState *const SDLLifecycleStateDisconnected = @"TransportDisconnected";
SDLLifecycleState *const SDLLifecycleStateTransportConnected = @"TransportConnected";
SDLLifecycleState *const SDLLifecycleStateRegistered = @"Registered";
SDLLifecycleState *const SDLLifecycleStateSettingUpManagers = @"SettingUpManagers";
SDLLifecycleState *const SDLLifecycleStatePostManagerProcessing = @"PostManagerProcessing";
SDLLifecycleState *const SDLLifecycleStateUnregistering = @"Unregistering";
SDLLifecycleState *const SDLLifecycleStateReady = @"Ready";


// Ignore the deprecated proxy methods
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

QuickConfigurationBegin(SendingRPCsConfiguration)

+ (void)configure:(Configuration *)configuration {
    sharedExamples(@"unable to send an RPC", ^(QCKDSLSharedExampleContext exampleContext) {
        it(@"cannot publicly send RPCs", ^{
            __block NSError *testError = nil;
            SDLLifecycleManager *testManager = exampleContext()[@"manager"];
            SDLShow *testShow = [SDLRPCRequestFactory buildShowWithMainField1:@"test" mainField2:nil alignment:nil correlationID:@1];
            
            [testManager sendRequest:testShow withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                testError = error;
            }];
            
            expect(testError).to(equal([NSError sdl_lifecycle_notReadyError]));
        });
    });
}

QuickConfigurationEnd


QuickSpecBegin(SDLLifecycleManagerSpec)

describe(@"a lifecycle manager", ^{
    __block SDLLifecycleManager *testManager = nil;
    __block SDLConfiguration *testConfig = nil;
    
    __block id managerDelegateMock = OCMProtocolMock(@protocol(SDLManagerDelegate));
    __block id proxyBuilderClassMock = OCMStrictClassMock([SDLProxyFactory class]);
    __block id proxyMock = OCMClassMock([SDLProxy class]);
    __block id lockScreenManagerMock = OCMClassMock([SDLLockScreenManager class]);
    __block id fileManagerMock = OCMClassMock([SDLFileManager class]);
    __block id permissionManagerMock = OCMClassMock([SDLPermissionManager class]);
    
    beforeEach(^{
        OCMStub([proxyBuilderClassMock buildSDLProxyWithListener:[OCMArg any]]).andReturn(proxyMock);
        
        SDLLifecycleConfiguration *testLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:@"Test App" appId:@"Test Id"];
        testLifecycleConfig.shortAppName = @"Short Name";
        
        testConfig = [SDLConfiguration configurationWithLifecycle:testLifecycleConfig lockScreen:[SDLLockScreenConfiguration disabledConfiguration]];
        testManager = [[SDLLifecycleManager alloc] initWithConfiguration:testConfig delegate:managerDelegateMock];
        testManager.lockScreenManager = lockScreenManagerMock;
        testManager.fileManager = fileManagerMock;
        testManager.permissionManager = permissionManagerMock;
    });
    
    it(@"should initialize properties", ^{
        expect(testManager.configuration).to(equal(testConfig));
        expect(testManager.delegate).to(equal(managerDelegateMock));
        expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
        expect(@(testManager.lastCorrelationId)).to(equal(@0));
        expect(testManager.fileManager).toNot(beNil());
        expect(testManager.permissionManager).toNot(beNil());
        expect(testManager.streamManager).to(beNil());
        expect(testManager.proxy).to(beNil());
        expect(testManager.registerAppInterfaceResponse).to(beNil());
        expect(testManager.lockScreenManager).toNot(beNil());
        expect(testManager.notificationDispatcher).toNot(beNil());
        expect(testManager.responseDispatcher).toNot(beNil());
        expect(@([testManager conformsToProtocol:@protocol(SDLConnectionManagerType)])).to(equal(@YES));
    });
    
    itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
    
    describe(@"after receiving an HMI Status", ^{
        __block SDLOnHMIStatus *testHMIStatus = nil;
        __block SDLHMILevel *testHMILevel = nil;
        
        beforeEach(^{
            testHMIStatus = [[SDLOnHMIStatus alloc] init];
        });
        
        context(@"a non-none hmi level", ^{
            beforeEach(^{
                testHMILevel = [SDLHMILevel NONE];
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postNotificationName:SDLDidChangeHMIStatusNotification infoObject:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
            });
        });
        
        context(@"a non-full, non-none hmi level", ^{
            beforeEach(^{
                testHMILevel = [SDLHMILevel BACKGROUND];
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postNotificationName:SDLDidChangeHMIStatusNotification infoObject:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
            });
        });
        
        context(@"a full hmi level", ^{
            beforeEach(^{
                testHMILevel = [SDLHMILevel FULL];
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postNotificationName:SDLDidChangeHMIStatusNotification infoObject:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
            });
        });
    });
    
    describe(@"calling stop", ^{
        beforeEach(^{
            [testManager stop];
        });
        
        it(@"should do nothing", ^{
            expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
        });
    });
    
    describe(@"when started", ^{
        beforeEach(^{
            [testManager startWithHandler:^(BOOL success, NSError * _Nullable error) {}];
        });
        
        it(@"should initialize the proxy property", ^{
            expect(testManager.proxy).toNot(beNil());
            expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
        });
        
        describe(@"after receiving a connect notification", ^{
            beforeEach(^{
                // When we connect, we should be creating an sending an RAI
                OCMExpect([proxyMock sendRPC:[OCMArg isKindOfClass:[SDLRegisterAppInterface class]]]);
                
                [testManager.notificationDispatcher postNotificationName:SDLTransportDidConnect infoObject:nil];
                [NSThread sleepForTimeInterval:0.1];
            });
            
            it(@"should send a register app interface request and be in the connected state", ^{
                OCMVerifyAllWithDelay(proxyMock, 0.5);
                expect(testManager.lifecycleState).to(match(SDLLifecycleStateTransportConnected));
            });
            
            itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
            
            describe(@"after receiving a disconnect notification", ^{
                beforeEach(^{
                    [testManager.notificationDispatcher postNotificationName:SDLTransportDidDisconnect infoObject:nil];
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should be in the disconnect state", ^{
                    expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
                });
            });
            
            describe(@"stopping the manager", ^{
                beforeEach(^{
                    [testManager stop];
                });
                
                it(@"should simply disconnect", ^{
                    expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
                });
            });
        });
        
        describe(@"in the connected state", ^{
            beforeEach(^{
                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateTransportConnected];
            });
            
            describe(@"after receiving a register app interface response", ^{
                __block NSError *fileManagerStartError = [NSError errorWithDomain:@"testDomain" code:0 userInfo:nil];
                __block NSError *permissionManagerStartError = [NSError errorWithDomain:@"testDomain" code:0 userInfo:nil];
                
                beforeEach(^{
                    OCMStub([(SDLLockScreenManager *)lockScreenManagerMock start]);
                    OCMStub([fileManagerMock startWithCompletionHandler:([OCMArg invokeBlockWithArgs:@(YES), fileManagerStartError, nil])]);
                    OCMStub([permissionManagerMock startWithCompletionHandler:([OCMArg invokeBlockWithArgs:@(YES), permissionManagerStartError, nil])]);
                    
                    // Send an RAI response to move the lifecycle forward
                    [testManager.lifecycleStateMachine transitionToState:SDLLifecycleStateRegistered];
                    [NSThread sleepForTimeInterval:0.3];
                });
                
                it(@"should eventually reach the ready state", ^{
                    expect(testManager.lifecycleState).toEventually(match(SDLLifecycleStateReady));
                    OCMVerify([(SDLLockScreenManager *)lockScreenManagerMock start]);
                    OCMVerify([fileManagerMock startWithCompletionHandler:[OCMArg any]]);
                    OCMVerify([permissionManagerMock startWithCompletionHandler:[OCMArg any]]);
                });
                
                itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
            });
            
            describe(@"after receiving a disconnect notification", ^{
                beforeEach(^{
                    [testManager.notificationDispatcher postNotificationName:SDLTransportDidDisconnect infoObject:nil];
                });
                
                it(@"should enter the disconnect state", ^{
                    expect(testManager.lifecycleState).toEventually(match(SDLLifecycleStateDisconnected));
                });
            });
            
            describe(@"stopping the manager", ^{
                beforeEach(^{
                    [testManager stop];
                });
                
                it(@"should enter the disconnect state", ^{
                    expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
                });
            });
        });
        
        describe(@"in the ready state", ^{
            beforeEach(^{
                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateReady];
            });
            
            it(@"can send an RPC", ^{
                SDLShow *testShow = [SDLRPCRequestFactory buildShowWithMainField1:@"test" mainField2:nil alignment:nil correlationID:@1];
                [testManager sendRequest:testShow];
                
                OCMVerify([proxyMock sendRPC:[OCMArg isKindOfClass:[SDLShow class]]]);
            });
            
            describe(@"stopping the manager", ^{
                beforeEach(^{
                    [testManager stop];
                });
                
                it(@"should attempt to unregister", ^{
                    OCMVerify([proxyMock sendRPC:[OCMArg isKindOfClass:[SDLUnregisterAppInterface class]]]);
                    expect(testManager.lifecycleState).toEventually(match(SDLLifecycleStateUnregistering));
                });
                
                describe(@"when receiving an unregister response", ^{
                    __block SDLUnregisterAppInterfaceResponse *testUnregisterResponse = nil;
                    
                    beforeEach(^{
                        testUnregisterResponse = [[SDLUnregisterAppInterfaceResponse alloc] init];
                        testUnregisterResponse.success = @YES;
                        testUnregisterResponse.correlationID = @(testManager.lastCorrelationId);
                        
                        [testManager.notificationDispatcher postNotificationName:SDLDidReceiveUnregisterAppInterfaceResponse infoObject:testUnregisterResponse];
                    });
                    
                    it(@"should disconnect", ^{
                        expect(testManager.lifecycleState).toEventually(match(SDLLifecycleStateDisconnected));
                    });
                });
            });
            
            describe(@"receiving an HMI level change", ^{
                __block SDLOnHMIStatus *testHMIStatus = nil;
                __block SDLHMILevel *testHMILevel = nil;
                __block SDLHMILevel *oldHMILevel = nil;
                
                beforeEach(^{
                    oldHMILevel = testManager.hmiLevel;
                    testHMIStatus = [[SDLOnHMIStatus alloc] init];
                });
                
                context(@"a full hmi level", ^{
                    beforeEach(^{
                        testHMILevel = [SDLHMILevel FULL];
                        testHMIStatus.hmiLevel = testHMILevel;
                        
                        [testManager.notificationDispatcher postNotificationName:SDLDidChangeHMIStatusNotification infoObject:testHMIStatus];
                    });
                    
                    it(@"should set the hmi level", ^{
                        expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
                    });
                    
                    it(@"should call the delegate", ^{
                        OCMVerify([managerDelegateMock hmiLevel:oldHMILevel didChangeToLevel:testHMILevel]);
                    });
                });
            });
        });
    });
});

QuickSpecEnd

#pragma clang diagnostic pop
