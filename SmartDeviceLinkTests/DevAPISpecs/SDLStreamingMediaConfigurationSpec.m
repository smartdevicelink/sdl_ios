#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>
#import <VideoToolbox/VideoToolbox.h>

#import "SDLStreamingMediaConfiguration.h"

#import "SDLFakeSecurityManager.h"
#import "SDLFakeStreamingManagerDataSource.h"
#import "SDLImageResolution.h"
#import "SDLVideoStreamingRange.h"

QuickSpecBegin(SDLStreamingMediaConfigurationSpec)

describe(@"a streaming media configuration", ^{
    __block SDLStreamingMediaConfiguration *testConfig = nil;
    __block SDLFakeSecurityManager *testFakeSecurityManager = nil;
    __block UIViewController *testViewController = nil;
    __block SDLStreamingEncryptionFlag testEncryptionFlag = SDLStreamingEncryptionFlagNone;
    __block SDLFakeStreamingManagerDataSource *testDataSource = nil;
    __block id<SDLStreamingVideoDelegate> testDelegate = nil;
    __block NSDictionary<NSString *, id> *testVideoEncoderSettings = nil;
    __block SDLVideoStreamingRange *testLandscapeRange = nil;
    __block SDLVideoStreamingRange *testPortraitRange = nil;

    beforeEach(^{
        testFakeSecurityManager = [[SDLFakeSecurityManager alloc] init];
        testDataSource = [[SDLFakeStreamingManagerDataSource alloc] init];
        testDelegate = OCMProtocolMock(@protocol(SDLStreamingVideoDelegate));
        testVideoEncoderSettings = @{
            (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate : @1
        };
        testViewController = [[UIViewController alloc] init];
        testEncryptionFlag = SDLStreamingEncryptionFlagAuthenticateAndEncrypt;
        testLandscapeRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:[[SDLImageResolution alloc] initWithWidth:100 height:100] maximumResolution:[[SDLImageResolution alloc] initWithWidth:200 height:200]];
        testPortraitRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:[[SDLImageResolution alloc] initWithWidth:50 height:50] maximumResolution:[[SDLImageResolution alloc] initWithWidth:150 height:150]];
    });

    context(@"That is created without the default secure/insecure settings", ^{
        it(@"should properly set all properties with initWithEncryptionFlag:videoSettings:supportedLandscapeRange:supportedPortraitRange:dataSource:delegate:rootViewController:", ^{
            testConfig = [[SDLStreamingMediaConfiguration alloc] initWithEncryptionFlag:testEncryptionFlag videoSettings:testVideoEncoderSettings supportedLandscapeRange:testLandscapeRange supportedPortraitRange:testPortraitRange dataSource:testDataSource delegate:testDelegate rootViewController:testViewController];

            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(testEncryptionFlag)));
            expect(testConfig.customVideoEncoderSettings).to(equal(testVideoEncoderSettings));
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(equal(testDataSource));
            expect(testConfig.rootViewController).to(equal(testViewController));
            expect(@(testConfig.carWindowRenderingType)).to(equal(@(SDLCarWindowRenderingTypeLayer)));
            expect(testConfig.enableForcedFramerateSync).to(beTrue());
            expect(testConfig.delegate).to(equal(testDelegate));
            expect(testConfig.supportedPortraitStreamingRange).to(equal(testPortraitRange));
            expect(testConfig.supportedLandscapeStreamingRange).to(equal(testLandscapeRange));
        });

        it(@"should have properly set all properties with initWithEncryptionFlag:videoSettings:dataSource:rootViewController:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            testConfig = [[SDLStreamingMediaConfiguration alloc] initWithEncryptionFlag:testEncryptionFlag videoSettings:testVideoEncoderSettings dataSource:testDataSource rootViewController:testViewController];
#pragma clang diagnostic pop

            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(testEncryptionFlag)));
            expect(testConfig.customVideoEncoderSettings).to(equal(testVideoEncoderSettings));
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(equal(testDataSource));
            expect(testConfig.rootViewController).to(equal(testViewController));
            expect(@(testConfig.carWindowRenderingType)).to(equal(@(SDLCarWindowRenderingTypeLayer)));
            expect(testConfig.enableForcedFramerateSync).to(beTrue());
            expect(testConfig.delegate).to(beNil());
            expect(testConfig.supportedPortraitStreamingRange).to(beNil());
            expect(testConfig.supportedLandscapeStreamingRange).to(beNil());
        });

        it(@"should have properly set and insecure configuration with init", ^{
            testConfig = [[SDLStreamingMediaConfiguration alloc] init];

            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagNone)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(beNil());
            expect(testConfig.rootViewController).to(beNil());
            expect(@(testConfig.carWindowRenderingType)).to(equal(@(SDLCarWindowRenderingTypeLayer)));
            expect(testConfig.enableForcedFramerateSync).to(beTrue());
            expect(testConfig.delegate).to(beNil());
            expect(testConfig.supportedPortraitStreamingRange).to(beNil());
            expect(testConfig.supportedLandscapeStreamingRange).to(beNil());
        });
    });

    context(@"that is created with insecure settings", ^{
        it(@"should have properly set properties with insecureConfiguration", ^{
            testConfig = [SDLStreamingMediaConfiguration insecureConfiguration];

            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagNone)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(beNil());
            expect(testConfig.rootViewController).to(beNil());
            expect(@(testConfig.carWindowRenderingType)).to(equal(@(SDLCarWindowRenderingTypeLayer)));
            expect(testConfig.enableForcedFramerateSync).to(beTrue());
            expect(testConfig.delegate).to(beNil());
            expect(testConfig.supportedPortraitStreamingRange).to(beNil());
            expect(testConfig.supportedLandscapeStreamingRange).to(beNil());
        });

        it(@"should have properly set properties with autostreamingInsecureConfigurationWithInitialViewController", ^{
            testConfig = [SDLStreamingMediaConfiguration autostreamingInsecureConfigurationWithInitialViewController:testViewController];

            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagNone)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(beNil());
            expect(testConfig.rootViewController).to(equal(testViewController));
            expect(@(testConfig.carWindowRenderingType)).to(equal(@(SDLCarWindowRenderingTypeLayer)));
            expect(testConfig.enableForcedFramerateSync).to(beTrue());
            expect(testConfig.delegate).to(beNil());
            expect(testConfig.supportedPortraitStreamingRange).to(beNil());
            expect(testConfig.supportedLandscapeStreamingRange).to(beNil());
        });
    });

    context(@"that is created with secure settings", ^{
        it(@"should have properly set properties with secureConfiguration", ^{
            testConfig = [SDLStreamingMediaConfiguration secureConfiguration];

            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagAuthenticateAndEncrypt)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(beNil());
            expect(testConfig.rootViewController).to(beNil());
            expect(@(testConfig.carWindowRenderingType)).to(equal(@(SDLCarWindowRenderingTypeLayer)));
            expect(testConfig.enableForcedFramerateSync).to(beTrue());
            expect(testConfig.delegate).to(beNil());
            expect(testConfig.supportedPortraitStreamingRange).to(beNil());
            expect(testConfig.supportedLandscapeStreamingRange).to(beNil());
        });

        it(@"should have properly set properties with autostreamingSecureConfigurationWithInitialViewController:", ^{
            testConfig = [SDLStreamingMediaConfiguration autostreamingSecureConfigurationWithInitialViewController:testViewController];

            expect(@(testConfig.maximumDesiredEncryption)).to(equal(@(SDLStreamingEncryptionFlagAuthenticateAndEncrypt)));
            expect(testConfig.customVideoEncoderSettings).to(beNil());
            expect(testConfig.allowMultipleViewControllerOrientations).to(equal(NO));
            expect(testConfig.dataSource).to(beNil());
            expect(testConfig.rootViewController).to(equal(testViewController));
            expect(@(testConfig.carWindowRenderingType)).to(equal(@(SDLCarWindowRenderingTypeLayer)));
            expect(testConfig.enableForcedFramerateSync).to(beTrue());
            expect(testConfig.delegate).to(beNil());
            expect(testConfig.supportedPortraitStreamingRange).to(beNil());
            expect(testConfig.supportedLandscapeStreamingRange).to(beNil());
        });
    });

    context(@"copying a configuration", ^{
        __block SDLStreamingMediaConfiguration *testStreamingMediaConfiguration = nil;
        __block SDLStreamingMediaConfiguration *testCopiedStreamingMediaConfiguration = nil;

        beforeEach(^{
            testStreamingMediaConfiguration = [[SDLStreamingMediaConfiguration alloc] initWithEncryptionFlag:testEncryptionFlag videoSettings:testVideoEncoderSettings supportedLandscapeRange:testLandscapeRange supportedPortraitRange:testPortraitRange dataSource:testDataSource delegate:testDelegate rootViewController:testViewController];
            testCopiedStreamingMediaConfiguration = [testStreamingMediaConfiguration copy];
        });

        it(@"should copy correctly", ^{
            expect(testCopiedStreamingMediaConfiguration).toNot(beIdenticalTo(testStreamingMediaConfiguration));
            expect(@(testCopiedStreamingMediaConfiguration.maximumDesiredEncryption)).to(equal(testStreamingMediaConfiguration.maximumDesiredEncryption));
            expect(testCopiedStreamingMediaConfiguration.customVideoEncoderSettings).to(equal(testStreamingMediaConfiguration.customVideoEncoderSettings));
            expect(testCopiedStreamingMediaConfiguration.dataSource).to(equal(testStreamingMediaConfiguration.dataSource));
            expect(testCopiedStreamingMediaConfiguration.rootViewController).to(equal(testStreamingMediaConfiguration.rootViewController));
            expect(@(testCopiedStreamingMediaConfiguration.carWindowRenderingType)).to(equal(testStreamingMediaConfiguration.carWindowRenderingType));
            expect(testCopiedStreamingMediaConfiguration.enableForcedFramerateSync).to(equal(testStreamingMediaConfiguration.enableForcedFramerateSync));
            expect(testCopiedStreamingMediaConfiguration.allowMultipleViewControllerOrientations).to(equal(testStreamingMediaConfiguration.allowMultipleViewControllerOrientations));
            expect(testCopiedStreamingMediaConfiguration.delegate).to(equal(testStreamingMediaConfiguration.delegate));
            expect(testCopiedStreamingMediaConfiguration.supportedPortraitStreamingRange).to(equal(testStreamingMediaConfiguration.supportedPortraitStreamingRange));
            expect(testCopiedStreamingMediaConfiguration.supportedLandscapeStreamingRange).to(equal(testStreamingMediaConfiguration.supportedLandscapeStreamingRange));
        });
    });
});

QuickSpecEnd
