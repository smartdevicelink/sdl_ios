#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLLifecycleManager.h"

#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLError.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLManagerDelegate.h"
#import "SDLNotificationDispatcher.h"
#import "SDLProxy.h"
#import "SDLProxyFactory.h"
#import "SDLRegisterAppInterface.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCRequestFactory.h"
#import "SDLShow.h"
#import "SDLTextAlignment.h"


// Ignore the deprecated proxy methods
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

QuickSpecBegin(SDLLifecycleManagerSpec)

fdescribe(@"a lifecycle manager", ^{
    __block SDLLifecycleManager *testManager = nil;
    __block SDLConfiguration *testConfig = nil;
    
    __block id managerDelegateMock = OCMProtocolMock(@protocol(SDLManagerDelegate));
    __block id proxyBuilderClassMock = OCMStrictClassMock([SDLProxyFactory class]);
    __block id proxyMock = OCMStrictClassMock([SDLProxy class]);
    
    beforeEach(^{
        OCMStub([proxyBuilderClassMock buildSDLProxyWithListener:[OCMArg any]]).andReturn(proxyMock);
        
        SDLLifecycleConfiguration *testLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:@"Test App" appId:@"Test Id"];
        testLifecycleConfig.shortAppName = @"Short Name";
        
        testConfig = [SDLConfiguration configurationWithLifecycle:testLifecycleConfig lockScreen:[SDLLockScreenConfiguration disabledConfiguration]];
        testManager = [[SDLLifecycleManager alloc] initWithConfiguration:testConfig delegate:managerDelegateMock];
    });
    
    it(@"should initialize properties", ^{
        expect(testManager.configuration).to(equal(testConfig));
        expect(testManager.delegate).to(equal(managerDelegateMock));
        expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
        expect(@(testManager.lastCorrelationId)).to(equal(@1));
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
    
    describe(@"calling stop", ^{
        beforeEach(^{
            [testManager stop];
        });
        
        it(@"should do nothing", ^{
            expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
        });
    });
    
    describe(@"attempting to send a request", ^{
        __block SDLShow *testShow = nil;
        __block NSError *returnError = nil;
        
        beforeEach(^{
            testShow = [SDLRPCRequestFactory buildShowWithMainField1:@"Test" mainField2:@"Test2" alignment:[SDLTextAlignment CENTERED] correlationID:@1];
            [testManager sendRequest:testShow withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                returnError = error;
            }];
        });
        
        it(@"should throw an error when sending a request", ^{
            expect(returnError).to(equal([NSError sdl_lifecycle_notReadyError]));
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
            });
            
            it(@"should send a register app interface request and be in the connected state", ^{
                OCMVerifyAllWithDelay(proxyMock, 0.5);
                expect(testManager.lifecycleState).to(match(SDLLifecycleStateTransportConnected));
            });
            
            it(@"cannot publicly send RPCs", ^{
                __block NSError *testError = nil;
                SDLShow *testShow = [SDLRPCRequestFactory buildShowWithMainField1:@"test" mainField2:nil alignment:nil correlationID:@1];
                [testManager sendRequest:testShow withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                    testError = error;
                }];
                
                expect(testError).to(equal([NSError sdl_lifecycle_notReadyError]));
            });
            
            describe(@"after receiving a register app interface response", ^{
                __block SDLRegisterAppInterfaceResponse *testRAIResponse = nil;
                
                beforeEach(^{
                    testRAIResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    
                    [testManager.notificationDispatcher postNotificationName:SDLDidReceiveRegisterAppInterfaceResponse infoObject:testRAIResponse];
                });
            });
        });
    });
});

QuickSpecEnd

#pragma clang diagnostic pop
