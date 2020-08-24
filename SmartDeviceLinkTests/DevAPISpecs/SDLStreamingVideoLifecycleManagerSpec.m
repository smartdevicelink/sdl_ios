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

@interface SDLStreamingVideoLifecycleManager ()

@property (weak, nonatomic) SDLProtocol *protocol;
@property (copy, nonatomic, readonly) NSString *appName;
@property (copy, nonatomic, readonly) NSString *videoStreamBackgroundString;
@property (copy, nonatomic, nullable) NSString *connectedVehicleMake;
- (void)shutDown;

@end

// video streaming capabilities values for testing, used in SDLGetSystemCapabilityResponse
static const float testVSCScale = 1.25;
static const int32_t testVSCMaxBitrate = 12345;
static const uint16_t testVSCResolutionWidth = 42;
static const uint16_t testVSCResolutionHeight = 69;

static void postRAINotification(void);
static void sendNotificationForHMILevel(SDLHMILevel hmiLevel, SDLVideoStreamingState streamState);
static SDLGetSystemCapabilityResponse *createSystemCapabilityResponse(void);

QuickSpecBegin(SDLStreamingVideoLifecycleManagerSpec)

describe(@"the streaming video manager", ^{
    __block SDLStreamingVideoLifecycleManager *streamingLifecycleManager = nil;
    SDLStreamingMediaConfiguration *testConfiguration = [SDLStreamingMediaConfiguration insecureConfiguration];
    SDLCarWindowViewController *testViewController = [[SDLCarWindowViewController alloc] init];
    SDLFakeStreamingManagerDataSource *testDataSource = [[SDLFakeStreamingManagerDataSource alloc] init];
    NSString *testAppName = @"Test App";
    SDLLifecycleConfiguration *testLifecycleConfiguration = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:@""];

    // set proper version up
    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion version:6:0:0];
    [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion version:6:0:0];

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
            // shutDown to unsubscribe from notifications, otherwise the zombie managers will still receive all notifications
            [streamingLifecycleManager shutDown];
            streamingLifecycleManager = nil;
        }
    });

    it(@"should initialize properties", ^{
        expect(streamingLifecycleManager.videoScaleManager.scale).to(equal([[SDLStreamingVideoScaleManager alloc] init].scale));
        expect(streamingLifecycleManager.touchManager).toNot(beNil());
        expect(streamingLifecycleManager.focusableItemManager).toNot(beNil());
        expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@YES)); // RAI already received
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

    describe(@"check isStreamingSupported", ^{
        it(@"expect post RAI change streaming inner state", ^{
            expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
            postRAINotification();
            expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@YES));
        });

        it(@"should get the value from the system capability manager", ^{
            expect(@([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming])).to(equal(@YES));
        });

        it(@"should return true by default if the system capability manager is nil", ^{
            streamingLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfig systemCapabilityManager:nil];
            expect(streamingLifecycleManager.isStreamingSupported).to(beTrue());
        });
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
            __block SDLDisplayCapabilities *someDisplayCapabilities = nil;
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
                    someRegisterAppInterfaceResponse.vehicleType = testVehicleType;
                    someRegisterAppInterfaceResponse.success = @YES;

                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should save the connected vehicle make but not the screen size", ^{
                    expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeZero))).toEventually(equal(@YES));
                    expect(streamingLifecycleManager.connectedVehicleMake).toEventually(equal(testVehicleType.make));
                });
            });

            describe(@"that supports video streaming", ^{
                beforeEach(^{
                    someHMICapabilities = [[SDLHMICapabilities alloc] init];
                    someHMICapabilities.videoStreaming = @YES;

                    someDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    someDisplayCapabilities.screenParams = someScreenParams;

                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    someRegisterAppInterfaceResponse.hmiCapabilities = someHMICapabilities;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                    someRegisterAppInterfaceResponse.displayCapabilities = someDisplayCapabilities;
#pragma clang diagnostic pop
                    someRegisterAppInterfaceResponse.vehicleType = testVehicleType;

                    someRegisterAppInterfaceResponse.vehicleType = testVehicleType;

                    someRegisterAppInterfaceResponse.success = @YES;

                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should save the connected vehicle make and the screen size", ^{
                    expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeMake(600, 100)))).toEventually(equal(@YES));
                    expect(streamingLifecycleManager.connectedVehicleMake).toEventually(equal(testVehicleType.make));
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
                                expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
                            });
                        });

                        context(@"background", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateStreamable);
                            });

                            it(@"should close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
                            });
                        });

                        context(@"limited", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelLimited, SDLVideoStreamingStateStreamable);
                            });

                            it(@"should not close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateReady));
                            });
                        });

                        context(@"full", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateStreamable);
                            });

                            it(@"should not close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateReady));
                            });
                        });

                        context(@"full but not streamable", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateNotStreamable);
                            });

                            it(@"should close the stream", ^{
                                expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
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
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should not close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateReady));
                        });
                    });

                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should not close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateReady));
                        });
                    });

                    context(@"full but not streamable", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to background after app becomes inactive", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateInactive fromOldState:nil callEnterTransition:YES];
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to background after app becomes inactive", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateInactive fromOldState:nil callEnterTransition:YES];
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateShuttingDown));
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
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateStopped));
                        });
                    });

                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should not start the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateStopped));
                        });
                    });

                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should start the streams", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateStarting));
                        });
                    });

                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateStreamable);
                        });

                        it(@"should start the streams", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateStarting));
                        });
                    });

                    context(@"full but not streamable", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateNotStreamable);
                        });

                        it(@"should not start the stream", ^{
                            expect(streamingLifecycleManager.currentVideoStreamState).toEventually(equal(SDLVideoStreamManagerStateStopped));
                        });
                    });
                });
            });
        });

        describe(@"sending a video capabilities request", ^{
            beforeEach(^{
                [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateStarting fromOldState:nil callEnterTransition:YES];
            });

            it(@"should send out a video capabilities request", ^{
                SDLGetSystemCapability *getCapability = (SDLGetSystemCapability *)testConnectionManager.receivedRequests.lastObject;
                if (getCapability) {
                    expect(getCapability).to(beAnInstanceOf([SDLGetSystemCapability class]));
                    expect(getCapability.systemCapabilityType).to(equal(SDLSystemCapabilityTypeVideoStreaming));
                } else {
                    failWithMessage(@"no requests recorded");
                }
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
                        testVideoStartServicePayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:testVideoHeight width:testVideoWidth protocol:testVideoProtocol codec:testVideoCodec];
                        testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartServicePayload.data];
                        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceACK:testVideoMessage];
                    });

                    it(@"should have set all the right properties", ^{
                        expect([[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeVideo]).to(equal(testMTU));
                        expect(@(CGSizeEqualToSize(streamingLifecycleManager.videoScaleManager.displayViewportResolution, CGSizeMake(testVideoWidth, testVideoHeight)))).to(beTrue());
                        expect(streamingLifecycleManager.videoEncrypted).to(equal(YES));
                        expect(streamingLifecycleManager.videoFormat).to(equal([[SDLVideoStreamingFormat alloc] initWithCodec:testVideoCodec protocol:testVideoProtocol]));
                        expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateReady));
                    });
                });

                context(@"with missing data", ^{
                    beforeEach(^{
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

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:@[[NSString stringWithUTF8String:SDLControlFrameHeightKey], [NSString stringWithUTF8String:SDLControlFrameVideoCodecKey]]];
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

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:@[[NSString stringWithUTF8String:SDLControlFrameVideoCodecKey]]];
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

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:@[[NSString stringWithUTF8String:SDLControlFrameVideoCodecKey]]];
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

                        testVideoStartNakPayload = [[SDLControlFramePayloadNak alloc] initWithRejectedParams:nil];
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
            streamingLifecycleManager.connectedVehicleMake = @"OEM_make_2";
        });

        context(@"when the manager is not stopped", ^{
            beforeEach(^{
                [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamManagerStateReady fromOldState:nil callEnterTransition:NO];
                [streamingLifecycleManager stop];
            });

            it(@"should transition to the stopped state", ^{
                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamManagerStateStopped));
                expect(streamingLifecycleManager.protocol).to(beNil());
                expect(streamingLifecycleManager.connectedVehicleMake).to(beNil());
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
                expect(streamingLifecycleManager.connectedVehicleMake).to(beNil());
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
});

QuickSpecEnd


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

    SDLVideoStreamingCapability *videoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:testVSCMaxBitrate supportedFormats:testFormats hapticDataSupported:YES diagonalScreenSize:8.5 pixelPerInch:117 scale:testVSCScale];
    SDLGetSystemCapabilityResponse *response = [[SDLGetSystemCapabilityResponse alloc] init];
    response.success = @YES;
    response.systemCapability = [[SDLSystemCapability alloc] initWithVideoStreamingCapability:videoStreamingCapability];

    return response;
}

//.frameData = SDLFrameInfoStartServiceACK;
SDLProtocolHeader *createProtocolHeader(SDLFrameInfo frameData) {
    SDLProtocolHeader *testVideoHeader = nil;
    testVideoHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
    testVideoHeader.frameType = SDLFrameTypeSingle;
    testVideoHeader.frameData = frameData;
    testVideoHeader.encrypted = YES;
    testVideoHeader.serviceType = SDLServiceTypeVideo;
    return testVideoHeader;
}

QuickSpecBegin(SDLStreamingVideoLifecycleManagerSpec_GetSystemCapabilities)

const NSInteger testScaledWidth = roundf((float)testVSCResolutionWidth/testVSCScale);
const NSInteger testScaledHeight = roundf((float)testVSCResolutionHeight/testVSCScale);

describe(@"after sending GetSystemCapabilities", ^{
    __block SDLStreamingVideoLifecycleManager *streamingLifecycleManager = nil;
    // we need to keep the delegate somewhere sinse the manager does not retain it (weak ref)
    __strong __block TestStreamingMediaDelegate *strongDelegate = nil;
    SDLStreamingMediaConfiguration *testConfiguration = [SDLStreamingMediaConfiguration insecureConfiguration];
    SDLCarWindowViewController *testViewController = [[SDLCarWindowViewController alloc] init];
    SDLFakeStreamingManagerDataSource *testDataSource = [[SDLFakeStreamingManagerDataSource alloc] init];
    NSString *testAppName = @"Test App";
    SDLLifecycleConfiguration *testLifecycleConfiguration = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:@""];

    // set proper version up
    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion version:6:0:0];
    [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion version:6:0:0];

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
        // create, init and setup SDLStreamingVideoLifecycleManager
        strongDelegate = [[TestStreamingMediaDelegate alloc] init];
        testConfig.streamingMediaConfig.delegate = strongDelegate;
        streamingLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfig systemCapabilityManager:testSystemCapabilityManager];
        testConnectionManager.lastRequestBlock = ^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            SDLLogD(@"testConnectionManager.lastRequestBlock:\n\trequest:{%@};\n\tresponse:{%@}\n\terror:{%@};", request, response, error);
        };
        SDLProtocol *protocolMock = OCMClassMock([SDLProtocol class]);
        [streamingLifecycleManager startWithProtocol:protocolMock];
        postRAINotification();

        const int64_t testMTU = 789456;
        const int32_t testVideoWidth = 320;
        const int32_t testVideoHeight = 480;
        SDLVideoStreamingCodec testVideoCodec = SDLVideoStreamingCodecH264;
        SDLVideoStreamingProtocol testVideoProtocol = SDLVideoStreamingProtocolRTP;

        SDLControlFramePayloadVideoStartServiceAck *testVideoStartServicePayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:testVideoHeight width:testVideoWidth protocol:testVideoProtocol codec:testVideoCodec];
        SDLProtocolHeader *testVideoHeader = createProtocolHeader(SDLFrameInfoStartServiceACK);
        SDLProtocolMessage *testVideoMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testVideoHeader andPayload:testVideoStartServicePayload.data];

        [streamingLifecycleManager protocol:protocolMock didReceiveStartServiceACK:testVideoMessage];
        sendNotificationForHMILevel(SDLHMILevelFull, SDLVideoStreamingStateStreamable);
    });

    afterEach(^{
        [strongDelegate reset];
        if (streamingLifecycleManager) {
            [streamingLifecycleManager shutDown];
            // unsubscribe from notifications, otherwise the zombie managers will still receive all notifications
            [[NSNotificationCenter defaultCenter] removeObserver:streamingLifecycleManager];
            streamingLifecycleManager = nil;
        }
        SDLLogD(@"End of test\n\n");
    });


    context(@"and receiving an error response", ^{
        // This happens if the HU doesn't understand GetSystemCapabilities
        beforeEach(^{
            SDLGenericResponse *genericResponse = [[SDLGenericResponse alloc] init];
            genericResponse.success = @NO;
            genericResponse.resultCode = SDLResultInvalidData;

            [testConnectionManager respondToLastRequestWithResponse:genericResponse];
        });

        it(@"should have correct format and resolution", ^{
            expect(streamingLifecycleManager.preferredFormats).notTo(beNil());
            expect(streamingLifecycleManager.preferredResolutions).notTo(beNil());
            if (!streamingLifecycleManager.preferredFormats || !streamingLifecycleManager.preferredResolutions) {
                return;
            }

            const int expectedFormatCount = 3;
            NSArray<SDLVideoStreamingFormat *> *preferredFormats = streamingLifecycleManager.preferredFormats;
            if (expectedFormatCount == preferredFormats.count) {
                SDLVideoStreamingFormat *format = preferredFormats[expectedFormatCount-1];
                expect(format.codec).to(equal(SDLVideoStreamingCodecH264));
                expect(format.protocol).to(equal(SDLVideoStreamingProtocolRTP));
            } else {
                failWithMessage(([NSString stringWithFormat:@"expected %d preferred format only but got %d instead\n%@", expectedFormatCount, (int)preferredFormats.count, preferredFormats]));
            }

            NSArray<SDLImageResolution *> *preferredResolutions = streamingLifecycleManager.preferredResolutions;
            if (1 == preferredResolutions.count) {
                SDLImageResolution *resolution = preferredResolutions[0];
                expect(resolution.resolutionWidth).to(equal(testScaledWidth));
                expect(resolution.resolutionHeight).to(equal(testScaledHeight));
            } else {
                failWithMessage(([NSString stringWithFormat:@"expected one preferred resolution alone but got %d instead", (int)preferredResolutions.count]));
            }
        });

        context(@"and receiving a response", ^{
            beforeEach(^{
                SDLGetSystemCapabilityResponse *response = createSystemCapabilityResponse();
                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should have correct data from the data source", ^{
                expect(streamingLifecycleManager.preferredFormats).notTo(beNil());
                expect(streamingLifecycleManager.preferredResolutions).notTo(beNil());
                if (!streamingLifecycleManager.preferredFormats || !streamingLifecycleManager.preferredResolutions) {
                    return;
                }

                // Correct formats should be retrieved from the data source
                expect(streamingLifecycleManager.preferredResolutions).to(haveCount(1));

                expect(streamingLifecycleManager.preferredResolutions.firstObject.resolutionWidth).to(equal(testScaledWidth));
                expect(streamingLifecycleManager.preferredResolutions.firstObject.resolutionHeight).to(equal(testScaledHeight));

                expect(streamingLifecycleManager.preferredFormats).to(haveCount(streamingLifecycleManager.supportedFormats.count + 1));
                expect(streamingLifecycleManager.preferredFormats.firstObject.codec).to(equal(testDataSource.extraFormat.codec));
                expect(streamingLifecycleManager.preferredFormats.firstObject.protocol).to(equal(testDataSource.extraFormat.protocol));

                // The haptic manager should be enabled
                expect(streamingLifecycleManager.focusableItemManager.enableHapticDataRequests).to(equal(YES));
            });

            it(@"should have decided upon the correct preferred format and resolution", ^{
                expect(streamingLifecycleManager.preferredFormats).notTo(beNil());
                expect(streamingLifecycleManager.preferredResolutions).notTo(beNil());
                if (!streamingLifecycleManager.preferredFormats || !streamingLifecycleManager.preferredResolutions) {
                    return;
                }

                SDLVideoStreamingFormat *preferredFormat = streamingLifecycleManager.preferredFormats[streamingLifecycleManager.preferredFormatIndex];
                expect(preferredFormat.codec).to(equal(SDLVideoStreamingCodecH264));
                expect(preferredFormat.protocol).to(equal(SDLVideoStreamingProtocolRTP));

                SDLImageResolution *preferredResolution = streamingLifecycleManager.preferredResolutions[streamingLifecycleManager.preferredResolutionIndex];
                expect(preferredResolution.resolutionWidth).to(equal(@(testScaledWidth)));
                expect(preferredResolution.resolutionHeight).to(equal(@(testScaledHeight)));
            });

            it(@"should set the correct scale value", ^{
                expect(streamingLifecycleManager.videoScaleManager).notTo(beNil());
                expect(streamingLifecycleManager.videoScaleManager.scale).to(equal(testVSCScale));
            });
        });
    });

});

QuickSpecEnd
