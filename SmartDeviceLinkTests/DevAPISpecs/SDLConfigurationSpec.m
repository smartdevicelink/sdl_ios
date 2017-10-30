#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLogConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLStreamingMediaConfiguration.h"

QuickSpecBegin(SDLConfigurationSpec)

describe(@"a configuration", ^{
    __block SDLConfiguration *testConfig = nil;

    context(@"created with custom configs", ^{
        __block SDLLifecycleConfiguration *someLifecycleConfig = nil;
        __block SDLLockScreenConfiguration *someLockscreenConfig = nil;
        __block SDLLogConfiguration *someLogConfig = nil;
        __block SDLStreamingMediaConfiguration *someStreamingConfig = nil;
        
        __block NSString *someAppName = nil;
        __block NSString *someAppId = nil;
        __block UIColor *someBackgroundColor = nil;
        __block UIImage *someImage = nil;
        
        beforeEach(^{
            someAppName = @"some name";
            someAppId = @"some id";
            someBackgroundColor = [UIColor blueColor];
            someImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            
            someLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:someAppName appId:someAppId];
            someLockscreenConfig = [SDLLockScreenConfiguration enabledConfigurationWithAppIcon:someImage backgroundColor:someBackgroundColor];
            someLogConfig = [SDLLogConfiguration defaultConfiguration];
            someStreamingConfig  = [SDLStreamingMediaConfiguration insecureConfiguration];
        });
        
        it(@"should create correctly with initWithLifecycle:lockScreen:logging:", ^{
            testConfig = [[SDLConfiguration alloc] initWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig logging:someLogConfig];

            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
            expect(testConfig.loggingConfig).to(equal(someLogConfig));
            expect(testConfig.streamingMediaConfig).to(beNil());
        });

        it(@"should create correctly with configurationWithLifecycle:lockScreen:logging:", ^{
            testConfig = [SDLConfiguration configurationWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig logging:someLogConfig];

            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
            expect(testConfig.loggingConfig).to(equal(someLogConfig));
            expect(testConfig.streamingMediaConfig).to(beNil());
        });

        it(@"should create correctly with initWithLifecycle:lockScreen:logging:streamingMedia:", ^{
            testConfig = [[SDLConfiguration alloc] initWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig logging:someLogConfig streamingMedia:nil];

            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
            expect(testConfig.loggingConfig).to(equal(someLogConfig));
            expect(testConfig.streamingMediaConfig).to(beNil());
        });

        it(@"should create correctly with configurationWithLifecycle:lockScreen:logging:streamingMedia:", ^{
            testConfig = [SDLConfiguration configurationWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig logging:someLogConfig streamingMedia:nil];

            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
            expect(testConfig.loggingConfig).to(equal(someLogConfig));
            expect(testConfig.streamingMediaConfig).to(beNil());
        });
    });
});

QuickSpecEnd
