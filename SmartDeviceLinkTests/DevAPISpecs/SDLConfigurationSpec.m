#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLConfiguration.h"
#import "SDLFileManagerConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLogConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLEncryptionConfiguration.h"

QuickSpecBegin(SDLConfigurationSpec)

describe(@"a configuration", ^{
    __block SDLConfiguration *testConfig = nil;

    context(@"created with custom configs", ^{
        __block SDLLifecycleConfiguration *someLifecycleConfig = nil;
        __block SDLLockScreenConfiguration *someLockscreenConfig = nil;
        __block SDLLogConfiguration *someLogConfig = nil;
        __block SDLStreamingMediaConfiguration *someStreamingConfig = nil;
        __block SDLFileManagerConfiguration *someFileManagerConfig = nil;
        __block SDLEncryptionConfiguration *someEncryptionConfig = nil;

        __block NSString *someAppName = nil;
        __block NSString *someAppId = nil;
        __block UIColor *someBackgroundColor = nil;
        __block UIImage *someImage = nil;
        
        beforeEach(^{
            someAppName = @"some name";
            someAppId = @"some id";
            someBackgroundColor = [UIColor blueColor];
            someImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            
            someLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:someAppName fullAppId:someAppId];
            someLockscreenConfig = [SDLLockScreenConfiguration enabledConfigurationWithAppIcon:someImage backgroundColor:someBackgroundColor];
            someLogConfig = [SDLLogConfiguration defaultConfiguration];
            someStreamingConfig  = [SDLStreamingMediaConfiguration insecureConfiguration];
            someFileManagerConfig = [SDLFileManagerConfiguration defaultConfiguration];
            someEncryptionConfig = [SDLEncryptionConfiguration defaultConfiguration];
        });

        it(@"initWithLifecycle:lockScreen:logging:fileManager:", ^{
            testConfig = [[SDLConfiguration alloc] initWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig logging:someLogConfig fileManager:someFileManagerConfig encryption: someEncryptionConfig];

            expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
            expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
            expect(testConfig.loggingConfig).to(equal(someLogConfig));
            expect(testConfig.streamingMediaConfig).to(beNil());
            expect(testConfig.fileManagerConfig).to(equal(someFileManagerConfig));
            expect(testConfig.encryptionConfig).to(equal(someEncryptionConfig));
        });

        describe(@"streaming media config", ^{
            beforeEach(^{
                someLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:someAppName fullAppId:someAppId];
                someLifecycleConfig.appType = SDLAppHMITypeNavigation;
            });

            it(@"initWithLifecycle:lockScreen:logging:streamingMedia:fileManager:", ^{
                testConfig = [[SDLConfiguration alloc] initWithLifecycle:someLifecycleConfig lockScreen:someLockscreenConfig logging:someLogConfig streamingMedia:someStreamingConfig fileManager:someFileManagerConfig encryption:[SDLEncryptionConfiguration defaultConfiguration]];

                expect(testConfig.lifecycleConfig).to(equal(someLifecycleConfig));
                expect(testConfig.lockScreenConfig).to(equal(someLockscreenConfig));
                expect(testConfig.loggingConfig).to(equal(someLogConfig));
                expect(testConfig.streamingMediaConfig).to(equal(someStreamingConfig));
                expect(testConfig.fileManagerConfig).to(equal(someFileManagerConfig));
            });
        });
    });
});

QuickSpecEnd
