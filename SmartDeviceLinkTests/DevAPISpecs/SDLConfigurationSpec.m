#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLogConfiguration.h"
#import "SDLLockScreenConfiguration.h"

QuickSpecBegin(SDLConfigurationSpec)

describe(@"a configuration", ^{
    __block SDLConfiguration *testConfig = nil;

    context(@"created with custom configs", ^{
        __block SDLLifecycleConfiguration *someLifecycleConfig = nil;
        __block SDLLockScreenConfiguration *someLockscreenConfig = nil;
        __block SDLLogConfiguration *someLogConfig = nil;
        
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
            
            testConfig = [SDLConfiguration configurationWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig logging:someLogConfig];
        });
        
        it(@"should contain the correct configs", ^{
            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
            expect(testConfig.loggingConfig).to(equal(someLogConfig));
        });
    });
});

QuickSpecEnd
