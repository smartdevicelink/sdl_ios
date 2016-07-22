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
        expect(@(testManager.firstHMIFullOccurred)).to(beFalsy());
        expect(@(testManager.firstHMINotNoneOccurred)).to(beFalsy());
        expect(testManager.fileManager).toNot(beNil());
        expect(testManager.permissionManager).toNot(beNil());
        expect(testManager.streamManager).to(beNil());
        expect(testManager.proxy).to(beNil());
        expect(testManager.resumeHash).to(beNil());
        expect(testManager.registerAppInterfaceResponse).to(beNil());
        expect(testManager.lockScreenManager).toNot(beNil());
        expect(testManager.notificationDispatcher).toNot(beNil());
        expect(testManager.responseDispatcher).toNot(beNil());
        expect(@([testManager conformsToProtocol:@protocol(SDLConnectionManagerType)])).to(equal(@YES));
    });
    
    itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
    
    describe(@"after receiving a resume hash", ^{
        __block SDLOnHashChange *testHashChange = nil;
        
        beforeEach(^{
            testHashChange = [[SDLOnHashChange alloc] init];
            testHashChange.hashID = @"someHashId";
            
            [testManager.notificationDispatcher postNotificationName:SDLDidReceiveNewHashNotification infoObject:testHashChange];
        });
        
        it(@"should have stored the new hash", ^{
            expect(testManager.resumeHash).toEventually(equal(testHashChange));
        });
    });
    
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
                expect(testManager.currentHMILevel).toEventually(equal(testHMILevel));
                expect(@(testManager.firstHMIFullOccurred)).toEventually(beFalsy());
                expect(@(testManager.firstHMINotNoneOccurred)).toEventually(beFalsy());
            });
        });
        
        context(@"a non-full, non-none hmi level", ^{
            beforeEach(^{
                testHMILevel = [SDLHMILevel BACKGROUND];
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postNotificationName:SDLDidChangeHMIStatusNotification infoObject:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.currentHMILevel).toEventually(equal(testHMILevel));
                expect(@(testManager.firstHMIFullOccurred)).toEventually(beFalsy());
                expect(@(testManager.firstHMINotNoneOccurred)).toEventually(beTruthy());
            });
        });
        
        context(@"a full hmi level", ^{
            beforeEach(^{
                testHMILevel = [SDLHMILevel FULL];
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postNotificationName:SDLDidChangeHMIStatusNotification infoObject:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.currentHMILevel).toEventually(equal(testHMILevel));
                expect(@(testManager.firstHMIFullOccurred)).toEventually(beTruthy());
                expect(@(testManager.firstHMINotNoneOccurred)).toEventually(beTruthy());
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
            [testManager start];
        });
        
        it(@"should initialize the proxy property", ^{
            expect(testManager.proxy).toNot(beNil());
            expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
        });
        
        describe(@"after receiving a connect notification", ^{
            beforeEach(^{
                // When we connect, we should be creating an sending an RAI
                OCMExpect([proxyMock sendRPC:[OCMArg checkWithBlock:^BOOL(id obj) {
                    if (![obj isMemberOfClass:[SDLRegisterAppInterface class]]) {
                        return NO;
                    }
                    
                    SDLRegisterAppInterface *testRAObj = (SDLRegisterAppInterface *)obj;
                    return ([testRAObj.appName isEqualToString:testConfig.lifecycleConfig.appName]
                            && [testRAObj.appID isEqualToString:testConfig.lifecycleConfig.appId]
                            && [testRAObj.isMediaApplication isEqual:@(testConfig.lifecycleConfig.isMedia)]
                            && [testRAObj.ngnMediaScreenAppName isEqualToString:testConfig.lifecycleConfig.shortAppName]
                            && (testRAObj.vrSynonyms.count == testConfig.lifecycleConfig.voiceRecognitionSynonyms.count));
                }]]);
                
                [testManager.notificationDispatcher postNotificationName:SDLTransportDidConnect infoObject:nil];
                [NSThread sleepForTimeInterval:0.5];
            });
            
            it(@"should send a register app interface request and be in the connected state", ^{
                OCMVerifyAllWithDelay(proxyMock, 0.5);
                expect(testManager.lifecycleState).to(match(SDLLifecycleStateTransportConnected));
            });
            
            itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
            
            describe(@"after receiving a disconnect notification", ^{
                beforeEach(^{
                    [testManager.notificationDispatcher postNotificationName:SDLTransportDidDisconnect infoObject:nil];
                    [NSThread sleepForTimeInterval:0.5];
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
                __block SDLRegisterAppInterfaceResponse *testRAIResponse = nil;
                __block NSError *fileManagerStartError = [[NSError alloc] init];
                __block NSError *permissionManagerStartError = [[NSError alloc] init];
                
                beforeEach(^{
                    OCMStub([(SDLLockScreenManager *)lockScreenManagerMock start]);
                    OCMStub([fileManagerMock startWithCompletionHandler:([OCMArg invokeBlockWithArgs:@(YES), fileManagerStartError, nil])]);
                    OCMStub([permissionManagerMock startWithCompletionHandler:([OCMArg invokeBlockWithArgs:@(YES), permissionManagerStartError, nil])]);
                    
                    // Send an RAI response to move the lifecycle forward
                    testRAIResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    testRAIResponse.success = @YES;
                    [testManager.notificationDispatcher postNotificationName:SDLDidReceiveRegisterAppInterfaceResponse infoObject:testRAIResponse];
                    [NSThread sleepForTimeInterval:0.5];
                });
                
                it(@"should eventually reach the ready state", ^{
                    expect(testManager.lifecycleState).toEventually(match(SDLLifecycleStateReady));
                    OCMVerify([(SDLLockScreenManager *)lockScreenManagerMock start]);
                    OCMVerify([fileManagerMock startWithCompletionHandler:[OCMArg any]]);
                    OCMVerify([fileManagerMock startWithCompletionHandler:[OCMArg any]]);
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
        });
    });
});

QuickSpecEnd

#pragma clang diagnostic pop
