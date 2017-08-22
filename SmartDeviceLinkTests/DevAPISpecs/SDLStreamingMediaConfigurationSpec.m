#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <VideoToolbox/VideoToolbox.h>

#import "SDLStreamingMediaConfiguration.h"

#import "SDLFakeSecurityManager.h"

QuickSpecBegin(SDLStreamingMediaConfigurationSpec)

describe(@"a streaming media configuration", ^{
    __block SDLStreamingMediaConfiguration *testConfig = nil;

    context(@"that is created with insecure settings", ^{
        beforeEach(^{
            testConfig = [SDLStreamingMediaConfiguration insecureConfiguration];
        });

        it(@"should have properly set properties", ^{
            expect(testConfig.securityManagers).to(beNil());
            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagNone)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
        });

        describe(@"after setting properties manually", ^{
            __block SDLStreamingEncryptionFlag someEncryptionFlag = SDLStreamingEncryptionFlagNone;
            __block NSDictionary<NSString *, id> *someVideoEncoderSettings = nil;

            beforeEach(^{
                someVideoEncoderSettings = @{
                                             (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate : @1
                                             };

                testConfig.maximumDesiredEncryption = someEncryptionFlag;
                testConfig.customVideoEncoderSettings = someVideoEncoderSettings;
            });

            it(@"should have properly set properties", ^{
                expect(testConfig.securityManagers).to(beNil());
                expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(someEncryptionFlag)));
                expect(testConfig.customVideoEncoderSettings).to(equal(someVideoEncoderSettings));
            });
        });
    });

    context(@"that is created with secure settings", ^{
        __block SDLFakeSecurityManager *testFakeSecurityManager = nil;

        beforeEach(^{
            testFakeSecurityManager = [[SDLFakeSecurityManager alloc] init];

            testConfig = [SDLStreamingMediaConfiguration secureConfigurationWithSecurityManagers:@[testFakeSecurityManager]];
        });

        it(@"should have properly set properties", ^{
            expect(testConfig.securityManagers).to(contain(testFakeSecurityManager));
            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagAuthenticateAndEncrypt)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
        });

        describe(@"after setting properties manually", ^{
            __block SDLStreamingEncryptionFlag someEncryptionFlag = SDLStreamingEncryptionFlagNone;
            __block NSDictionary<NSString *, id> *someVideoEncoderSettings = nil;

            beforeEach(^{
                someVideoEncoderSettings = @{
                                             (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate : @1
                                             };

                testConfig.maximumDesiredEncryption = someEncryptionFlag;
                testConfig.customVideoEncoderSettings = someVideoEncoderSettings;
            });

            it(@"should have properly set properties", ^{
                expect(testConfig.securityManagers).to(contain(testFakeSecurityManager));
                expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(someEncryptionFlag)));
                expect(testConfig.customVideoEncoderSettings).to(equal(someVideoEncoderSettings));
            });
        });
    });
});

QuickSpecEnd
