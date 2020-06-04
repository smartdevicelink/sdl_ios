//
//  SDLStreamingMediaManagerSpec.m
//  SmartDeviceLink-iOS
//
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLConfiguration.h"
#import "SDLProtocol.h"
#import "SDLSecondaryTransportManager.h"
#import "SDLStreamingAudioLifecycleManager.h"
#import "SDLStreamingMediaManager.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLSystemCapabilityManager.h"
#import "TestConnectionManager.h"

@interface SDLStreamingMediaManager()

@property (strong, nonatomic) SDLStreamingAudioLifecycleManager *audioLifecycleManager;
@property (strong, nonatomic) SDLStreamingVideoLifecycleManager *videoLifecycleManager;
@property (assign, nonatomic) BOOL audioStarted;
@property (assign, nonatomic) BOOL videoStarted;
@property (strong, nonatomic, nullable) SDLProtocol *audioProtocol;
@property (strong, nonatomic, nullable) SDLProtocol *videoProtocol;

@property (strong, nonatomic, nullable) SDLSecondaryTransportManager *secondaryTransportManager;

- (void)startSecondaryTransportWithProtocol:(SDLProtocol *)protocol;
- (void)didUpdateFromOldVideoProtocol:(nullable SDLProtocol *)oldVideoProtocol toNewVideoProtocol:(nullable SDLProtocol *)newVideoProtocol fromOldAudioProtocol:(nullable SDLProtocol *)oldAudioProtocol toNewAudioProtocol:(nullable SDLProtocol *)newAudioProtocol;

@end

QuickSpecBegin(SDLStreamingMediaManagerSpec)

describe(@"the streaming media manager", ^{
    __block SDLStreamingMediaManager *testStreamingMediaManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLConfiguration *testConfiguration = nil;
    __block SDLSystemCapabilityManager *mockSystemCapabilityManager = nil;

    // Need to use `id` data type in order to use `OCMVerifyAllWithDelay`
    __block id mockSecondaryTransportManager = nil;
    __block id mockVideoLifecycleManager = nil;
    __block id mockAudioLifecycleManager = nil;

    beforeEach(^{
        mockSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        testConnectionManager = [[TestConnectionManager alloc] init];
        testStreamingMediaManager = [[SDLStreamingMediaManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfiguration systemCapabilityManager:mockSystemCapabilityManager];

        mockVideoLifecycleManager = OCMClassMock([SDLStreamingVideoLifecycleManager class]);
        testStreamingMediaManager.videoLifecycleManager = mockVideoLifecycleManager;

        mockAudioLifecycleManager = OCMClassMock([SDLStreamingAudioLifecycleManager class]);
        testStreamingMediaManager.audioLifecycleManager = mockAudioLifecycleManager;

        mockSecondaryTransportManager = OCMStrictClassMock([SDLSecondaryTransportManager class]);
        testStreamingMediaManager.secondaryTransportManager = mockSecondaryTransportManager;
    });

    context(@"when stop is called", ^{
        it(@"should stop both the audio and video stream managers", ^{
            [testStreamingMediaManager stop];
            OCMVerify([mockAudioLifecycleManager stop]);
            OCMVerify([mockVideoLifecycleManager stop]);
            expect(testStreamingMediaManager.audioStarted).to(beFalse());
            expect(testStreamingMediaManager.videoStarted).to(beFalse());
        });
    });

    describe(@"when stop video is called", ^{
        beforeEach(^{
            testStreamingMediaManager.audioStarted = YES;
            testStreamingMediaManager.videoStarted = YES;
        });

        it(@"should only stop the video stream manager", ^{
            [testStreamingMediaManager stopVideo];
            OCMVerify([mockVideoLifecycleManager stop]);
            expect(testStreamingMediaManager.videoStarted).to(beFalse());

            OCMReject([mockAudioLifecycleManager stop]);
            expect(testStreamingMediaManager.audioStarted).to(beTrue());
        });
    });

    describe(@"when stop audio is called", ^{
        beforeEach(^{
            testStreamingMediaManager.audioStarted = YES;
            testStreamingMediaManager.videoStarted = YES;

            [testStreamingMediaManager stopAudio];
        });

        it(@"should only stop the audio stream manager", ^{
            OCMVerify([mockAudioLifecycleManager stop]);
            expect(testStreamingMediaManager.audioStarted).to(beFalse());

            OCMReject([mockVideoLifecycleManager stop]);
            expect(testStreamingMediaManager.videoStarted).to(beTrue());
        });
    });

    describe(@"when sending audio data", ^{
        __block NSData *testAudioData = nil;

        beforeEach(^{
            testAudioData = [[NSData alloc] initWithBase64EncodedString:@"test data" options:kNilOptions];
            [testStreamingMediaManager sendAudioData:testAudioData];
        });

        it(@"should pass the audio data to the audio streaming manager", ^{
            OCMVerify([mockAudioLifecycleManager sendAudioData:testAudioData]);
        });
    });

    describe(@"when sending video data", ^{
        __block CVPixelBufferRef testPixelBuffer = nil;

        beforeEach(^{
             CVPixelBufferCreate(kCFAllocatorDefault, 100, 50, kCVPixelFormatType_14Bayer_GRBG, nil, &testPixelBuffer);
        });

        context(@"without a timestamp", ^{
            beforeEach(^{
                [testStreamingMediaManager sendVideoData:testPixelBuffer];
            });

            it(@"should pass the video data to the video streaming manager", ^{
                OCMVerify([mockVideoLifecycleManager sendVideoData:testPixelBuffer]);
            });
        });

        context(@"with a timestamp", ^{
            __block CMTime testTimestamp = CMTimeMake(1, NSEC_PER_SEC);

            beforeEach(^{
                [testStreamingMediaManager sendVideoData:testPixelBuffer presentationTimestamp:testTimestamp];
            });

            it(@"should pass the video data to the video streaming manager", ^{
                OCMVerify([mockVideoLifecycleManager sendVideoData:testPixelBuffer presentationTimestamp:testTimestamp]);
            });
       });
    });

    describe(@"getters", ^{
        it(@"should return the audio lifecycle manager's properties correctly", ^{
            [testStreamingMediaManager audioManager];
            OCMVerify([mockAudioLifecycleManager audioTranscodingManager]);

            [testStreamingMediaManager isAudioConnected];
            OCMVerify([mockAudioLifecycleManager isAudioConnected]);

            [testStreamingMediaManager isAudioEncrypted];
            OCMVerify([mockAudioLifecycleManager isAudioEncrypted]);
        });

        it(@"should return the video lifecycle manager's properties correctly", ^{
            [testStreamingMediaManager touchManager];
            OCMVerify([mockVideoLifecycleManager touchManager]);

            [testStreamingMediaManager rootViewController];
            OCMVerify([mockVideoLifecycleManager rootViewController]);

            [testStreamingMediaManager focusableItemManager];
            OCMVerify([mockVideoLifecycleManager focusableItemManager]);

            [testStreamingMediaManager isVideoConnected];
            OCMVerify([mockVideoLifecycleManager isVideoConnected]);

            [testStreamingMediaManager isVideoEncrypted];
            OCMVerify([mockVideoLifecycleManager isVideoEncrypted]);

            [testStreamingMediaManager isVideoStreamingPaused];
            OCMVerify([mockVideoLifecycleManager isVideoStreamingPaused]);

            [testStreamingMediaManager screenSize];
            SDLStreamingVideoLifecycleManager *streamingVideoLifecycleManager = (SDLStreamingVideoLifecycleManager *)mockVideoLifecycleManager;
            OCMVerify([streamingVideoLifecycleManager.videoScaleManager displayViewportResolution]);

            [testStreamingMediaManager videoFormat];
            OCMVerify([mockVideoLifecycleManager videoFormat]);

            [testStreamingMediaManager supportedFormats];
            OCMVerify([mockVideoLifecycleManager supportedFormats]);

            [testStreamingMediaManager pixelBufferPool];
            OCMVerify([mockVideoLifecycleManager pixelBufferPool]);

            [testStreamingMediaManager requestedEncryptionType];
            OCMVerify([mockVideoLifecycleManager requestedEncryptionType]);

            [testStreamingMediaManager showVideoBackgroundDisplay];
            OCMVerify([mockVideoLifecycleManager showVideoBackgroundDisplay]);

            [testStreamingMediaManager isStreamingSupported];
            OCMVerify([mockVideoLifecycleManager isStreamingSupported]);
        });
    });

    describe(@"setters", ^{
        it(@"should set the encryption flag on both the audio and video managers", ^{
            SDLStreamingEncryptionFlag testEncryptionFlag = SDLStreamingEncryptionFlagNone;
            [testStreamingMediaManager setRequestedEncryptionType:testEncryptionFlag];

            OCMVerify([mockAudioLifecycleManager setRequestedEncryptionType:testEncryptionFlag]);
            OCMVerify([mockVideoLifecycleManager setRequestedEncryptionType:testEncryptionFlag]);
        });

        it(@"should set the video manager properties correctly", ^{
            UIViewController *testViewController = [[UIViewController alloc] init];
            [testStreamingMediaManager setRootViewController:testViewController];
            OCMVerify([mockVideoLifecycleManager setRootViewController:testViewController]);

            [testStreamingMediaManager setShowVideoBackgroundDisplay:NO];
            OCMVerify([mockVideoLifecycleManager setShowVideoBackgroundDisplay:NO]);
        });
    });

    describe(@"when using the secondary transport", ^{
        __block SDLProtocol *mockProtocol = nil;

        beforeEach(^{
            mockProtocol = OCMClassMock([SDLProtocol class]);
        });

        describe(@"starting a service on a transport when none is running", ^{
            beforeEach(^{
                [testStreamingMediaManager startSecondaryTransportWithProtocol:mockProtocol];
            });

            it(@"should start both the audio and video stream managers with the protocol", ^{
                OCMExpect([mockAudioLifecycleManager startWithProtocol:mockProtocol]);
                OCMExpect([mockVideoLifecycleManager startWithProtocol:mockProtocol]);

                OCMReject([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg any]]);

                OCMReject([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);

                OCMVerifyAllWithDelay(mockVideoLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockAudioLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockSecondaryTransportManager, 1.0);

                expect(testStreamingMediaManager.audioStarted).toEventually(beTrue());
                expect(testStreamingMediaManager.videoStarted).toEventually(beTrue());
            });
        });

        describe(@"stopping a running service on a transport", ^{
            beforeEach(^{
                OCMStub([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg invokeBlock]]);

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:[OCMArg any] toNewVideoProtocol:nil fromOldAudioProtocol:[OCMArg any] toNewAudioProtocol:nil];
            });

            it(@"should stop both the audio and video stream managers", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg any]]);

                OCMReject([mockAudioLifecycleManager startWithProtocol:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager startWithProtocol:[OCMArg any]]);

                OCMVerifyAllWithDelay(mockAudioLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockVideoLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockSecondaryTransportManager, 1.0);

                expect(testStreamingMediaManager.audioStarted).toEventually(beFalse());
                expect(testStreamingMediaManager.videoStarted).toEventually(beFalse());
                expect(testStreamingMediaManager.audioProtocol).toEventually(beNil());
                expect(testStreamingMediaManager.videoProtocol).toEventually(beNil());
            });
        });

        describe(@"switching both the video and audio services to a different transport", ^{
            __block SDLProtocol *mockOldVideoProtocol = nil;
            __block SDLProtocol *mockNewVideoProtocol = nil;
            __block SDLProtocol *mockOldAudioProtocol = nil;
            __block SDLProtocol *mockNewAudioProtocol = nil;

            beforeEach(^{
                mockOldVideoProtocol = OCMClassMock([SDLProtocol class]);
                mockNewVideoProtocol = OCMClassMock([SDLProtocol class]);
                mockOldAudioProtocol = OCMClassMock([SDLProtocol class]);
                mockNewAudioProtocol = OCMClassMock([SDLProtocol class]);

                OCMStub([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg invokeBlock]]);

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:mockOldVideoProtocol toNewVideoProtocol:mockNewVideoProtocol fromOldAudioProtocol:mockOldAudioProtocol toNewAudioProtocol:mockNewAudioProtocol];
            });

            it(@"should stop both the audio and video stream managers and call the delegate then start a new session", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg any]]);

                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockNewAudioProtocol]);
                OCMVerify([mockVideoLifecycleManager startWithProtocol:mockNewVideoProtocol]);

                OCMVerifyAllWithDelay(mockAudioLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockVideoLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockSecondaryTransportManager, 1.0);

                expect(testStreamingMediaManager.audioStarted).toEventually(beTrue());
                expect(testStreamingMediaManager.videoStarted).toEventually(beTrue());
                expect(testStreamingMediaManager.audioProtocol).toEventually(equal(mockNewAudioProtocol));
                expect(testStreamingMediaManager.videoProtocol).toEventually(equal(mockNewVideoProtocol));
            });
        });

        fdescribe(@"switching only the video service to a different transport", ^{
            __block SDLProtocol *mockOldProtocol = nil;
            __block SDLProtocol *mockNewProtocol = nil;

            beforeEach(^{
                mockOldProtocol = OCMClassMock([SDLProtocol class]);
                mockNewProtocol = OCMClassMock([SDLProtocol class]);

                OCMStub([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg invokeBlock]]);

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:mockOldProtocol toNewVideoProtocol:mockNewProtocol fromOldAudioProtocol:nil toNewAudioProtocol:nil];
            });

            it(@"should stop the video stream manager but not the audio stream manager", ^{
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg any]]);

                OCMExpect([mockVideoLifecycleManager startWithProtocol:mockNewProtocol]);
                OCMReject([mockAudioLifecycleManager startWithProtocol:mockNewProtocol]);

                OCMVerifyAllWithDelay(mockAudioLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockVideoLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockSecondaryTransportManager, 1.0);

                expect(testStreamingMediaManager.videoStarted).toEventually(beTrue());
                expect(testStreamingMediaManager.audioStarted).toEventually(beFalse());
                expect(testStreamingMediaManager.audioProtocol).toEventually(beNil());
                expect(testStreamingMediaManager.videoProtocol).toEventually(equal(mockNewProtocol));
            });
        });

        describe(@"switching only the audio service to a different transport", ^{
            __block SDLProtocol *mockOldProtocol = nil;
            __block SDLProtocol *mockNewProtocol = nil;

            beforeEach(^{
                mockOldProtocol = OCMClassMock([SDLProtocol class]);
                mockNewProtocol = OCMClassMock([SDLProtocol class]);

                OCMStub([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg invokeBlock]]);

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:nil fromOldAudioProtocol:mockOldProtocol toNewAudioProtocol:mockNewProtocol];
            });

            it(@"should stop the audio stream manager but not the video stream manager", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransportWithCompletionHandler:[OCMArg any]]);

                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockNewProtocol]);
                OCMReject([mockVideoLifecycleManager startWithProtocol:[OCMArg any]]);

                OCMVerifyAllWithDelay(mockAudioLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockVideoLifecycleManager, 1.0);
                OCMVerifyAllWithDelay(mockSecondaryTransportManager, 1.0);

                expect(testStreamingMediaManager.videoStarted).toEventually(beFalse());
                expect(testStreamingMediaManager.audioStarted).toEventually(beTrue());
                expect(testStreamingMediaManager.audioProtocol).toEventually(equal(mockNewProtocol));
                expect(testStreamingMediaManager.videoProtocol).toEventually(beNil());
            });
        });
    });
});

QuickSpecEnd
