#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppHMIType.h"
#import "SDLLanguage.h"
#import "SDLLifecycleConfiguration.h"

QuickSpecBegin(SDLLifecycleConfigurationSpec)

describe(@"a lifecycle configuration", ^{
    __block SDLLifecycleConfiguration *testConfig = nil;
    
    context(@"that is created with default settings", ^{
        __block NSString *someAppName = nil;
        __block NSString *someAppId = nil;
        
        beforeEach(^{
            someAppName = @"An App Name";
            someAppId = @"00542596432764329684352896423679";
            
            testConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:someAppName appId:someAppId];
        });
        
        it(@"should have properly set properties", ^{
            expect(testConfig.appName).to(match(someAppName));
            expect(testConfig.appId).to(match(someAppId));
            expect(@(testConfig.tcpDebugMode)).to(beFalsy());
            expect(testConfig.tcpDebugIPAddress).to(match(@"192.168.0.1"));
            expect(testConfig.tcpDebugPort).to(match(@"12345"));
            expect(@([testConfig.appType isEqualToEnum:[SDLAppHMIType DEFAULT]])).to(equal(@YES));
            expect(@([testConfig.language isEqualToEnum:[SDLLanguage EN_US]])).to(equal(@YES));
            expect(@([[testConfig.languagesSupported firstObject] isEqualToEnum:[SDLLanguage EN_US]])).to(equal(@YES));
            expect(testConfig.shortAppName).to(beNil());
            expect(testConfig.ttsName).to(beNil());
            expect(testConfig.voiceRecognitionSynonyms).to(beEmpty());
        });
    });
});

QuickSpecEnd
