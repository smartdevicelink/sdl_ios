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

- (void)didUpdateFromOldVideoProtocol:(nullable SDLProtocol *)oldVideoProtocol toNewVideoProtocol:(nullable SDLProtocol *)newVideoProtocol fromOldAudioProtocol:(nullable SDLProtocol *)oldAudioProtocol toNewAudioProtocol:(nullable SDLProtocol *)newAudioProtocol;

@end

QuickSpecBegin(SDLStreamingMediaManagerSpec)

describe(@"the streaming media manager", ^{
    __block SDLStreamingMediaManager *testStreamingMediaManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLConfiguration *testConfiguration = nil;
    __block SDLSecondaryTransportManager *mockSecondaryTransportManager = nil;
    __block SDLStreamingVideoLifecycleManager *mockVideoLifecycleManager = nil;
    __block SDLStreamingAudioLifecycleManager *mockAudioLifecycleManager = nil;
    __block SDLSystemCapabilityManager *mockSystemCapabilityManager = nil;

    beforeEach(^{
        mockSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        testConnectionManager = [[TestConnectionManager alloc] init];
        testStreamingMediaManager = [[SDLStreamingMediaManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfiguration systemCapabilityManager:mockSystemCapabilityManager];

        mockVideoLifecycleManager = OCMClassMock([SDLStreamingVideoLifecycleManager class]);
        testStreamingMediaManager.videoLifecycleManager = mockVideoLifecycleManager;

        mockAudioLifecycleManager = OCMClassMock([SDLStreamingAudioLifecycleManager class]);
        testStreamingMediaManager.audioLifecycleManager = mockAudioLifecycleManager;

        mockSecondaryTransportManager = OCMClassMock([SDLSecondaryTransportManager class]);
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
            OCMVerify([mockVideoLifecycleManager.videoScaleManager displayViewportResolution]);

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

                // Make sure the dispatch_group tasks finish before performing checks
                [NSThread sleepForTimeInterval:0.5];
            });

            it(@"should start both the audio and video stream managers with the protocol", ^{
                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockProtocol]);
                OCMVerify([mockVideoLifecycleManager startWithProtocol:mockProtocol]);

                expect(testStreamingMediaManager.audioStarted).to(beTrue());
                expect(testStreamingMediaManager.videoStarted).to(beTrue());

                OCMReject([mockSecondaryTransportManager disconnectSecondaryTransport]);

                OCMReject([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
            });
        });

        describe(@"stopping a running service on a transport", ^{
            beforeEach(^{
                OCMStub([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void (^handler)(void);
                    [invocation getArgument:&handler atIndex:2];
                    handler();
                });

                OCMStub([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void (^handler)(void);
                    [invocation getArgument:&handler atIndex:2];
                    handler();
                });

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:[OCMArg any] toNewVideoProtocol:nil fromOldAudioProtocol:[OCMArg any] toNewAudioProtocol:nil];

                // Make sure the dispatch_group tasks finish before performing checks
                [NSThread sleepForTimeInterval:0.5];
            });

            it(@"should stop both the audio and video stream managers", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                expect(testStreamingMediaManager.audioStarted).to(beFalse());
                expect(testStreamingMediaManager.videoStarted).to(beFalse());

                OCMReject([mockAudioLifecycleManager startWithProtocol:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager startWithProtocol:[OCMArg any]]);

                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransport]);

                expect(testStreamingMediaManager.audioProtocol).to(beNil());
                expect(testStreamingMediaManager.videoProtocol).to(beNil());
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

                OCMStub([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void (^handler)(void);
                    [invocation getArgument:&handler atIndex:2];
                    handler();
                });

                OCMStub([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void (^handler)(void);
                    [invocation getArgument:&handler atIndex:2];
                    handler();
                });

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:mockOldVideoProtocol toNewVideoProtocol:mockNewVideoProtocol fromOldAudioProtocol:mockOldAudioProtocol toNewAudioProtocol:mockNewAudioProtocol];

                // Make sure the dispatch_group tasks finish before performing checks
                [NSThread sleepForTimeInterval:0.5];
            });

            it(@"should stop both the audio and video stream managers and call the delegate then start a new session", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);

                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransport]);

                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockNewAudioProtocol]);
                OCMVerify([mockVideoLifecycleManager startWithProtocol:mockNewVideoProtocol]);

                expect(testStreamingMediaManager.audioStarted).to(beTrue());
                expect(testStreamingMediaManager.videoStarted).to(beTrue());

                expect(testStreamingMediaManager.audioProtocol).to(equal(mockNewAudioProtocol));
                expect(testStreamingMediaManager.videoProtocol).to(equal(mockNewVideoProtocol));
            });
        });

        describe(@"switching only the video service to a different transport", ^{
            __block SDLProtocol *mockOldProtocol = nil;
            __block SDLProtocol *mockNewProtocol = nil;

            beforeEach(^{
                mockOldProtocol = OCMClassMock([SDLProtocol class]);
                mockNewProtocol = OCMClassMock([SDLProtocol class]);

                OCMStub([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void (^handler)(void);
                    [invocation getArgument:&handler atIndex:2];
                    handler();
                });

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:mockOldProtocol toNewVideoProtocol:mockNewProtocol fromOldAudioProtocol:nil toNewAudioProtocol:nil];

                // Make sure the dispatch_group tasks finish before performing checks
                [NSThread sleepForTimeInterval:0.5];
            });

            it(@"should stop the video stream manager but not the audio stream manager", ^{
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);

                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransport]);

                OCMVerify([mockVideoLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.videoStarted).to(beTrue());

                OCMReject([mockAudioLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.audioStarted).to(beFalse());

                expect(testStreamingMediaManager.audioProtocol).to(beNil());
                expect(testStreamingMediaManager.videoProtocol).to(equal(mockNewProtocol));
            });
        });

        describe(@"switching only the audio service to a different transport", ^{
            __block SDLProtocol *mockOldProtocol = nil;
            __block SDLProtocol *mockNewProtocol = nil;

            beforeEach(^{
                mockOldProtocol = OCMClassMock([SDLProtocol class]);
                mockNewProtocol = OCMClassMock([SDLProtocol class]);

                OCMStub([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void (^handler)(void);
                    [invocation getArgument:&handler atIndex:2];
                    handler();
                });

                [testStreamingMediaManager didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:nil fromOldAudioProtocol:mockOldProtocol toNewAudioProtocol:mockNewProtocol];

                // Make sure the dispatch_group tasks finish before performing checks
                [NSThread sleepForTimeInterval:0.5];
            });

            it(@"should stop the audio stream manager but not the video stream manager", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);

                OCMVerify([mockSecondaryTransportManager disconnectSecondaryTransport]);

                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.audioStarted).to(beTrue());

                OCMReject([mockVideoLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.videoStarted).to(beFalse());

                expect(testStreamingMediaManager.audioProtocol).to(equal(mockNewProtocol));
                expect(testStreamingMediaManager.videoProtocol).to(beNil());
            });
        });
    });
});

QuickSpecEnd
