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
#import "SDLProxy.h"
#import "SDLProxyFactory.h"
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
        
        testConfig = [SDLConfiguration configurationWithLifecycle:[SDLLifecycleConfiguration defaultConfigurationWithAppName:@"Test App" appId:@"Test Id"] lockScreen:[SDLLockScreenConfiguration disabledConfiguration]];
        testManager = [[SDLLifecycleManager alloc] initWithConfiguration:testConfig delegate:managerDelegateMock];
    });
    
    afterEach(^{
        proxyBuilderClassMock = nil;
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
            OCMExpect([proxyBuilderClassMock buildSDLProxyWithListener:[OCMArg isEqual:testManager.notificationDispatcher]]);
            [testManager start];
        });
        
        it(@"should initialize the proxy property", ^{
            OCMVerifyAll(proxyBuilderClassMock);
            expect(testManager.proxy).toNot(beNil());
            expect(testManager.lifecycleState).to(match(SDLLifecycleStateDisconnected));
        });
    });
});

QuickSpecEnd

#pragma clang diagnostic pop
