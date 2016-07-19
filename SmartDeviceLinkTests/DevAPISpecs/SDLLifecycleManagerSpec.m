#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLLifecycleManager.h"

#import "SDLConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLManagerDelegate.h"
#import "SDLProxy.h"
#import "SDLProxyFactory.h"


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
    });
    
    describe(@"when started", ^{
        
        beforeEach(^{
            OCMExpect([proxyBuilderClassMock buildSDLProxyWithListener:[OCMArg isEqual:testManager.notificationDispatcher]]);
            [testManager start];
        });
        
        it(@"should initialize the proxy property", ^{
            OCMVerifyAll(proxyBuilderClassMock);
            expect(testManager.proxy).toNot(beNil());
        });
    });
});

QuickSpecEnd

#pragma clang diagnostic pop
