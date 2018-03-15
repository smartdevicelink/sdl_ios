#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <VideoToolbox/VideoToolbox.h>

#import "SDLStreamingMediaConfiguration.h"

#import "SDLFakeSecurityManager.h"
#import "SDLFakeStreamingManagerDataSource.h"

QuickSpecBegin(SDLStreamingMediaConfigurationSpec)

describe(@"a streaming media configuration", ^{
    __block SDLStreamingMediaConfiguration *testConfig = nil;

    context(@"That is created with a full initializer", ^{
        __block SDLFakeSecurityManager *testFakeSecurityManager = nil;
        __block SDLStreamingEncryptionFlag testEncryptionFlag = SDLStreamingEncryptionFlagNone;
        __block SDLFakeStreamingManagerDataSource *testDataSource = nil;
        __block NSDictionary<NSString *, id> *testVideoEncoderSettings = nil;
        __block UIViewController *testViewController = nil;

        beforeEach(^{
            testFakeSecurityManager = [[SDLFakeSecurityManager alloc] init];
            testDataSource = [[SDLFakeStreamingManagerDataSource alloc] init];
            testVideoEncoderSettings = @{
                                         (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate : @1
                                         };
            testViewController = [[UIViewController alloc] init];
            testEncryptionFlag = SDLStreamingEncryptionFlagAuthenticateAndEncrypt;

            testConfig = [[SDLStreamingMediaConfiguration alloc] initWithSecurityManagers:@[testFakeSecurityManager.class] encryptionFlag:testEncryptionFlag videoSettings:testVideoEncoderSettings dataSource:testDataSource rootViewController:testViewController];
        });

        it(@"should have properly set properties", ^{
            expect(testConfig.securityManagers).to(contain(testFakeSecurityManager.class));
            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagAuthenticateAndEncrypt)));
            expect(testConfig.customVideoEncoderSettings).to(equal(testVideoEncoderSettings));
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(equal(testDataSource));
            expect(testConfig.rootViewController).to(equal(testViewController));
        });
    });

    context(@"that is created with insecure settings", ^{
        beforeEach(^{
            testConfig = [SDLStreamingMediaConfiguration insecureConfiguration];
        });

        it(@"should have properly set properties", ^{
            expect(testConfig.securityManagers).to(beNil());
            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagNone)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(beNil());
            expect(testConfig.rootViewController).to(beNil());
        });
    });

    context(@"that is created with secure settings", ^{
        __block SDLFakeSecurityManager *testFakeSecurityManager = nil;

        beforeEach(^{
            testFakeSecurityManager = [[SDLFakeSecurityManager alloc] init];

            testConfig = [SDLStreamingMediaConfiguration secureConfigurationWithSecurityManagers:@[testFakeSecurityManager.class]];
        });

        it(@"should have properly set properties", ^{
            expect(testConfig.securityManagers).to(contain(testFakeSecurityManager.class));
            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagAuthenticateAndEncrypt)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(beNil());
            expect(testConfig.rootViewController).to(beNil());
        });
    });
});

QuickSpecEnd
