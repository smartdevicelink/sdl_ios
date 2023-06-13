#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLCarWindow.h"
#import "SDLCarWindowViewController.h"
#import "SDLConfiguration.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadNak.h"
#import "SDLControlFramePayloadVideoStartService.h"
#import "SDLControlFramePayloadVideoStartServiceAck.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFakeStreamingManagerDataSource.h"
#import "SDLFileManagerConfiguration.h"
#import "SDLFocusableItemLocator.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGenericResponse.h"
#import "SDLGlobals.h"
#import "SDLH264VideoEncoder.h"
#import "SDLHMICapabilities.h"
#import "SDLHMILevel.h"
#import "SDLImageResolution.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLogMacros.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLogConfiguration.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLVideoStreamingRange.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLVehicleType.h"
#import "SDLVersion.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingState.h"
#import "SDLVehicleType.h"
#import "TestConnectionManager.h"
#import "TestSmartConnectionManager.h"
#import "TestStreamingMediaDelegate.h"

// expose private methods to the test suite
@interface SDLStreamingVideoLifecycleManager (test)

@property (weak, nonatomic) SDLProtocol *protocol;
@property (copy, nonatomic, readonly) NSString *appName;
@property (copy, nonatomic, readonly) NSString *videoStreamBackgroundString;
@property (strong, nonatomic, nullable) SDLVideoStreamingRange *supportedLandscapeStreamingRange;
@property (strong, nonatomic, nullable) SDLVideoStreamingRange *supportedPortraitStreamingRange;
@property (weak, nonatomic, nullable) id<SDLStreamingVideoDelegate> delegate;
@property (assign, nonatomic) BOOL shouldAutoResume;
@property (strong, nonatomic, nullable) SDLVideoStreamingCapability *videoStreamingCapability;
@property (strong, nonatomic, nullable) SDLVideoStreamingCapability *videoStreamingCapabilityUpdated;
@property (strong, nonatomic, nullable) CADisplayLink *displayLink;
@property (strong, nonatomic) NSMutableDictionary *videoEncoderSettings;
@property (copy, nonatomic) NSDictionary<NSString *, id> *customEncoderSettings;

- (void)sdl_shutDown;
- (NSArray<SDLVideoStreamingCapability *>* __nullable)matchVideoCapability:(SDLVideoStreamingCapability *)videoStreamingCapability;
- (void)sdl_suspendVideo;
- (void)didEnterStateVideoStreamStopped;
- (void)didEnterStateVideoStreamStarting;
- (void)didEnterStateVideoStreamReady;
- (void)didEnterStateVideoStreamSuspended;
- (void)sdl_videoStreamingCapabilityDidUpdate:(SDLSystemCapability *)systemCapability;
- (void)sdl_applyVideoCapability:(SDLVideoStreamingCapability *)capability;

@end

@interface SDLStreamingVideoLifecycleTestManager : SDLStreamingVideoLifecycleManager
@property (assign) BOOL didStopVideoSession;
@property (strong, nullable) id testVideoCapabilityUpdatedWhileStarting;
@property (strong, nullable) id testVideoCapabilityUpdatedWhenStreaming;
@end

@implementation SDLStreamingVideoLifecycleTestManager

- (BOOL)isVideoConnected {
    return NO;
}

- (void)sdl_stopVideoSession {
    self.didStopVideoSession = YES;
}

- (void)sdl_applyVideoCapabilityWhileStarting:(SDLVideoStreamingCapability *)videoCapabilityUpdated {
    self.testVideoCapabilityUpdatedWhileStarting = videoCapabilityUpdated;
}

- (void)sdl_applyVideoCapabilityWhenStreaming:(nullable SDLVideoStreamingCapability *)videoCapability {
    self.testVideoCapabilityUpdatedWhenStreaming = videoCapability;
}

- (BOOL)isAppStateVideoStreamCapable {
    return YES;
}

- (SDLVideoStreamingFormat *)videoFormat {
    return [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
}

- (SDLH264VideoEncoder *)videoEncoder {
    return OCMClassMock([SDLH264VideoEncoder class]);
}

- (BOOL)useDisplayLink {
    return YES;
}

@end


// expose private methods to the test suite
@interface SDLVideoStreamingCapability (test)
- (NSArray <SDLVideoStreamingCapability *> *)allVideoStreamingCapabilities;
- (instancetype)shortCopy;
@end

// video streaming capabilities values for testing, used in SDLGetSystemCapabilityResponse
static const float testVSCScale = 1.25;
static const int32_t testVSCMaxBitrate = 12345;
static const uint16_t testVSCResolutionWidth = 42;
static const uint16_t testVSCResolutionHeight = 69;
NSString *const testAppName = @"Test App";

static void postRAINotification(void);
static void sendNotificationForHMILevel(SDLHMILevel hmiLevel, SDLVideoStreamingState streamState);
static SDLGetSystemCapabilityResponse *createSystemCapabilityResponse(void);

#pragma mark - test Init

QuickSpecBegin(SDLStreamingVideoLifecycleManagerSpec_Init)

describe(@"init tests", ^{
    __block SDLStreamingVideoLifecycleManager *streamingLifecycleManager = nil;
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;
    SDLStreamingMediaConfiguration *testConfiguration = [SDLStreamingMediaConfiguration insecureConfiguration];
    SDLCarWindowViewController *testViewController = [[SDLCarWindowViewController alloc] init];
    SDLFakeStreamingManagerDataSource *testDataSource = [[SDLFakeStreamingManagerDataSource alloc] init];
    SDLLifecycleConfiguration *testLifecycleConfiguration = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:@""];
    __block SDLConfiguration *testConfig = nil;
    SDLSystemInfo *testSystemInfo = [[SDLSystemInfo alloc] initWithMake:@"Livio" model:@"Model" trim:@"Trim" modelYear:@"2021" softwareVersion:@"1.1.1.1" hardwareVersion:@"2.2.2.2"];
    __block TestSmartConnectionManager *testConnectionManager = nil;
    SDLVersion *version600 = [SDLVersion versionWithMajor:6 minor:0 patch:0];

    beforeEach(^{
        // set up proper version
        [SDLGlobals sharedGlobals].rpcVersion = version600;
        [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = version600;

        testConfiguration.customVideoEncoderSettings = @{(id)kVTCompressionPropertyKey_ExpectedFrameRate : @1};
        testConfiguration.dataSource = testDataSource;
        testConfiguration.rootViewController = testViewController;
        testConnectionManager = [[TestSmartConnectionManager alloc] init];
        testConnectionManager.systemInfo = testSystemInfo;

        // load connection manager with fake data
        TestSmartConnection *connectionModel = [[TestSmartConnection alloc] init];
        SDLGetSystemCapability *getRequest = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypeVideoStreaming];
        connectionModel.request = getRequest;
        connectionModel.response = createSystemCapabilityResponse();
        [testConnectionManager addConnectionModel:connectionModel];

        testLifecycleConfiguration.appType = SDLAppHMITypeNavigation;

        testConfig = [[SDLConfiguration alloc] initWithLifecycle:testLifecycleConfiguration lockScreen:[SDLLockScreenConfiguration enabledConfiguration] logging:[SDLLogConfiguration debugConfiguration] streamingMedia:testConfiguration fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:nil];
    });

     it(@"should return true by default if the system capability manager is nil", ^{
         SDLStreamingVideoLifecycleManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfig systemCapabilityManager:nil];
         expect(streamingLifecycleManager.isStreamingSupported).to(beTrue());
     });

    context(@"having inited", ^{
        beforeEach(^{
            testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:testConnectionManager];
            streamingLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfig systemCapabilityManager:testSystemCapabilityManager];
            testConnectionManager.lastRequestBlock = ^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                SDLLogD(@"testConnectionManager.lastRequestBlock:\n\trequest:{%@};\n\tresponse:{%@}\n\terror:{%@};", request, response, error);
            };
        });

        afterEach(^{
            if (streamingLifecycleManager) {
                // sdl_shutDown: unsubscribe from notifications, otherwise the zombie managers will still receive all notifications
                [streamingLifecycleManager sdl_shutDown];
                streamingLifecycleManager = nil;
            }
        });

        it(@"expect post RAI change streaming inner state", ^{
            expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
            postRAINotification();
            expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@YES));
        });

        it(@"should get the value from the system capability manager", ^{
            expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(equal(NO));
            postRAINotification();
            expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(equal(YES));
        });

        it(@"expect all properties to be inited properly", ^{
            postRAINotification();
            expect(streamingLifecycleManager.videoScaleManager.scale).to(equal([[SDLStreamingVideoScaleManager alloc] init].scale));
            expect(streamingLifecycleManager.touchManager).toNot(beNil());
            expect(streamingLifecycleManager.focusableItemManager).toNot(beNil());
            expect(streamingLifecycleManager.isStreamingSupported).to(equal(YES));
            expect(@(streamingLifecycleManager.isVideoConnected)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoEncrypted)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoStreamingPaused)).to(equal(@YES));
            expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeZero))).to(equal(@YES));
            expect(@(streamingLifecycleManager.pixelBufferPool == NULL)).to(equal(@YES));
            expect(@(streamingLifecycleManager.requestedEncryptionType)).to(equal(@(SDLStreamingEncryptionFlagNone)));
            expect(@(streamingLifecycleManager.showVideoBackgroundDisplay)).to(equal(@YES));
            expect(streamingLifecycleManager.currentAppState).to(equal(SDLAppStateActive));
            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
            expect(streamingLifecycleManager.videoFormat).to(beNil());
            expect(streamingLifecycleManager.dataSource).to(equal(testDataSource));
            expect(streamingLifecycleManager.supportedFormats).to(haveCount(2));
            expect(streamingLifecycleManager.preferredFormats).to(beNil());
            expect(streamingLifecycleManager.preferredResolutions).to(beNil());
            expect(streamingLifecycleManager.preferredFormatIndex).to(equal(0));
            expect(streamingLifecycleManager.preferredResolutionIndex).to(equal(0));
        });
    });
});

QuickSpecEnd

#pragma mark - test Runtime

QuickSpecBegin(SDLStreamingVideoLifecycleManagerSpec_Runtime)

describe(@"test internals", ^{
    context(@"init extended manager", ^{
        id<SDLConnectionManagerType> mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        SDLConfiguration *configuration = [[SDLConfiguration alloc] init];
        SDLStreamingVideoLifecycleTestManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleTestManager alloc] initWithConnectionManager:mockConnectionManager configuration:configuration systemCapabilityManager:nil];
        SDLProtocol *protocolMock = OCMClassMock([SDLProtocol class]);
        it(@"suspendVideo with and without a protocol", ^{
            expect(streamingLifecycleManager.didStopVideoSession).to(equal(NO));
            [streamingLifecycleManager sdl_suspendVideo];
            expect(streamingLifecycleManager.didStopVideoSession).to(equal(NO));
            streamingLifecycleManager.protocol = protocolMock;
            [streamingLifecycleManager sdl_suspendVideo];
            expect(streamingLifecycleManager.didStopVideoSession).to(equal(YES));
        });
    });

    context(@"init extended manager", ^{
        id<SDLConnectionManagerType> mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        SDLConfiguration *configuration = [[SDLConfiguration alloc] init];
        SDLStreamingVideoLifecycleTestManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleTestManager alloc] initWithConnectionManager:mockConnectionManager configuration:configuration systemCapabilityManager:nil];

        context(@"test didEnterStateVideoStreamStopped", ^{
            it(@"state before and after", ^{
                streamingLifecycleManager.shouldAutoResume = YES;
                SDLState *stateBefore = streamingLifecycleManager.videoStreamStateMachine.currentState;
                expect([stateBefore isEqualToString:SDLVideoStreamManagerStateStopped]).to(equal(YES));

                [streamingLifecycleManager didEnterStateVideoStreamStopped];

                SDLState *stateAfter = streamingLifecycleManager.videoStreamStateMachine.currentState;
                expect([stateAfter isEqualToString:SDLVideoStreamManagerStateStarting]).to(equal(YES));
            });
        });
    });

    context(@"init extended manager", ^{
        id<SDLConnectionManagerType> mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        SDLConfiguration *configuration = [[SDLConfiguration alloc] init];
        SDLStreamingVideoLifecycleTestManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleTestManager alloc] initWithConnectionManager:mockConnectionManager configuration:configuration systemCapabilityManager:nil];

        context(@"test videoStreamingCapabilityUpdated", ^{
            SDLVideoStreamingCapability *videoStreamingCapabilityUpdated = OCMClassMock([SDLVideoStreamingCapability class]);
            streamingLifecycleManager.videoStreamingCapabilityUpdated = videoStreamingCapabilityUpdated;
            it(@"expect correct state", ^{
                streamingLifecycleManager.shouldAutoResume = YES;
                expect(streamingLifecycleManager.videoStreamingCapabilityUpdated).notTo(beNil());
                expect(streamingLifecycleManager.videoStreamingCapabilityUpdated).to(equal(videoStreamingCapabilityUpdated));

                [streamingLifecycleManager didEnterStateVideoStreamStarting];

                expect(streamingLifecycleManager.videoStreamingCapabilityUpdated).to(beNil());
                expect(streamingLifecycleManager.testVideoCapabilityUpdatedWhileStarting).to(equal(videoStreamingCapabilityUpdated));
            });
        });
    });

    context(@"init extended manager", ^{
        id<SDLConnectionManagerType> mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        SDLConfiguration *configuration = [[SDLConfiguration alloc] init];
        SDLStreamingVideoLifecycleTestManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleTestManager alloc] initWithConnectionManager:mockConnectionManager configuration:configuration systemCapabilityManager:nil];

        context(@"test didEnterStateVideoStreamReady", ^{
            it(@"expect displayLink update properly", ^{
                expect(streamingLifecycleManager.displayLink).to(beNil());
                [streamingLifecycleManager didEnterStateVideoStreamReady];
                expect([streamingLifecycleManager.displayLink isKindOfClass:[CADisplayLink class]]).to(beTrue());
            });
        });

        context(@"test didEnterStateVideoStreamSuspended", ^{
            SDLVideoStreamingCapability *videoStreamingCapabilityUpdated = OCMClassMock([SDLVideoStreamingCapability class]);
            streamingLifecycleManager.videoStreamingCapabilityUpdated = videoStreamingCapabilityUpdated;
            it(@"expect properties to update properly", ^{
                streamingLifecycleManager.shouldAutoResume = YES;

                expect(streamingLifecycleManager.shouldAutoResume).to(equal(YES));
                expect(streamingLifecycleManager.videoStreamingCapabilityUpdated).notTo(beNil());
                expect(streamingLifecycleManager.videoStreamingCapabilityUpdated).to(equal(videoStreamingCapabilityUpdated));

                [streamingLifecycleManager didEnterStateVideoStreamSuspended];

                expect(streamingLifecycleManager.shouldAutoResume).to(equal(NO));
                expect(streamingLifecycleManager.videoStreamingCapability).to(equal(videoStreamingCapabilityUpdated));
                expect(streamingLifecycleManager.shouldAutoResume).toEventually(equal(NO));

                [streamingLifecycleManager.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStarting];
                SDLProtocol *protocolMock = OCMClassMock([SDLProtocol class]);
                SDLProtocolMessage *startServiceNAK = OCMClassMock([SDLProtocolMessage class]);
                SDLState *stateBefore = streamingLifecycleManager.videoStreamStateMachine.currentState;
                [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceNAK:startServiceNAK];
                SDLState *stateAfter = streamingLifecycleManager.videoStreamStateMachine.currentState;

                expect(stateBefore).to(equal(SDLVideoStreamManagerStateStarting));
                expect(stateAfter).to(equal(SDLVideoStreamManagerStateStarting));
            });
        });
    });

    context(@"init extended manager", ^{
        id<SDLConnectionManagerType> mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        SDLConfiguration *configuration = [[SDLConfiguration alloc] init];
        SDLStreamingVideoLifecycleTestManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleTestManager alloc] initWithConnectionManager:mockConnectionManager configuration:configuration systemCapabilityManager:nil];

        context(@"test sdl_videoStreamingCapabilityDidUpdate", ^{
            streamingLifecycleManager.shouldAutoResume = YES;
            SDLVideoStreamingCapability *videoStreamingCapabilityUpdated = OCMClassMock([SDLVideoStreamingCapability class]);
            streamingLifecycleManager.videoStreamingCapabilityUpdated = videoStreamingCapabilityUpdated;
            it(@"expect correct state", ^{
                SDLSystemCapability *systemCapability = nil;
                [streamingLifecycleManager.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStarting];
                SDLState *stateBefore = streamingLifecycleManager.videoStreamStateMachine.currentState;
                [streamingLifecycleManager sdl_videoStreamingCapabilityDidUpdate:systemCapability];
                expect(streamingLifecycleManager.testVideoCapabilityUpdatedWhileStarting).to(beNil());
                expect(streamingLifecycleManager.testVideoCapabilityUpdatedWhenStreaming).to(beNil());
                SDLState *stateAfter = streamingLifecycleManager.videoStreamStateMachine.currentState;

                expect(stateBefore).to(equal(SDLVideoStreamManagerStateStarting));
                expect(stateAfter).to(equal(SDLVideoStreamManagerStateStarting));

                systemCapability = [[SDLSystemCapability alloc] init];
                systemCapability.videoStreamingCapability = OCMClassMock([SDLVideoStreamingCapability class]);

                stateBefore = streamingLifecycleManager.videoStreamStateMachine.currentState;
                [streamingLifecycleManager sdl_videoStreamingCapabilityDidUpdate:systemCapability];
                expect(streamingLifecycleManager.testVideoCapabilityUpdatedWhileStarting).to(equal(systemCapability.videoStreamingCapability));
                expect(streamingLifecycleManager.testVideoCapabilityUpdatedWhenStreaming).to(beNil());
                stateAfter = streamingLifecycleManager.videoStreamStateMachine.currentState;

                expect(stateBefore).to(equal(SDLVideoStreamManagerStateStarting));
                expect(stateAfter).to(equal(SDLVideoStreamManagerStateStarting));

                // state ready
                streamingLifecycleManager.testVideoCapabilityUpdatedWhileStarting = nil;
                streamingLifecycleManager.testVideoCapabilityUpdatedWhenStreaming = nil;

                [streamingLifecycleManager.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateReady];
                stateBefore = streamingLifecycleManager.videoStreamStateMachine.currentState;
                [streamingLifecycleManager sdl_videoStreamingCapabilityDidUpdate:systemCapability];
                expect(streamingLifecycleManager.testVideoCapabilityUpdatedWhileStarting).to(beNil());
                expect(streamingLifecycleManager.testVideoCapabilityUpdatedWhenStreaming).to(equal(systemCapability.videoStreamingCapability));
                stateAfter = streamingLifecycleManager.videoStreamStateMachine.currentState;

                expect(stateBefore).to(equal(SDLVideoStreamManagerStateReady));
                expect(stateAfter).to(equal(SDLVideoStreamManagerStateReady));
            });
        });
    });

});

describe(@"runtime tests", ^{
    __block SDLStreamingVideoLifecycleManager *streamingLifecycleManager = nil;
    SDLStreamingMediaConfiguration *testConfiguration = [SDLStreamingMediaConfiguration insecureConfiguration];
    SDLCarWindowViewController *testViewController = [[SDLCarWindowViewController alloc] init];
    SDLFakeStreamingManagerDataSource *testDataSource = [[SDLFakeStreamingManagerDataSource alloc] init];
    NSString *testAppName = @"Test App";
    SDLLifecycleConfiguration *testLifecycleConfiguration = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:@""];
    SDLVersion *version600 = [SDLVersion versionWithMajor:6 minor:0 patch:0];

    // set proper version up
    [SDLGlobals sharedGlobals].rpcVersion = version600;
    [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = version600;

    testConfiguration.customVideoEncoderSettings = @{(id)kVTCompressionPropertyKey_ExpectedFrameRate : @1};
    testConfiguration.dataSource = testDataSource;
    testConfiguration.rootViewController = testViewController;

    // load connection manager with fake data
    TestSmartConnectionManager *testConnectionManager = [[TestSmartConnectionManager alloc] init];
    TestSmartConnection *connectionModel = [[TestSmartConnection alloc] init];
    SDLGetSystemCapability *getRequest = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypeVideoStreaming];
    connectionModel.request = getRequest;
    connectionModel.response = createSystemCapabilityResponse();
    [testConnectionManager addConnectionModel:connectionModel];

    testLifecycleConfiguration.appType = SDLAppHMITypeNavigation;

    SDLConfiguration *testConfig = [[SDLConfiguration alloc] initWithLifecycle:testLifecycleConfiguration lockScreen:[SDLLockScreenConfiguration enabledConfiguration] logging:[SDLLogConfiguration debugConfiguration] streamingMedia:testConfiguration fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:nil];

    SDLSystemCapabilityManager *testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:testConnectionManager];

    beforeEach(^{
        streamingLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfig systemCapabilityManager:testSystemCapabilityManager];
        testConnectionManager.lastRequestBlock = ^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            SDLLogD(@"testConnectionManager.lastRequestBlock:\n\trequest:{%@};\n\tresponse:{%@}\n\terror:{%@};", request, response, error);
        };
    });

    afterEach(^{
        if (streamingLifecycleManager) {
            // sdl_shutDown: unsubscribe from notifications, otherwise the zombie managers will still receive all notifications
            [streamingLifecycleManager sdl_shutDown];
            streamingLifecycleManager = nil;
        }
    });

    describe(@"when started", ^{
        __block BOOL readyHandlerSuccess = NO;
        __block NSError *readyHandlerError = nil;
        SDLProtocol *protocolMock = OCMClassMock([SDLProtocol class]);

        beforeEach(^{
            readyHandlerSuccess = NO;
            readyHandlerError = nil;

            [streamingLifecycleManager startWithProtocol:protocolMock];
        });

        it(@"should be ready to stream", ^{
            expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@YES));
            expect(@(streamingLifecycleManager.isVideoConnected)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoEncrypted)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoStreamingPaused)).to(equal(@YES));
            expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeZero))).to(equal(@YES));
            expect(@(streamingLifecycleManager.pixelBufferPool == NULL)).to(equal(@YES));
            expect(streamingLifecycleManager.currentAppState).to(equal(SDLAppStateActive));
            expect(streamingLifecycleManager.currentVideoStreamState).to(match(SDLVideoStreamManagerStateStopped));
        });

        describe(@"after receiving a register app interface response", ^{
            __block SDLRegisterAppInterfaceResponse *someRegisterAppInterfaceResponse = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            __block SDLDisplayCapabilities *someDisplayCapabilities = nil;
#pragma clang diagnostic pop
            __block SDLScreenParams *someScreenParams = nil;
            __block SDLImageResolution *someImageResolution = nil;
            __block SDLHMICapabilities *someHMICapabilities = nil;
            __block SDLVehicleType *testVehicleType = nil;

            beforeEach(^{
                someImageResolution = [[SDLImageResolution alloc] init];
                someImageResolution.resolutionWidth = @(600);
                someImageResolution.resolutionHeight = @(100);

                someScreenParams = [[SDLScreenParams alloc] init];
                someScreenParams.resolution = someImageResolution;

                testVehicleType = [[SDLVehicleType alloc] init];
                testVehicleType.make = @"TestVehicleType";
            });

            describe(@"that does not support video streaming", ^{
                beforeEach(^{
                    someHMICapabilities = [[SDLHMICapabilities alloc] init];
                    someHMICapabilities.videoStreaming = @NO;

                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    someRegisterAppInterfaceResponse.hmiCapabilities = someHMICapabilities;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    someRegisterAppInterfaceResponse.vehicleType = testVehicleType;
#pragma clang diagnostic pop
                    someRegisterAppInterfaceResponse.success = @YES;

                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should save the connected vehicle make but not the screen size", ^{
                    expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeZero))).to(equal(@YES));
                });
            });

            describe(@"that supports video streaming", ^{
                beforeEach(^{
                    someHMICapabilities = [[SDLHMICapabilities alloc] init];
                    someHMICapabilities.videoStreaming = @YES;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    someDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
#pragma clang diagnostic pop
                    someDisplayCapabilities.screenParams = someScreenParams;

                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    someRegisterAppInterfaceResponse.hmiCapabilities = someHMICapabilities;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                    someRegisterAppInterfaceResponse.displayCapabilities = someDisplayCapabilities;
#pragma clang diagnostic pop

                    someRegisterAppInterfaceResponse.success = @YES;

                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should save the connected vehicle make and the screen size", ^{
                    expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeMake(600, 100)))).to(equal(@YES));
                });
            });
        });

        describe(@"if the app state is active", ^{
            __block SDLStreamingVideoLifecycleManager *streamStub = nil;

            beforeEach(^{
                streamStub = OCMPartialMock(streamingLifecycleManager);
                OCMStub([streamStub isStreamingSupported]).andReturn(YES);

                [streamingLifecycleManager.appStateMachine setToState:SDLAppStateActive fromOldState:nil callEnterTransition:NO];
            });

            context(@"and the stream is open", ^{
                beforeEach(^{
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateReady fromOldState:nil callEnterTransition:NO];
                });

                context(@"and the hmi state is limited", ^{
                    beforeEach(^{
                        streamingLifecycleManager.hmiLevel = SDLHMILevelLimited;
                    });

                    describe(@"and the hmi state changes to", ^{
                        context(@"none", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelNone, SDLVideoStreamingStateStreamable);
                            });

                            it(@"should close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                            });
                        });

                        context(@"background", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateStreamable);
                            });

                            it(@"should close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                            });
                        });

                        context(@"limited", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelLimited, SDLVideoStreamingStateStreamable);
                            });

                            it(@"should not close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateReady));
                            });
                        });

                        context(@"full", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateStreamable);
                            });

                            it(@"should not close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateReady));
                            });
                        });

                        context(@"full but not streamable", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateNotStreamable);
                            });

                            it(@"should close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                            });
                        });
                    });

                    describe(@"and the app state changes to", ^{
                        context(@"inactive", ^{
                            beforeEach(^{
                                [streamingLifecycleManager.appStateMachine setToState:SDLAppStateInactive fromOldState:nil callEnterTransition:YES];
                            });

                            it(@"should suspend the video stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateSuspended));
                            });
                        });
                    });
                });

                context(@"and the hmi state is full", ^{
                    beforeEach(^{
                        streamingLifecycleManager.hmiLevel = SDLHMILevelFull;
                    });

                    context(@"and hmi state changes to none", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelNone, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should close the streams", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should not close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateReady));
                        });
                    });

                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should not close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateReady));
                        });
                    });

                    context(@"full but not streamable", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to background after app becomes inactive", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateInactive fromOldState:nil callEnterTransition:YES];
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to background after app becomes inactive", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateInactive fromOldState:nil callEnterTransition:YES];
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });
                });
            });

            context(@"and both streams are closed", ^{
                beforeEach(^{
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStopped fromOldState:nil callEnterTransition:NO];

                    postRAINotification();
                });

                context(@"and the hmi state is none", ^{
                    beforeEach(^{
                        streamingLifecycleManager.hmiLevel = SDLHMILevelNone;
                    });

                    context(@"and hmi state changes to none", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelNone, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should not start the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                        });
                    });

                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should not start the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                        });
                    });

                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should start the streams", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStarting));
                        });
                    });

                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should start the streams", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStarting));
                        });
                    });

                    context(@"full but not streamable", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should not start the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                        });
                    });
                });
            });
        });

        describe(@"sending a video capabilities request", ^{
            beforeEach(^{
                [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStarting fromOldState:nil callEnterTransition:YES];
            });

            describe(@"after receiving a Video Start ACK", ^{
                __block SDLProtocolHeader *testVideoHeader = nil;
                __block SDLProtocolMessage *testVideoMessage = nil;
                __block SDLControlFramePayloadVideoStartServiceAck *testVideoStartServicePayload = nil;
                const int64_t testMTU = 789456;
                const int32_t testVideoHeight = 42;
                const int32_t testVideoWidth = 32;
                SDLVideoStreamingCodec testVideoCodec = SDLVideoStreamingCodecH264;
                SDLVideoStreamingProtocol testVideoProtocol = SDLVideoStreamingProtocolRTP;

                beforeEach(^{
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                    testVideoHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                    testVideoHeader.frameType = SDLFrameTypeSingle;
                    testVideoHeader.frameData = SDLFrameInfoStartServiceACK;
                    testVideoHeader.encrypted = YES;
                    testVideoHeader.serviceType = SDLServiceTypeVideo;
                });

                context(@"with data", ^{
                    beforeEach(^{
                        streamingLifecycleManager.videoScaleManager.scale = 1.0f;
                        testVideoStartServicePayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:testVideoHeight width:testVideoWidth protocol:testVideoProtocol codec:testVideoCodec];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartServicePayload.data];
                        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceACK:testVideoMessage];
                    });

                    it(@"should have set all the right properties", ^{
                        expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeMake(testVideoWidth, testVideoHeight)))).to(beTrue());
                        expect(streamingLifecycleManager.videoEncrypted).to(equal(YES));
                        expect(streamingLifecycleManager.videoFormat).to(equal([[SDLVideoStreamingFormat alloc] initWithCodec:testVideoCodec protocol:testVideoProtocol]));
                        expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateReady));

                        const CGSize displayViewportResolution = streamingLifecycleManager.videoScaleManager.displayViewportResolution;
                        const CGSize testSize = CGSizeMake(testVideoWidth, testVideoHeight);
                        if (!CGSizeEqualToSize(displayViewportResolution, testSize)) {
                            failWithMessage(([NSString stringWithFormat:@"wrong displayViewportResolution: %@, expected: %@", NSStringFromCGSize(displayViewportResolution), NSStringFromCGSize(testSize)]));
                        }
                    });
                });

                context(@"with missing data", ^{
                    beforeEach(^{
                        streamingLifecycleManager.videoScaleManager.scale = 1.0f;
                        testVideoStartServicePayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:testVideoHeight width:testVideoWidth protocol:nil codec:nil];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartServicePayload.data];
                        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceACK:testVideoMessage];
                    });

                    it(@"should fall back correctly", ^{
                        expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeMake(testVideoWidth, testVideoHeight)))).to(beTrue());
                        expect(streamingLifecycleManager.videoFormat).to(equal([[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW]));
                        expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateReady));
                    });
                });

                context(@"with missing screen height and screen width values", ^{
                    beforeEach(^{
                        postRAINotification();
                        streamingLifecycleManager.preferredResolutions = @[];

                        testVideoStartServicePayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:SDLControlFrameInt32NotFound width:SDLControlFrameInt32NotFound protocol:nil codec:nil];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartServicePayload.data];
                        expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeZero))).to(equal(@YES));
                    });
                    context(@"If no preferred resolutions were set in the data source", ^{
                        beforeEach(^{
                            streamingLifecycleManager.dataSource = nil;
                            [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceACK:testVideoMessage];
                        });
                        it(@"should not replace the existing screen resolution", ^{
                            expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeZero))).to(beTrue());
                            expect(streamingLifecycleManager.dataSource).to(beNil());
                        });
                    });
                    context(@"If the preferred resolution was set in the data source", ^{
                        __block SDLImageResolution *preferredResolutionLow = nil;
                        __block SDLImageResolution *preferredResolutionHigh = nil;

                        beforeEach(^{
                            preferredResolutionLow = [[SDLImageResolution alloc] initWithWidth:10 height:10];
                            preferredResolutionHigh = [[SDLImageResolution alloc] initWithWidth:100 height:100];
                            streamingLifecycleManager.dataSource = testDataSource;
                            streamingLifecycleManager.preferredResolutions = @[preferredResolutionLow, preferredResolutionHigh];

                            [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceACK:testVideoMessage];
                        });
                        it(@"should set the screen size using the first provided preferred resolution", ^{
                            CGSize preferredFormat = CGSizeMake(preferredResolutionLow.resolutionWidth.floatValue, preferredResolutionLow.resolutionHeight.floatValue);
                            expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, preferredFormat))).to(beTrue());
                            expect(streamingLifecycleManager.dataSource).toNot(beNil());
                        });
                    });
                });
            });

            describe(@"after receiving a Video Start NAK", ^{
                __block SDLProtocolHeader *testVideoHeader = nil;
                __block SDLProtocolMessage *testVideoMessage = nil;
                __block SDLControlFramePayloadNak *testVideoStartNakPayload = nil;
                __block NSArray<SDLVideoStreamingFormat *> *testPreferredFormats = nil;
                __block NSArray<SDLImageResolution *> *testPreferredResolutions = nil;

                beforeEach(^{
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                    testVideoHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                    testVideoHeader.frameType = SDLFrameTypeSingle;
                    testVideoHeader.frameData = SDLFrameInfoStartServiceACK;
                    testVideoHeader.encrypted = YES;
                    testVideoHeader.serviceType = SDLServiceTypeVideo;
                });

                context(@"with rejected parameters for resolution and codec and there is more than one supported resolution and video codec", ^{
                    beforeEach(^{
                        SDLVideoStreamingFormat *testVideoFormat = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecTheora protocol:SDLVideoStreamingProtocolWebM];
                        SDLVideoStreamingFormat *testVideoFormat2 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
                        testPreferredFormats = @[testVideoFormat, testVideoFormat2];
                        streamingLifecycleManager.preferredFormats = testPreferredFormats;
                        streamingLifecycleManager.preferredFormatIndex = 0;

                        SDLImageResolution *testImageResolution = [[SDLImageResolution alloc] initWithWidth:400 height:200];
                        SDLImageResolution *testImageResolution2 = [[SDLImageResolution alloc] initWithWidth:500 height:800];
                        testPreferredResolutions = @[testImageResolution, testImageResolution2];
                        streamingLifecycleManager.preferredResolutions = testPreferredResolutions;
                        streamingLifecycleManager.preferredResolutionIndex = 0;

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:@[[NSString stringWithUTF8String:SDLControlFrameHeightKey], [NSString stringWithUTF8String:SDLControlFrameVideoCodecKey]] reason:@"failed"];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartNakPayload.data];
                        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceNAK:testVideoMessage];
                    });

                    it(@"should have retried with new properties", ^{
                        expect(streamingLifecycleManager.preferredResolutionIndex).to(equal(1));
                        expect(streamingLifecycleManager.preferredFormatIndex).to(equal(1));
                    });
                });

                context(@"with rejected parameters for codec and there is more than one supported video codec", ^{
                    beforeEach(^{
                        SDLVideoStreamingFormat *testVideoFormat = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecTheora protocol:SDLVideoStreamingProtocolWebM];
                        SDLVideoStreamingFormat *testVideoFormat2 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
                        testPreferredFormats = @[testVideoFormat, testVideoFormat2];
                        streamingLifecycleManager.preferredFormats = testPreferredFormats;
                        streamingLifecycleManager.preferredFormatIndex = 0;

                        SDLImageResolution *testImageResolution = [[SDLImageResolution alloc] initWithWidth:400 height:200];
                        testPreferredResolutions = @[testImageResolution];
                        streamingLifecycleManager.preferredResolutions = testPreferredResolutions;
                        streamingLifecycleManager.preferredResolutionIndex = 0;

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:@[[NSString stringWithUTF8String:SDLControlFrameVideoCodecKey]] reason:@"failed"];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartNakPayload.data];
                        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceNAK:testVideoMessage];
                    });

                    it(@"should have retried with new properties", ^{
                        expect(streamingLifecycleManager.preferredResolutionIndex).to(equal(0));
                        expect(streamingLifecycleManager.preferredFormatIndex).to(equal(1));
                    });
                });

                context(@"with rejected parameters for codec and there are no more supported video codecs", ^{
                    beforeEach(^{
                        SDLVideoStreamingFormat *testVideoFormat = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
                        testPreferredFormats = @[testVideoFormat];
                        streamingLifecycleManager.preferredFormats = testPreferredFormats;

                        SDLImageResolution *testImageResolution = [[SDLImageResolution alloc] initWithWidth:400 height:200];
                        testPreferredResolutions = @[testImageResolution];
                        streamingLifecycleManager.preferredResolutions = testPreferredResolutions;

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:@[[NSString stringWithUTF8String:SDLControlFrameVideoCodecKey]] reason:@"failed"];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartNakPayload.data];
                        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceNAK:testVideoMessage];
                    });

                    it(@"should end the service", ^{
                        expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                    });
                });

                context(@"with missing data", ^{
                    beforeEach(^{
                        streamingLifecycleManager.preferredFormats = testPreferredFormats;
                        streamingLifecycleManager.preferredResolutions = testPreferredResolutions;

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:nil reason:nil];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartNakPayload.data];
                        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceNAK:testVideoMessage];
                    });

                    it(@"should end the service", ^{
                        expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                    });
                });
            });

            describe(@"after receiving a video end ACK", ^{
                beforeEach(^{
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                    SDLProtocolHeader *testVideoHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                    testVideoHeader.frameType = SDLFrameTypeSingle;
                    testVideoHeader.frameData = SDLFrameInfoEndServiceACK;
                    testVideoHeader.encrypted = NO;
                    testVideoHeader.serviceType = SDLServiceTypeVideo;

                    SDLProtocolMessage *testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:nil];
                    [streamingLifecycleManager protocol:protocolMock didReceiveEndServiceACK:testVideoMessage];
                });

                it(@"should have set all the right properties", ^{
                    expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                });
            });

            describe(@"after receiving a video end NAK", ^{
                beforeEach(^{
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                    SDLProtocolHeader *testVideoHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                    testVideoHeader.frameType = SDLFrameTypeSingle;
                    testVideoHeader.frameData = SDLFrameInfoEndServiceNACK;
                    testVideoHeader.encrypted = NO;
                    testVideoHeader.serviceType = SDLServiceTypeVideo;

                    SDLProtocolMessage *testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:nil];
                    [streamingLifecycleManager protocol:protocolMock didReceiveEndServiceNAK:testVideoMessage];
                });

                it(@"expect video stream is stopped", ^{
                    expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                });
            });
        });
    });

    describe(@"stopping the manager", ^{
        __block BOOL handlerCalled = NO;

        beforeEach(^{
            handlerCalled = NO;
            [streamingLifecycleManager endVideoServiceWithCompletionHandler:^ {
                handlerCalled = YES;
            }];
        });

        context(@"when the manager is not stopped", ^{
            beforeEach(^{
                [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateReady fromOldState:nil callEnterTransition:NO];
                [streamingLifecycleManager stop];
            });

            it(@"should transition to the stopped state", ^{
                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                expect(streamingLifecycleManager.protocol).to(beNil());
                expect(streamingLifecycleManager.hmiLevel).to(equal(SDLHMILevelNone));
                expect(streamingLifecycleManager.videoStreamingState).to(equal(SDLVideoStreamingStateNotStreamable));
                expect(streamingLifecycleManager.preferredFormatIndex).to(equal(0));
                expect(streamingLifecycleManager.preferredResolutionIndex).to(equal(0));
                expect(handlerCalled).to(beTrue());
            });
        });

        context(@"when the manager is already stopped", ^{
            beforeEach(^{
                [streamingLifecycleManager.videoStreamStateMachine setToState:SDLAudioStreamManagerStateStopped fromOldState:nil callEnterTransition:NO];
                [streamingLifecycleManager stop];
            });

            it(@"should stay in the stopped state", ^{
                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                expect(streamingLifecycleManager.protocol).to(beNil());
                expect(streamingLifecycleManager.hmiLevel).to(equal(SDLHMILevelNone));
                expect(streamingLifecycleManager.videoStreamingState).to(equal(SDLVideoStreamingStateNotStreamable));
                expect(streamingLifecycleManager.preferredFormatIndex).to(equal(0));
                expect(streamingLifecycleManager.preferredResolutionIndex).to(equal(0));
                expect(handlerCalled).to(beFalse());
            });
        });
    });

    describe(@"starting the manager", ^{
        SDLProtocol *protocolMock = OCMClassMock([SDLProtocol class]);

        beforeEach(^{
            [streamingLifecycleManager startWithProtocol:protocolMock];
        });

        describe(@"then ending the video service through the secondary transport", ^{
            beforeEach(^{
                [streamingLifecycleManager endVideoServiceWithCompletionHandler:^{}];
            });

            it(@"should send an end video service control frame", ^{
                OCMVerify([protocolMock endServiceWithType:SDLServiceTypeVideo]);
            });

            context(@"when the end video service ACKs", ^{
                beforeEach(^{
                    SDLProtocolHeader *testVideoHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                    testVideoHeader.frameType = SDLFrameTypeSingle;
                    testVideoHeader.frameData = SDLFrameInfoEndServiceACK;
                    testVideoHeader.encrypted = NO;
                    testVideoHeader.serviceType = SDLServiceTypeVideo;
                    SDLProtocolMessage *testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:nil];

                    [streamingLifecycleManager protocol:protocolMock didReceiveEndServiceACK:testVideoMessage];
                });

                it(@"should transistion to the stopped state", ^{
                    expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                });
            });

            context(@"when the end audio service NAKs", ^{
                beforeEach(^{
                    SDLProtocolHeader *testVideoHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                    testVideoHeader.frameType = SDLFrameTypeSingle;
                    testVideoHeader.frameData = SDLFrameInfoEndServiceNACK;
                    testVideoHeader.encrypted = NO;
                    testVideoHeader.serviceType = SDLServiceTypeVideo;
                    SDLProtocolMessage *testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:nil];

                    [streamingLifecycleManager protocol:protocolMock didReceiveEndServiceNAK:testVideoMessage];
                });

                it(@"should transistion to the stopped state", ^{
                    expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                });
            });
        });
    });

    describe(@"Creating a background video stream string", ^{
        NSString *expectedVideoStreamBackgroundString = [NSString stringWithFormat:@"When it is safe to do so, open %@ on your phone", testAppName];

        it(@"Should return the correct video stream background string for the screen size", ^{
            expect(streamingLifecycleManager.videoStreamBackgroundString).to(match(expectedVideoStreamBackgroundString));
        });
    });

    describe(@"Getting notifications of VideoStreamingCapability updates", ^{
        beforeEach(^{
            streamingLifecycleManager.delegate = nil;
            streamingLifecycleManager.dataSource = nil;
            streamingLifecycleManager.customEncoderSettings = nil;
            [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];
        });
        
        context(@"the module does not support the GetSystemCapabilities request", ^{
            __block SDLSystemCapability *testNilVideoStreamingCapability = nil;

            beforeEach(^{
                testNilVideoStreamingCapability = [[SDLSystemCapability alloc] init];
                testNilVideoStreamingCapability.videoStreamingCapability = nil;

                [streamingLifecycleManager sdl_videoStreamingCapabilityDidUpdate:testNilVideoStreamingCapability];
            });

            it(@"should use the library's default values", ^{
                expect(streamingLifecycleManager.videoStreamingCapability.maxBitrate).to(beNil());
                expect(streamingLifecycleManager.videoStreamingCapability.preferredFPS).to(beNil());

                expect(streamingLifecycleManager.preferredFormats).to(haveCount(1));
                expect(streamingLifecycleManager.preferredFormats[0].codec).to(equal(SDLVideoStreamingCodecH264));
                expect(streamingLifecycleManager.preferredFormats[0].protocol).to(equal(SDLVideoStreamingProtocolRAW));

                expect(streamingLifecycleManager.preferredResolutions).to(haveCount(1));
                expect(streamingLifecycleManager.preferredResolutions[0].resolutionWidth).to(equal(streamingLifecycleManager.videoScaleManager.displayViewportResolution.width));
                expect(streamingLifecycleManager.preferredResolutions[0].resolutionHeight).to(equal(streamingLifecycleManager.videoScaleManager.displayViewportResolution.height));


                expect(streamingLifecycleManager.focusableItemManager.enableHapticDataRequests).to(beFalse());
                expect(streamingLifecycleManager.videoScaleManager.scale).to(equal(streamingLifecycleManager.videoScaleManager.scale));
            });
        });

        context(@"the module supports the GetSystemCapabilities request", ^{
            __block SDLSystemCapability *testSystemCapability = nil;
            __block SDLVideoStreamingCapability *testVideoStreamingCapability = nil;

            context(@"the module does not support VideoStreamingCapability.additionalVideoStreamingCapabilities", ^{
                beforeEach(^{
                    SDLImageResolution *resolution = [[SDLImageResolution alloc] initWithWidth:44 height:99];
                    SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH265 protocol:SDLVideoStreamingProtocolRTMP];
                    SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
                    NSArray<SDLVideoStreamingFormat *> *testFormats = @[format1, format2];

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:@(333) supportedFormats:testFormats hapticSpatialDataSupported:@YES diagonalScreenSize:@(8.5) pixelPerInch:@(117) scale:@(1) preferredFPS:@(222)];

                    testSystemCapability = [[SDLSystemCapability alloc] init];
                    testSystemCapability.videoStreamingCapability = testVideoStreamingCapability;

                    [streamingLifecycleManager sdl_videoStreamingCapabilityDidUpdate:testSystemCapability];
                });

                it(@"should use the data from the VideoStreamingCapability", ^{
                    expect(streamingLifecycleManager.videoStreamingCapability.maxBitrate).to(equal(testVideoStreamingCapability.maxBitrate));
                    expect(streamingLifecycleManager.videoStreamingCapability.preferredFPS).to(equal(testVideoStreamingCapability.preferredFPS));

                    expect(streamingLifecycleManager.preferredResolutions).to(haveCount(1));
                    expect(streamingLifecycleManager.preferredResolutions[0].resolutionWidth).to(equal(testVideoStreamingCapability.preferredResolution.resolutionWidth));
                    expect(streamingLifecycleManager.preferredResolutions[0].resolutionHeight).to(equal(testVideoStreamingCapability.preferredResolution.resolutionHeight));

                    expect(streamingLifecycleManager.preferredFormats).to(haveCount(2));
                    expect(streamingLifecycleManager.preferredFormats[0].codec).to(equal(testVideoStreamingCapability.supportedFormats[0].codec));
                    expect(streamingLifecycleManager.preferredFormats[0].protocol).to(equal(testVideoStreamingCapability.supportedFormats[0].protocol));
                    expect(streamingLifecycleManager.preferredFormats[1].codec).to(equal(testVideoStreamingCapability.supportedFormats[1].codec));
                    expect(streamingLifecycleManager.preferredFormats[1].protocol).to(equal(testVideoStreamingCapability.supportedFormats[1].protocol));

                    expect(streamingLifecycleManager.focusableItemManager.enableHapticDataRequests).to(equal(YES));
                    expect(streamingLifecycleManager.videoScaleManager.scale).to(equal(testVideoStreamingCapability.scale));
                });
            });

            context(@"the module supports VideoStreamingCapability.additionalVideoStreamingCapabilities", ^{
                __block SDLVideoStreamingCapability *testAdditionalVideoStreamingCapability = nil;

                beforeEach(^{
                    SDLImageResolution *resolution = [[SDLImageResolution alloc] initWithWidth:44 height:99];
                    SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH265 protocol:SDLVideoStreamingProtocolRTMP];
                    SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
                    NSArray<SDLVideoStreamingFormat *> *testFormats = @[format1, format2];

                    testAdditionalVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testAdditionalVideoStreamingCapability.preferredResolution = [[SDLImageResolution alloc] initWithWidth:500 height:100];
                    testAdditionalVideoStreamingCapability.hapticSpatialDataSupported = @YES;
                    testAdditionalVideoStreamingCapability.diagonalScreenSize = @8;
                    testAdditionalVideoStreamingCapability.scale = @1;

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:@(333) supportedFormats:testFormats hapticSpatialDataSupported:@YES diagonalScreenSize:@(8.5) pixelPerInch:@(117) scale:@(1) preferredFPS:@(222)];
                    testVideoStreamingCapability.additionalVideoStreamingCapabilities = @[testAdditionalVideoStreamingCapability];

                    testSystemCapability = [[SDLSystemCapability alloc] init];
                    testSystemCapability.videoStreamingCapability = testVideoStreamingCapability;

                    [streamingLifecycleManager sdl_videoStreamingCapabilityDidUpdate:testSystemCapability];
                });

                it(@"should use the data from the VideoStreamingCapability and additionalVideoStreamingCapabilities", ^{
                    expect(streamingLifecycleManager.videoStreamingCapability.maxBitrate).to(equal(testVideoStreamingCapability.maxBitrate));
                    expect(streamingLifecycleManager.videoStreamingCapability.preferredFPS).to(equal(testVideoStreamingCapability.preferredFPS));

                    expect(streamingLifecycleManager.preferredResolutions).to(haveCount(2));
                    expect(streamingLifecycleManager.preferredResolutions[0].resolutionWidth).to(equal(testVideoStreamingCapability.preferredResolution.resolutionWidth));
                    expect(streamingLifecycleManager.preferredResolutions[0].resolutionHeight).to(equal(testVideoStreamingCapability.preferredResolution.resolutionHeight));
                    expect(streamingLifecycleManager.preferredResolutions[1].resolutionWidth).to(equal(testVideoStreamingCapability.additionalVideoStreamingCapabilities[0].preferredResolution.resolutionWidth));
                    expect(streamingLifecycleManager.preferredResolutions[1].resolutionHeight).to(equal(testVideoStreamingCapability.additionalVideoStreamingCapabilities[0].preferredResolution.resolutionHeight));

                    expect(streamingLifecycleManager.preferredFormats).to(haveCount(2));
                    expect(streamingLifecycleManager.preferredFormats[0].codec).to(equal(testVideoStreamingCapability.supportedFormats[0].codec));
                    expect(streamingLifecycleManager.preferredFormats[0].protocol).to(equal(testVideoStreamingCapability.supportedFormats[0].protocol));
                    expect(streamingLifecycleManager.preferredFormats[1].codec).to(equal(testVideoStreamingCapability.supportedFormats[1].codec));
                    expect(streamingLifecycleManager.preferredFormats[1].protocol).to(equal(testVideoStreamingCapability.supportedFormats[1].protocol));

                    expect(streamingLifecycleManager.focusableItemManager.enableHapticDataRequests).to(equal(YES));
                    expect(streamingLifecycleManager.videoScaleManager.scale).to(equal(testVideoStreamingCapability.scale));
                });
            });
        });
    });

    describe(@"setting the video encoder properties", ^{
        __block SDLVideoStreamingCapability *testVideoStreamingCapability = nil;

        beforeEach(^{
            testVideoStreamingCapability = nil;
        });

        describe(@"setting the bitrate", ^{
            context(@"the VideoStreamingCapability returns a maxBitrate", ^{
                it(@"should use the custom averageBitRate set by the developer when it is less than the VideoStreamingCapability's maxBitrate", ^{
                    int testVideoStreamingCapabilityMaxBitrate = 99999;
                    float testCustomBitRate = 88;

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.maxBitrate = @(testVideoStreamingCapabilityMaxBitrate);

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(111), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(testCustomBitRate)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate]).to(equal(@(testCustomBitRate)));
                });

                it(@"should use the the module's VideoStreamingCapability's maxBitrate if it is less than the averageBitRate set by the developer ", ^{
                    int testVideoStreamingCapabilityMaxBitrate = 88;
                    int testCustomBitRate = 99999;

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.maxBitrate = @(testVideoStreamingCapabilityMaxBitrate);

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(111), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(testCustomBitRate)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    int expectedCustomBitRate = testVideoStreamingCapabilityMaxBitrate * 1000; //convert from video streaming capability bitrate unit of kbps to video encoder units of bps
                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate]).to(equal(@(expectedCustomBitRate)));
                });

                it(@"should use the the module's VideoStreamingCapability's maxBitrate if no averageBitRate was set by the developer ", ^{
                    int testVideoStreamingCapabilityMaxBitrate = 7889;

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.maxBitrate = @(testVideoStreamingCapabilityMaxBitrate);

                    streamingLifecycleManager.customEncoderSettings = nil;

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    int expectedCustomBitRate = testVideoStreamingCapabilityMaxBitrate * 1000; //convert from video streaming capability bitrate unit of kbps to video encoder units of bps
                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate]).to(equal(@(expectedCustomBitRate)));
                });
            });

            context(@"the VideoStreamingCapability returns a nil maxBitrate", ^{
                it(@"should use the custom averageBitRate set by the developer even if it is larger than the default averageBitRate", ^{
                    int testCustomBitRate = 9900000; // larger than the default of @600000

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.maxBitrate = nil;

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(111), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(testCustomBitRate)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate]).to(equal(@(testCustomBitRate)));
                });

                it(@"should use the custom averageBitRate set by the developer even if it is smaller than the default averageBitRate", ^{
                    int testCustomBitRate = 2; // less than the default of @600000

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.maxBitrate = nil;

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(111), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(testCustomBitRate)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate]).to(equal(@(testCustomBitRate)));
                });

                it(@"should use the default averageBitRate if a custom averageBitRate was not set by the developer", ^{
                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.maxBitrate = nil;

                    streamingLifecycleManager.customEncoderSettings = nil;

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate]).to(equal(@(600000)));
                });
            });
        });

        describe(@"setting the framerate", ^{
            context(@"the VideoStreamingCapability returns a preferredFPS", ^{
                it(@"should use the custom expectedFrameRate set by the developer when it is less than the VideoStreamingCapability's preferredFPS", ^{
                    int testVideoStreamingCapabilityPreferredFPS = 1001;
                    float testCustomExpectedFrameRate = 66;

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.preferredFPS = @(testVideoStreamingCapabilityPreferredFPS);

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(testCustomExpectedFrameRate), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(22)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).to(equal(@(testCustomExpectedFrameRate)));
                });

                it(@"should use the the module's VideoStreamingCapability's preferredFPS if it is less than the expectedFrameRate set by the developer ", ^{
                    int testVideoStreamingCapabilityPreferredFPS = 66;
                    int testCustomExpectedFrameRate = 1001;

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.preferredFPS = @(testVideoStreamingCapabilityPreferredFPS);

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(testCustomExpectedFrameRate), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(22)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).to(equal(@(testVideoStreamingCapabilityPreferredFPS)));
                });

                it(@"should use the the module's VideoStreamingCapability's preferredFPS if no expectedFrameRate was set by the developer ", ^{
                    int testVideoStreamingCapabilityPreferredFPS = 66;

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.preferredFPS = @(testVideoStreamingCapabilityPreferredFPS);

                    streamingLifecycleManager.customEncoderSettings = nil;

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).to(equal(@(testVideoStreamingCapabilityPreferredFPS)));
                });
            });

            context(@"the VideoStreamingCapability returns a nil preferredFPS", ^{
                it(@"should use the custom expectedFrameRate set by the developer even if it is larger than the default expectedFrameRate", ^{
                    int testCustomExpectedFrameRate = 990; // larger than the default of @15

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.preferredFPS = nil;

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(testCustomExpectedFrameRate), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(22)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).to(equal(@(testCustomExpectedFrameRate)));
                });

                it(@"should use the custom expectedFrameRate set by the developer even if it is smaller than the default expectedFrameRate", ^{
                    int testCustomExpectedFrameRate = 2; // less than the default of @15

                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.preferredFPS = nil;

                    streamingLifecycleManager.customEncoderSettings = @{(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate:@(testCustomExpectedFrameRate), (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate:@(22)};

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).to(equal(@(testCustomExpectedFrameRate)));
                });

                it(@"should use the default expectedFrameRate if a custom expectedFrameRate was not set by the developer", ^{
                    testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
                    testVideoStreamingCapability.preferredFPS = nil;

                    streamingLifecycleManager.customEncoderSettings = nil;

                    [streamingLifecycleManager sdl_applyVideoCapability:testVideoStreamingCapability];

                    expect(streamingLifecycleManager.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).to(equal(@(15)));
                });
            });
        });
    });
});

QuickSpecEnd

#pragma mark - test Capabilities Filtering Logic

QuickSpecBegin(SDLStreamingVideoLifecycleManagerSpec_CapabilitiesFiltering)
// declare and init constants that do not change during test lifecycle
SDLImageResolution *resolution1 = [[SDLImageResolution alloc] initWithWidth:800 height:380];
SDLImageResolution *resolution2 = [[SDLImageResolution alloc] initWithWidth:320 height:200];
SDLImageResolution *resolution3 = [[SDLImageResolution alloc] initWithWidth:480 height:320];
SDLImageResolution *resolution4 = [[SDLImageResolution alloc] initWithWidth:400 height:380];
SDLImageResolution *resolution5 = [[SDLImageResolution alloc] initWithWidth:800 height:240];
SDLImageResolution *resolution6 = [[SDLImageResolution alloc] initWithWidth:200 height:400]; // portrait small
SDLImageResolution *resolution7 = [[SDLImageResolution alloc] initWithWidth:2000 height:4000]; // portrait large
SDLImageResolution *resolution8 = [[SDLImageResolution alloc] initWithWidth:200 height:200];

SDLVideoStreamingCapability *capability1 = [[SDLVideoStreamingCapability alloc] init];
capability1.preferredResolution = resolution1;
capability1.hapticSpatialDataSupported = @YES;
capability1.diagonalScreenSize = @8;
capability1.scale = @1;

SDLVideoStreamingCapability *capability2 = [[SDLVideoStreamingCapability alloc] init];
capability2.preferredResolution = resolution2;
capability2.hapticSpatialDataSupported = @NO;
capability2.diagonalScreenSize = @3;

SDLVideoStreamingCapability *capability3 = [[SDLVideoStreamingCapability alloc] init];
capability3.preferredResolution = resolution3;
capability3.hapticSpatialDataSupported = @YES;
capability3.diagonalScreenSize = @5;

SDLVideoStreamingCapability *capability4 = [[SDLVideoStreamingCapability alloc] init];
capability4.preferredResolution = resolution4;
capability4.hapticSpatialDataSupported = @YES;
capability4.diagonalScreenSize = @4;

SDLVideoStreamingCapability *capability5 = [[SDLVideoStreamingCapability alloc] init];
capability5.preferredResolution = resolution5;
capability5.hapticSpatialDataSupported = @YES;
capability5.diagonalScreenSize = @4;

SDLVideoStreamingCapability *capability6 = [[SDLVideoStreamingCapability alloc] init];
capability6.preferredResolution = resolution1;
capability6.hapticSpatialDataSupported = @YES;
capability6.diagonalScreenSize = @5;
capability6.scale = @1.5;

SDLVideoStreamingCapability *capability7 = [[SDLVideoStreamingCapability alloc] init];
capability7.preferredResolution = resolution1;
capability7.hapticSpatialDataSupported = @YES;
capability7.diagonalScreenSize = @4;
capability7.scale = @2;

SDLVideoStreamingCapability *capability8 = [[SDLVideoStreamingCapability alloc] init]; // portrait small
capability8.preferredResolution = resolution6;
capability8.hapticSpatialDataSupported = @YES;
capability8.diagonalScreenSize = @4;

SDLVideoStreamingCapability *capability9 = [[SDLVideoStreamingCapability alloc] init]; // portrait large
capability9.preferredResolution = resolution7;
capability9.hapticSpatialDataSupported = @YES;
capability9.diagonalScreenSize = @4;

SDLVideoStreamingCapability *capability10 = [[SDLVideoStreamingCapability alloc] init]; // square
capability10.preferredResolution = resolution8;
capability10.hapticSpatialDataSupported = @YES;
capability10.diagonalScreenSize = @2;
capability10.scale = @1;

SDLVideoStreamingFormat *vsFormat1 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
SDLVideoStreamingFormat *vsFormat2 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
SDLVideoStreamingFormat *vsFormat3 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecTheora protocol:SDLVideoStreamingProtocolRTSP];
SDLVideoStreamingFormat *vsFormat4 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecVP8 protocol:SDLVideoStreamingProtocolRTMP];
SDLVideoStreamingFormat *vsFormat5 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecVP9 protocol:SDLVideoStreamingProtocolWebM];

SDLVideoStreamingCapability *capability0 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution1 maxBitrate:@(400000) supportedFormats:@[vsFormat1, vsFormat2, vsFormat3, vsFormat4, vsFormat5] hapticSpatialDataSupported:@YES diagonalScreenSize:@(8) pixelPerInch:@(96) scale:@(1) preferredFPS:nil];
capability0.additionalVideoStreamingCapabilities = @[capability1, capability2, capability3, capability4, capability5, capability6, capability7, capability8, capability9, capability10];

describe(@"supported video capabilities and formats", ^{
    TestSmartConnectionManager *testConnectionManager = [[TestSmartConnectionManager alloc] init];
    SDLConfiguration *testConfig = [[SDLConfiguration alloc] init];
    SDLStreamingVideoLifecycleManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfig systemCapabilityManager:nil];

    context(@"neither landscape nor portrait constraint set", ^{
        NSArray <SDLVideoStreamingCapability*>* allCapabilities = [capability0 allVideoStreamingCapabilities];

        it(@"should let all capabilities in (nothing filtered out)", ^{
            streamingLifecycleManager.supportedLandscapeStreamingRange = nil;
            streamingLifecycleManager.supportedPortraitStreamingRange = nil;
            NSArray *filteredCapabilities = [streamingLifecycleManager matchVideoCapability:capability0];
            expect(filteredCapabilities).to(equal(allCapabilities));
        });
    });

    context(@"landscape restricted and any portrait", ^{
        SDLImageResolution *resMin = [[SDLImageResolution alloc] initWithWidth:320 height:200];
        SDLImageResolution *resMax = [[SDLImageResolution alloc] initWithWidth:350 height:220];
        SDLVideoStreamingRange *landRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:resMin maximumResolution:resMax];

        it(@"should filter 320x200 and small and large portrait", ^{
            streamingLifecycleManager.supportedLandscapeStreamingRange = landRange;
            streamingLifecycleManager.supportedPortraitStreamingRange = nil;

            expect(streamingLifecycleManager.supportedLandscapeStreamingRange).to(equal(landRange));
            expect(streamingLifecycleManager.supportedPortraitStreamingRange).to(beNil());
            // 320x200 & portrait small & large & square are expected
            NSArray *expectedArray = @[capability2, capability8, capability9, capability10];
            NSArray *matchArray = [streamingLifecycleManager matchVideoCapability:capability0];
            expect(matchArray).to(equal(expectedArray));
        });
    });
         
    context(@"portrait restricted and wrong landscape", ^{
        it(@"should filter portrait small", ^{
            // wrong range: max < min, will throw an exception
            SDLImageResolution *resMaxL = [[SDLImageResolution alloc] initWithWidth:320 height:200];
            SDLImageResolution *resMinL = [[SDLImageResolution alloc] initWithWidth:350 height:220];

            expectAction(^{
                SDLVideoStreamingRange *landRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:resMinL maximumResolution:resMaxL];
                expect(landRange).to(beNil());
            }).to(raiseException());

        });
    });

    context(@"both landscape and portrait restricted", ^{
        SDLImageResolution *resMinP = [[SDLImageResolution alloc] initWithWidth:200 height:320];
        SDLImageResolution *resMaxP = [[SDLImageResolution alloc] initWithWidth:300 height:420];
        SDLVideoStreamingRange *portRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:resMinP maximumResolution:resMaxP];

        SDLImageResolution *resMinL = [[SDLImageResolution alloc] initWithWidth:320 height:200];
        SDLImageResolution *resMaxL = [[SDLImageResolution alloc] initWithWidth:350 height:220];
        SDLVideoStreamingRange *landRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:resMinL maximumResolution:resMaxL];

        it(@"should filter 320x200 and portrait small", ^{
            streamingLifecycleManager.supportedLandscapeStreamingRange = landRange;
            streamingLifecycleManager.supportedPortraitStreamingRange = portRange;

            expect(streamingLifecycleManager.supportedLandscapeStreamingRange).to(equal(landRange));
            expect(streamingLifecycleManager.supportedPortraitStreamingRange).to(equal(portRange));
            NSArray *expectedArray = @[capability2, capability8];
            NSArray *matchArray = [streamingLifecycleManager matchVideoCapability:capability0];
            expect(matchArray).to(equal(expectedArray));
        });
    });

    context(@"square", ^{
        SDLImageResolution *resMin = [[SDLImageResolution alloc] initWithWidth:100 height:100];
        SDLImageResolution *resMax = [[SDLImageResolution alloc] initWithWidth:200 height:200];
        SDLVideoStreamingRange *range = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:resMin maximumResolution:resMax];
        range.minimumAspectRatio = 1.0;
        range.maximumAspectRatio = 1.0;
        range.minimumDiagonal = 1;

        it(@"expect all portraits and square", ^{
            streamingLifecycleManager.supportedLandscapeStreamingRange = range;
            streamingLifecycleManager.supportedPortraitStreamingRange = nil;

            expect(streamingLifecycleManager.supportedLandscapeStreamingRange).to(equal(range));
            expect(streamingLifecycleManager.supportedPortraitStreamingRange).to(beNil());

            // no portrait restriction therefore all portrait & square
            NSArray *expectedArray = @[capability8, capability9, capability10];
            NSArray *matchArray = [streamingLifecycleManager matchVideoCapability:capability0];
            expect(matchArray).to(equal(expectedArray));
        });

        it(@"expect all landscapes and square", ^{
            streamingLifecycleManager.supportedLandscapeStreamingRange = nil;
            streamingLifecycleManager.supportedPortraitStreamingRange = range;

            expect(streamingLifecycleManager.supportedLandscapeStreamingRange).to(beNil());
            expect(streamingLifecycleManager.supportedPortraitStreamingRange).to(equal(range));

            NSArray *expectedArray = @[capability0, capability1, capability2, capability3, capability4, capability5, capability6, capability7, capability10];
            NSArray *matchArray = [streamingLifecycleManager matchVideoCapability:capability0];
            expect(matchArray).to(equal(expectedArray));
        });

        it(@"expect square alone", ^{
            streamingLifecycleManager.supportedLandscapeStreamingRange = range;
            streamingLifecycleManager.supportedPortraitStreamingRange = range;

            expect(streamingLifecycleManager.supportedLandscapeStreamingRange).to(equal(range));
            expect(streamingLifecycleManager.supportedPortraitStreamingRange).to(equal(range));

            NSArray *expectedArray = @[capability10];
            NSArray *matchArray = [streamingLifecycleManager matchVideoCapability:capability0];
            expect(matchArray).to(equal(expectedArray));
        });
    });
});

QuickSpecEnd

#pragma mark - helper functions

static void postRAINotification() {
    SDLRegisterAppInterfaceResponse *rai = [[SDLRegisterAppInterfaceResponse alloc] init];
    rai.hmiCapabilities = [[SDLHMICapabilities alloc] initWithNavigation:@YES phoneCall:@YES videoStreaming:@YES remoteControl:@YES appServices:@YES displays:@YES seatLocation:@YES driverDistraction:@YES];
    rai.success = @YES;
    SDLRPCResponseNotification *note = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:nil rpcResponse:rai];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

static void sendNotificationForHMILevel(SDLHMILevel hmiLevel, SDLVideoStreamingState streamState) {
    SDLOnHMIStatus *hmiStatus = [[SDLOnHMIStatus alloc] init];
    hmiStatus.hmiLevel = hmiLevel;
    hmiStatus.videoStreamingState = streamState;
    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:hmiStatus];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
};

static SDLGetSystemCapabilityResponse* createSystemCapabilityResponse() {
    SDLImageResolution *resolution = [[SDLImageResolution alloc] initWithWidth:testVSCResolutionWidth height:testVSCResolutionHeight];
    SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH265 protocol:SDLVideoStreamingProtocolRTMP];
    SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
    NSArray<SDLVideoStreamingFormat *> *testFormats = @[format1, format2];

    SDLVideoStreamingCapability *videoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:@(testVSCMaxBitrate) supportedFormats:testFormats hapticSpatialDataSupported:@YES diagonalScreenSize:@(8.5) pixelPerInch:@(117) scale:@(testVSCScale) preferredFPS:nil];
    SDLGetSystemCapabilityResponse *response = [[SDLGetSystemCapabilityResponse alloc] init];
    response.success = @YES;
    response.systemCapability = [[SDLSystemCapability alloc] initWithVideoStreamingCapability:videoStreamingCapability];

    return response;
}
