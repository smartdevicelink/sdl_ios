//
//  SDLStreamingMediaLifecycleManagerSpec.m
//  SmartDeviceLink-iOS
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLConnectionManagerType.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGenericResponse.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLHMILevel.h"
#import "SDLImageResolution.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaLifecycleManager.h"
#import "SDLFakeStreamingManagerDataSource.h"
#import "SDLSystemCapability.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLStreamingMediaLifecycleManagerSpec)

fdescribe(@"the streaming media manager", ^{
    __block SDLStreamingMediaLifecycleManager *streamingLifecycleManager = nil;
    __block SDLStreamingMediaConfiguration *testConfiguration = [SDLStreamingMediaConfiguration insecureConfiguration];
    __block SDLFakeStreamingManagerDataSource *testDataSource = [[SDLFakeStreamingManagerDataSource alloc] init];
    __block NSString *someBackgroundTitleString = nil;
    __block TestConnectionManager *testConnectionManager = nil;
    
    __block void (^sendNotificationForHMILevel)(SDLHMILevel hmiLevel) = ^(SDLHMILevel hmiLevel) {
        SDLOnHMIStatus *hmiStatus = [[SDLOnHMIStatus alloc] init];
        hmiStatus.hmiLevel = hmiLevel;
        SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:hmiStatus];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [NSThread sleepForTimeInterval:0.1];
    };
    
    beforeEach(^{
        testConfiguration.customVideoEncoderSettings = @{
                                     (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate : @1
                                     };
        testConfiguration.dataSource = testDataSource;
        someBackgroundTitleString = @"Open Test App";
        testConnectionManager = [[TestConnectionManager alloc] init];
        streamingLifecycleManager = [[SDLStreamingMediaLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfiguration];
    });
    
    it(@"should initialize properties", ^{
        expect(streamingLifecycleManager.touchManager).toNot(beNil());
        expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isVideoConnected)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isAudioConnected)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isVideoEncrypted)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isAudioEncrypted)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isVideoStreamingPaused)).to(equal(@YES));
        expect(@(CGSizeEqualToSize(streamingLifecycleManager.screenSize, CGSizeZero))).to(equal(@YES));
        expect(@(streamingLifecycleManager.pixelBufferPool == NULL)).to(equal(@YES));
        expect(@(streamingLifecycleManager.requestedEncryptionType)).to(equal(@(SDLStreamingEncryptionFlagNone)));
        expect(streamingLifecycleManager.currentAppState).to(equal(SDLAppStateActive));
        expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStopped));
        expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
        expect(streamingLifecycleManager.videoFormat).to(beNil());
        expect(streamingLifecycleManager.dataSource).to(equal(testDataSource));
        expect(streamingLifecycleManager.supportedFormats).to(haveCount(2));
        expect(streamingLifecycleManager.preferredFormats).to(beNil());
        expect(streamingLifecycleManager.preferredResolutions).to(beNil());
        expect(streamingLifecycleManager.preferredFormatIndex).to(equal(0));
        expect(streamingLifecycleManager.preferredResolutionIndex).to(equal(0));
    });
    
    describe(@"when started", ^{
        __block BOOL readyHandlerSuccess = NO;
        __block NSError *readyHandlerError = nil;
        
        __block id protocolMock = OCMClassMock([SDLAbstractProtocol class]);
        
        beforeEach(^{
            readyHandlerSuccess = NO;
            readyHandlerError = nil;
            
            [streamingLifecycleManager startWithProtocol:protocolMock completionHandler:^(BOOL success, NSError * _Nullable error) {
                readyHandlerSuccess = success;
                readyHandlerError = error;
            }];
        });
        
        it(@"should be ready to stream", ^{
            expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoConnected)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isAudioConnected)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoEncrypted)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isAudioEncrypted)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoStreamingPaused)).to(equal(@YES));
            expect(@(CGSizeEqualToSize(streamingLifecycleManager.screenSize, CGSizeZero))).to(equal(@YES));
            expect(@(streamingLifecycleManager.pixelBufferPool == NULL)).to(equal(@YES));
            expect(streamingLifecycleManager.currentAppState).to(equal(SDLAppStateActive));
            expect(streamingLifecycleManager.currentAudioStreamState).to(match(SDLAudioStreamStateStopped));
            expect(streamingLifecycleManager.currentVideoStreamState).to(match(SDLVideoStreamStateStopped));
        });

        it(@"should send out a video capabilities request", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLGetSystemCapability class]));

            SDLGetSystemCapability *getCapability = (SDLGetSystemCapability *)testConnectionManager.receivedRequests.lastObject;
            expect(getCapability.systemCapabilityType).to(equal(SDLSystemCapabilityTypeVideoStreaming));
        });
        
        describe(@"after receiving a register app interface notification", ^{
            __block SDLRegisterAppInterfaceResponse *someRegisterAppInterfaceResponse = nil;
            __block SDLDisplayCapabilities *someDisplayCapabilities = nil;
            __block SDLScreenParams *someScreenParams = nil;
            __block SDLImageResolution *someImageResolution = nil;
            
            beforeEach(^{
                someImageResolution = [[SDLImageResolution alloc] init];
                someImageResolution.resolutionWidth = @(600);
                someImageResolution.resolutionHeight = @(100);
                
                someScreenParams = [[SDLScreenParams alloc] init];
                someScreenParams.resolution = someImageResolution;
            });
            
            context(@"that does not support graphics", ^{
                beforeEach(^{
                    someDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    someDisplayCapabilities.graphicSupported = @NO;
                    
                    someDisplayCapabilities.screenParams = someScreenParams;
                    
                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    someRegisterAppInterfaceResponse.displayCapabilities = someDisplayCapabilities;
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should not support streaming", ^{
                    expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
                });
            });
            
            context(@"that supports graphics", ^{
                beforeEach(^{
                    someDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    someDisplayCapabilities.graphicSupported = @YES;
                    
                    someDisplayCapabilities.screenParams = someScreenParams;
                    
                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    someRegisterAppInterfaceResponse.displayCapabilities = someDisplayCapabilities;
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should support streaming", ^{
                    expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@YES));
                    expect(@(CGSizeEqualToSize(streamingLifecycleManager.screenSize, CGSizeMake(600, 100)))).to(equal(@YES));
                });
            });
        });

        describe(@"after sending GetSystemCapabilities", ^{
            context(@"and receiving an error response", ^{
                // This happens if the HU doesn't understand GetSystemCapabilities
                beforeEach(^{
                    SDLGenericResponse *genericResponse = [[SDLGenericResponse alloc] init];
                    genericResponse.resultCode = SDLResultInvalidData;

                    [testConnectionManager respondToLastRequestWithResponse:genericResponse];
                });

                it(@"should have correct format and resolution", ^{
                    expect(streamingLifecycleManager.preferredFormats).to(haveCount(1));
                    expect(streamingLifecycleManager.preferredFormats.firstObject.codec).to(equal(SDLVideoStreamingCodecH264));
                    expect(streamingLifecycleManager.preferredFormats.firstObject.protocol).to(equal(SDLVideoStreamingProtocolRAW));

                    expect(streamingLifecycleManager.preferredResolutions).to(haveCount(1));
                    expect(streamingLifecycleManager.preferredResolutions.firstObject.resolutionWidth).to(equal(0));
                    expect(streamingLifecycleManager.preferredResolutions.firstObject.resolutionHeight).to(equal(0));
                });
            });

            context(@"and receiving a response", ^{
                __block SDLImageResolution *resolution = nil;
                __block int32_t maxBitrate = 0;
                __block NSArray<SDLVideoStreamingFormat *> *testFormats = nil;
                __block BOOL testHapticsSupported = NO;

                beforeEach(^{
                    SDLGetSystemCapabilityResponse *response = [[SDLGetSystemCapabilityResponse alloc] init];
                    response.success = @YES;
                    response.systemCapability = [[SDLSystemCapability alloc] init];
                    response.systemCapability.systemCapabilityType = SDLSystemCapabilityTypeVideoStreaming;

                    resolution = [[SDLImageResolution alloc] initWithWidth:42 height:69];
                    maxBitrate = 12345;
                    testFormats = @[[[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH265 protocol:SDLVideoStreamingProtocolRTMP], [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP]];
                    testHapticsSupported = YES;
                    response.systemCapability.videoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:maxBitrate supportedFormats:testFormats hapticDataSupported:testHapticsSupported];
                    [testConnectionManager respondToLastRequestWithResponse:response];
                });

                fit(@"should have correct data from the data source", ^{
                    // Correct formats should be retrieved from the data source
                    expect(streamingLifecycleManager.preferredResolutions).to(haveCount(1));
                    expect(streamingLifecycleManager.preferredResolutions.firstObject.resolutionWidth).to(equal(resolution.resolutionWidth));
                    expect(streamingLifecycleManager.preferredResolutions.firstObject.resolutionHeight).to(equal(resolution.resolutionHeight));

                    expect(streamingLifecycleManager.preferredFormats).to(haveCount(streamingLifecycleManager.supportedFormats.count + 1));
                    expect(streamingLifecycleManager.preferredFormats.firstObject.codec).to(equal(testDataSource.extraFormat.codec));
                    expect(streamingLifecycleManager.preferredFormats.firstObject.protocol).to(equal(testDataSource.extraFormat.protocol));
                });
            });
        });
        
        describe(@"if the app state is active", ^{
            __block id streamStub = nil;
            
            beforeEach(^{
                streamStub = OCMPartialMock(streamingLifecycleManager);
                
                OCMStub([streamStub isStreamingSupported]).andReturn(YES);

                [streamingLifecycleManager.appStateMachine setToState:SDLAppStateActive fromOldState:nil callEnterTransition:NO];
            });
            
            describe(@"and both streams are open", ^{
                beforeEach(^{
                    [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamStateReady fromOldState:nil callEnterTransition:NO];
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamStateReady fromOldState:nil callEnterTransition:NO];
                });
                
                describe(@"and the hmi state is limited", ^{
                    beforeEach(^{
                        streamingLifecycleManager.hmiLevel = SDLHMILevelLimited;
                    });
                    
                    describe(@"and the hmi state changes to", ^{
                        context(@"none", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelNone);
                            });
                            
                            it(@"should close only the video stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateShuttingDown));
                            });
                        });
                        
                        context(@"background", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelBackground);
                            });
                            
                            it(@"should close only the video stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateShuttingDown));
                            });
                        });
                        
                        context(@"limited", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelLimited);
                            });
                            
                            it(@"should not close either stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateReady));
                            });
                        });
                        
                        context(@"full", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelFull);
                            });
                            
                            it(@"should not close either stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateReady));
                            });
                        });
                    });
                    
                    describe(@"and the app state changes to", ^{
                        context(@"inactive", ^{
                            beforeEach(^{
                                [streamingLifecycleManager.appStateMachine setToState:SDLAppStateInactive fromOldState:nil callEnterTransition:YES];
                            });
                            
                            it(@"should flag to restart the video stream", ^{
                                expect(@(streamingLifecycleManager.shouldRestartVideoStream)).to(equal(@YES));
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                                expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateReady));
                            });
                        });
                    });
                });
                
                describe(@"and the hmi state is full", ^{
                    beforeEach(^{
                        streamingLifecycleManager.hmiLevel = SDLHMILevelFull;
                    });
                    
                    context(@"and hmi state changes to none", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelNone);
                        });
                        
                        it(@"should close only the video stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateShuttingDown));
                        });
                    });
                    
                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground);
                        });
                        
                        it(@"should close only the video stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateShuttingDown));
                        });
                    });
                    
                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited);
                        });
                        
                        it(@"should not close either stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateReady));
                        });
                    });

                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull);
                        });
                        
                        it(@"should not close either stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateReady));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateReady));
                        });
                    });
                });
            });
           
            describe(@"and both streams are closed", ^{
                beforeEach(^{
                    [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamStateStopped fromOldState:nil callEnterTransition:NO];
                    [streamingLifecycleManager.videoStreamStateMachine setToState:SDLVideoStreamStateStopped fromOldState:nil callEnterTransition:NO];
                });
                
                describe(@"and the hmi state is none", ^{
                    beforeEach(^{
                        streamingLifecycleManager.hmiLevel = SDLHMILevelNone;
                    });
                    
                    context(@"and hmi state changes to none", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelNone);
                        });
                        
                        it(@"should only start the audio stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
                        });
                    });
                    
                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground);
                        });
                        
                        it(@"should only start the audio stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
                        });
                    });
                    
                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited);
                        });
                        
                        it(@"should start both streams", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStarting));
                        });
                    });
                    
                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull);
                        });
                        
                        it(@"should start both streams", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStarting));
                        });
                    });
                });
            });
        });
    });
});

QuickSpecEnd
