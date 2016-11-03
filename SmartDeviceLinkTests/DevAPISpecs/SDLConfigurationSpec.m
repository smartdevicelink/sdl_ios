#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"

QuickSpecBegin(SDLConfigurationSpec)

describe(@"a configuration", ^{
    __block SDLConfiguration *testConfig = nil;
    
    context(@"created with a custom lifecycle and default lockscreen config", ^{
        __block SDLLifecycleConfiguration *someLifecycleConfig = nil;
        __block NSString *someAppName = nil;
        __block NSString *someAppId = nil;
        
        beforeEach(^{
            someAppName = @"some name";
            someAppId = @"some id";
            someLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:someAppName appId:someAppId];
            
            testConfig = [SDLConfiguration configurationWithLifecycle:someLifecycleConfig lockScreen:[SDLLockScreenConfiguration enabledConfiguration]];
        });
        
        it(@"should contain the correct configs", ^{
            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(@(testConfig.lockScreenConfig.enableAutomaticLockScreen)).to(equal(@YES));
        });
    });
    
    context(@"created with a custom lifecycle and lockscreen config", ^{
        __block SDLLifecycleConfiguration *someLifecycleConfig = nil;
        __block SDLLockScreenConfiguration *someLockscreenConfig = nil;
        
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
            
            testConfig = [SDLConfiguration configurationWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig];
        });
        
        it(@"should contain the correct configs", ^{
            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
        });
    });
});

QuickSpecEnd
