#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLControlFramePayloadAudioStartServiceAck.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGlobals.h"
#import "SDLHMICapabilities.h"
#import "SDLImageResolution.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingAudioLifecycleManager.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLVersion.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLStreamingAudioLifecycleManagerSpec)

describe(@"the streaming audio manager", ^{
    __block SDLStreamingAudioLifecycleManager *streamingLifecycleManager = nil;
    __block SDLStreamingMediaConfiguration *testConfiguration = [SDLStreamingMediaConfiguration insecureConfiguration];
    __block SDLEncryptionConfiguration *encryptionConfiguration = [SDLEncryptionConfiguration defaultConfiguration];
    __block TestConnectionManager *testConnectionManager = nil;

    __block void (^sendNotificationForHMILevel)(SDLHMILevel hmiLevel) = ^(SDLHMILevel hmiLevel) {
        SDLOnHMIStatus *hmiStatus = [[SDLOnHMIStatus alloc] init];
        hmiStatus.hmiLevel = hmiLevel;
        SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:hmiStatus];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

        [NSThread sleepForTimeInterval:0.3];
    };

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        streamingLifecycleManager = [[SDLStreamingAudioLifecycleManager alloc] initWithConnectionManager:testConnectionManager streamingConfiguration:testConfiguration encryptionConfiguration:encryptionConfiguration];
    });

    it(@"should initialize properties", ^{
        expect(streamingLifecycleManager.audioManager).toNot(beNil());
        expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isAudioConnected)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isAudioEncrypted)).to(equal(@NO));
        expect(@(streamingLifecycleManager.requestedEncryptionType)).to(equal(@(SDLStreamingEncryptionFlagNone)));
        expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStopped));
    });

    describe(@"when started", ^{
        __block BOOL readyHandlerSuccess = NO;
        __block NSError *readyHandlerError = nil;
        __block SDLProtocol *protocolMock = OCMClassMock([SDLProtocol class]);

        beforeEach(^{
            readyHandlerSuccess = NO;
            readyHandlerError = nil;

            [streamingLifecycleManager startWithProtocol:protocolMock];
        });

        it(@"should be ready to stream", ^{
            expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isAudioConnected)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isAudioEncrypted)).to(equal(@NO));
            expect(streamingLifecycleManager.currentAudioStreamState).to(match(SDLAudioStreamManagerStateStopped));
        });

        describe(@"after receiving a register app interface response", ^{
            __block SDLRegisterAppInterfaceResponse *someRegisterAppInterfaceResponse = nil;
            __block SDLHMICapabilities *someHMICapabilities = nil;

            context(@"from a module supporting SDL-4.5+", ^{
                beforeEach(^{
                    SDLVersion *version = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                    id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                    OCMStub([globalMock rpcVersion]).andReturn(version);
                });

                describe(@"that does not support video streaming", ^{
                    beforeEach(^{
                        someHMICapabilities = [[SDLHMICapabilities alloc] init];
                        someHMICapabilities.videoStreaming = @NO;

                        someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                        someRegisterAppInterfaceResponse.hmiCapabilities = someHMICapabilities;

                        SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];

                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        [NSThread sleepForTimeInterval:0.1];
                    });

                    it(@"should set isStreamingSupported to false", ^{
                        expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@NO));
                    });
                });

                describe(@"that supports video streaming", ^{
                    beforeEach(^{
                        someHMICapabilities = [[SDLHMICapabilities alloc] init];
                        someHMICapabilities.videoStreaming = @YES;

                        someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                        someRegisterAppInterfaceResponse.hmiCapabilities = someHMICapabilities;

                        SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];

                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        [NSThread sleepForTimeInterval:0.1];
                    });

                    it(@"should set isStreamingSupported to true", ^{
                        expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@YES));
                    });
                });
            });

            context(@"from a module supporting pre SDL-4.5", ^{
                beforeEach(^{
                    SDLVersion *version = [SDLVersion versionWithMajor:4 minor:0 patch:0];
                    id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                    OCMStub([globalMock rpcVersion]).andReturn(version);

                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [NSThread sleepForTimeInterval:0.1];
                });

                it(@"should set isStreamingSupported to true even though the hmiCapabilities in the RAI response is nil", ^{
                    expect(@(streamingLifecycleManager.isStreamingSupported)).to(equal(@YES));
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

            describe(@"and the streams are open", ^{
                beforeEach(^{
                    [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamManagerStateReady fromOldState:nil callEnterTransition:NO];
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

                            it(@"should close the streams", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateShuttingDown));
                            });
                        });

                        context(@"background", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelBackground);
                            });

                            it(@"should close the stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateShuttingDown));
                            });
                        });

                        context(@"limited", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelLimited);
                            });

                            it(@"should not close the stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateReady));
                            });
                        });

                        context(@"full", ^{
                            beforeEach(^{
                                sendNotificationForHMILevel(SDLHMILevelFull);
                            });

                            it(@"should not close the stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateReady));
                            });
                        });
                    });

                    describe(@"and the app state changes to", ^{
                        context(@"inactive", ^{
                            beforeEach(^{
                                [streamingLifecycleManager.appStateMachine setToState:SDLAppStateInactive fromOldState:nil callEnterTransition:YES];
                            });

                            it(@"should not close the stream", ^{
                                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateReady));
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

                        it(@"should close the streams", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground);
                        });

                        it(@"should close the stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateShuttingDown));
                        });
                    });

                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited);
                        });

                        it(@"should not close the stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateReady));
                        });
                    });

                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull);
                        });

                        it(@"should not close the stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateReady));
                        });
                    });
                });
            });

            describe(@"and the streams are closed", ^{
                beforeEach(^{
                    [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamManagerStateStopped fromOldState:nil callEnterTransition:NO];
                });

                describe(@"and the hmi state is none", ^{
                    beforeEach(^{
                        streamingLifecycleManager.hmiLevel = SDLHMILevelNone;
                    });

                    context(@"and hmi state changes to none", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelNone);
                        });

                        it(@"should not start the stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStopped));
                        });
                    });

                    context(@"and hmi state changes to background", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelBackground);
                        });

                        it(@"should not start the stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStopped));
                        });
                    });

                    context(@"and hmi state changes to limited", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelLimited);
                        });

                        it(@"should start the streams", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStarting));
                        });
                    });

                    context(@"and hmi state changes to full", ^{
                        beforeEach(^{
                            sendNotificationForHMILevel(SDLHMILevelFull);
                        });

                        it(@"should start the streams", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStarting));
                        });
                    });
                });
            });
        });

        describe(@"after receiving an Audio Start ACK", ^{
            __block SDLProtocolHeader *testAudioHeader = nil;
            __block SDLProtocolMessage *testAudioMessage = nil;
            __block SDLControlFramePayloadAudioStartServiceAck *testAudioStartServicePayload = nil;
            __block int64_t testMTU = 786579;

            beforeEach(^{
                [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                testAudioHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testAudioHeader.frameType = SDLFrameTypeSingle;
                testAudioHeader.frameData = SDLFrameInfoStartServiceACK;
                testAudioHeader.encrypted = YES;
                testAudioHeader.serviceType = SDLServiceTypeAudio;

                testAudioStartServicePayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithMTU:testMTU];
                testAudioMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testAudioHeader andPayload:testAudioStartServicePayload.data];
                [streamingLifecycleManager handleProtocolStartServiceACKMessage:testAudioMessage];
            });

            it(@"should have set all the right properties", ^{
                expect([[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeAudio]).to(equal(testMTU));
                expect(streamingLifecycleManager.audioEncrypted).to(equal(YES));
                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateReady));
            });
        });

        describe(@"after receiving an Audio Start NAK", ^{
            __block SDLProtocolHeader *testAudioHeader = nil;
            __block SDLProtocolMessage *testAudioMessage = nil;

            beforeEach(^{
                [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                testAudioHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testAudioHeader.frameType = SDLFrameTypeSingle;
                testAudioHeader.frameData = SDLFrameInfoStartServiceNACK;
                testAudioHeader.encrypted = NO;
                testAudioHeader.serviceType = SDLServiceTypeAudio;

                testAudioMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testAudioHeader andPayload:nil];
                [streamingLifecycleManager handleProtocolEndServiceACKMessage:testAudioMessage];
            });

            it(@"should have set all the right properties", ^{
                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStopped));
            });
        });

        describe(@"after receiving a audio end ACK", ^{
            __block SDLProtocolHeader *testAudioHeader = nil;
            __block SDLProtocolMessage *testAudioMessage = nil;

            beforeEach(^{
                [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                testAudioHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testAudioHeader.frameType = SDLFrameTypeSingle;
                testAudioHeader.frameData = SDLFrameInfoEndServiceACK;
                testAudioHeader.encrypted = NO;
                testAudioHeader.serviceType = SDLServiceTypeAudio;

                testAudioMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testAudioHeader andPayload:nil];
                [streamingLifecycleManager handleProtocolEndServiceACKMessage:testAudioMessage];
            });

            it(@"should have set all the right properties", ^{
                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStopped));
            });
        });

        describe(@"after receiving a audio end NAK", ^{
            __block SDLProtocolHeader *testAudioHeader = nil;
            __block SDLProtocolMessage *testAudioMessage = nil;

            beforeEach(^{
                [streamingLifecycleManager.audioStreamStateMachine setToState:SDLAudioStreamManagerStateStarting fromOldState:nil callEnterTransition:NO];

                testAudioHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testAudioHeader.frameType = SDLFrameTypeSingle;
                testAudioHeader.frameData = SDLFrameInfoEndServiceNACK;
                testAudioHeader.encrypted = NO;
                testAudioHeader.serviceType = SDLServiceTypeAudio;

                testAudioMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testAudioHeader andPayload:nil];
                [streamingLifecycleManager handleProtocolEndServiceNAKMessage:testAudioMessage];
            });

            it(@"should have set all the right properties", ^{
                expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamManagerStateStopped));
            });
        });
    });
});

QuickSpecEnd
