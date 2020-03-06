//
//  SDLStreamingMediaManagerSpec.m
//  SmartDeviceLink-iOS
//
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLConfiguration.h"
#import "SDLProtocol.h"
#import "SDLStreamingAudioLifecycleManager.h"
#import "SDLStreamingMediaManager.h"
#import "SDLStreamingProtocolDelegate.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "TestConnectionManager.h"

@interface SDLStreamingMediaManager()

@property (strong, nonatomic) SDLStreamingAudioLifecycleManager *audioLifecycleManager;
@property (strong, nonatomic) SDLStreamingVideoLifecycleManager *videoLifecycleManager;
@property (assign, nonatomic) BOOL audioStarted;
@property (assign, nonatomic) BOOL videoStarted;

- (void)streamingServiceProtocolDidUpdateFromOldVideoProtocol:(nullable SDLProtocol *)oldVideoProtocol toNewVideoProtocol:(nullable SDLProtocol *)newVideoProtocol fromOldAudioProtocol:(nullable SDLProtocol *)oldAudioProtocol toNewAudioProtocol:(nullable SDLProtocol *)newAudioProtocol;

@end

QuickSpecBegin(SDLStreamingMediaManagerSpec)

describe(@"the streaming media manager", ^{
    __block SDLStreamingMediaManager *testStreamingMediaManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLConfiguration *testConfiguration = nil;
    __block id mockVideoLifecycleManager = nil;
    __block id mockAudioLifecycleManager = nil;
    __block id<SDLSecondaryTransportDelegate> mockSecondaryTransportDelegate = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testStreamingMediaManager = [[SDLStreamingMediaManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfiguration];
        mockVideoLifecycleManager = OCMClassMock([SDLStreamingVideoLifecycleManager class]);
        mockAudioLifecycleManager = OCMClassMock([SDLStreamingAudioLifecycleManager class]);
        mockSecondaryTransportDelegate = OCMProtocolMock(@protocol(SDLSecondaryTransportDelegate));
        testStreamingMediaManager.audioLifecycleManager = mockAudioLifecycleManager;
        testStreamingMediaManager.videoLifecycleManager = mockVideoLifecycleManager;
        testStreamingMediaManager.secondaryTransportDelegate = mockSecondaryTransportDelegate;
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

    context(@"when stop video is called", ^{
        beforeEach(^{
            testStreamingMediaManager.audioStarted = YES;
            testStreamingMediaManager.videoStarted = YES;
        });

        it(@"should stop the video stream manager", ^{
            [testStreamingMediaManager stopVideo];
            OCMVerify([mockVideoLifecycleManager stop]);
            expect(testStreamingMediaManager.videoStarted).to(beFalse());

            OCMReject([mockAudioLifecycleManager stop]);
            expect(testStreamingMediaManager.audioStarted).to(beTrue());
        });
    });

    context(@"when stop audio is called", ^{
        beforeEach(^{
            testStreamingMediaManager.audioStarted = YES;
            testStreamingMediaManager.videoStarted = YES;
        });

        it(@"should stop the audio stream manager", ^{
            [testStreamingMediaManager stopAudio];
            OCMVerify([mockAudioLifecycleManager stop]);
            expect(testStreamingMediaManager.audioStarted).to(beFalse());

            OCMReject([mockVideoLifecycleManager stop]);
            expect(testStreamingMediaManager.videoStarted).to(beTrue());
        });
    });

    context(@"streaming media manager getters", ^{
        it(@"should return true if only video is streaming", ^{
            testStreamingMediaManager.videoStarted = YES;
            testStreamingMediaManager.audioStarted = NO;

            OCMStub([mockVideoLifecycleManager isStreamingSupported]).andReturn(YES);
            OCMStub([mockAudioLifecycleManager isStreamingSupported]).andReturn(NO);
            expect(testStreamingMediaManager.isStreamingSupported).to(beTrue());
        });

        it(@"should return true if only audio is streaming", ^{
            testStreamingMediaManager.videoStarted = NO;
            testStreamingMediaManager.audioStarted = YES;

            OCMStub([mockVideoLifecycleManager isStreamingSupported]).andReturn(NO);
            OCMStub([mockAudioLifecycleManager isStreamingSupported]).andReturn(YES);
            expect(testStreamingMediaManager.isStreamingSupported).to(beTrue());
        });

        it(@"should return true if both video and audio are streaming", ^{
            testStreamingMediaManager.videoStarted = YES;
            testStreamingMediaManager.audioStarted = YES;

            OCMStub([mockVideoLifecycleManager isStreamingSupported]).andReturn(YES);
            OCMStub([mockAudioLifecycleManager isStreamingSupported]).andReturn(YES);
            expect(testStreamingMediaManager.isStreamingSupported).to(beTrue());
        });

        it(@"should return false if neither video or audio is streaming", ^{            testStreamingMediaManager.videoStarted = NO;
            testStreamingMediaManager.audioStarted = NO;

            OCMStub([mockVideoLifecycleManager isStreamingSupported]).andReturn(NO);
            OCMStub([mockAudioLifecycleManager isStreamingSupported]).andReturn(NO);
            expect(testStreamingMediaManager.isStreamingSupported).to(beFalse());
        });
    });

    context(@"secondary transport", ^{
        __block SDLProtocol *mockProtocol = nil;

        beforeEach(^{
            mockProtocol = OCMClassMock([SDLProtocol class]);
        });

        describe(@"starting a service on a transport when none is running", ^{
            beforeEach(^{
                [testStreamingMediaManager startSecondaryTransportOnProtocol:mockProtocol];
            });

            it(@"should start both the audio and video stream managers with the protocol", ^{
                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockProtocol]);
                OCMVerify([mockVideoLifecycleManager startWithProtocol:mockProtocol]);
                expect(testStreamingMediaManager.audioStarted).to(beTrue());
                expect(testStreamingMediaManager.videoStarted).to(beTrue());
            });

            it(@"should should not attempt to stop a current video or audio session", ^{
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

                [testStreamingMediaManager streamingServiceProtocolDidUpdateFromOldVideoProtocol:[OCMArg any] toNewVideoProtocol:nil fromOldAudioProtocol:[OCMArg any] toNewAudioProtocol:nil];
            });

            it(@"should stop both the audio and video stream managers", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                expect(testStreamingMediaManager.audioStarted).to(beFalse());
                expect(testStreamingMediaManager.videoStarted).to(beFalse());
            });

            it(@"should tell the audio and video stream managers to destroy the protocol", ^{
                OCMVerify([mockAudioLifecycleManager destroyProtocol]);
                OCMVerify([mockVideoLifecycleManager destroyProtocol]);
            });

            it(@"should not attempt to start a new audio and video session", ^{
                OCMReject([mockAudioLifecycleManager startWithProtocol:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager startWithProtocol:[OCMArg any]]);
            });

            it(@"should notify the delegate object that the secondary transport can be destroyed", ^{
                OCMVerify([mockSecondaryTransportDelegate destroySecondaryTransport]);
            });
        });

        describe(@"switching a service to a different transport", ^{
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

                OCMStub([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void (^handler)(void);
                    [invocation getArgument:&handler atIndex:2];
                    handler();
                });

                [testStreamingMediaManager streamingServiceProtocolDidUpdateFromOldVideoProtocol:mockOldProtocol toNewVideoProtocol:mockNewProtocol fromOldAudioProtocol:mockOldProtocol toNewAudioProtocol:mockNewProtocol];
            });

            it(@"should stop both the audio and video stream managers", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
            });

            it(@"should notify the delegate object that the secondary transport can be destroyed", ^{
                OCMVerify([mockSecondaryTransportDelegate destroySecondaryTransport]);
            });

            it(@"should tell the audio and video stream managers to destroy the protocol", ^{
                OCMVerify([mockAudioLifecycleManager destroyProtocol]);
                OCMVerify([mockVideoLifecycleManager destroyProtocol]);
            });

            it(@"should try to start a new audio and video session with the new protocol", ^{
                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockNewProtocol]);
                OCMVerify([mockVideoLifecycleManager startWithProtocol:mockNewProtocol]);

                expect(testStreamingMediaManager.audioStarted).to(beTrue());
                expect(testStreamingMediaManager.videoStarted).to(beTrue());
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

                [testStreamingMediaManager streamingServiceProtocolDidUpdateFromOldVideoProtocol:mockOldProtocol toNewVideoProtocol:mockNewProtocol fromOldAudioProtocol:nil toNewAudioProtocol:nil];
            });

            it(@"should stop the video stream manager but not the audio stream manager", ^{
                OCMVerify([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
            });

            it(@"should notify the delegate object that the secondary transport can be destroyed", ^{
                OCMVerify([mockSecondaryTransportDelegate destroySecondaryTransport]);
            });

            it(@"should tell the video stream manager to destroy the protocol but not the audio stream manager", ^{
                OCMVerify([mockVideoLifecycleManager destroyProtocol]);
                OCMReject([mockAudioLifecycleManager destroyProtocol]);
            });

            it(@"should try to start a new audio session with the new protocol, but not a video session ", ^{
                OCMVerify([mockVideoLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.videoStarted).to(beTrue());

                OCMReject([mockAudioLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.audioStarted).to(beFalse());
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

                [testStreamingMediaManager streamingServiceProtocolDidUpdateFromOldVideoProtocol:nil toNewVideoProtocol:nil fromOldAudioProtocol:mockOldProtocol toNewAudioProtocol:mockNewProtocol];
            });

            it(@"should stop the audio stream manager but not the video stream manager", ^{
                OCMVerify([mockAudioLifecycleManager endAudioServiceWithCompletionHandler:[OCMArg any]]);
                OCMReject([mockVideoLifecycleManager endVideoServiceWithCompletionHandler:[OCMArg any]]);
            });

            it(@"should notify the delegate object that the secondary transport can be destroyed", ^{
                OCMVerify([mockSecondaryTransportDelegate destroySecondaryTransport]);
            });

            it(@"should tell the audio stream manager to destroy the protocol but not the video stream manager", ^{
                OCMVerify([mockAudioLifecycleManager destroyProtocol]);
                OCMReject([mockVideoLifecycleManager destroyProtocol]);
            });

            it(@"should try to start a new audio session with the new protocol, but not a video session ", ^{
                OCMVerify([mockAudioLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.audioStarted).to(beTrue());

                OCMReject([mockVideoLifecycleManager startWithProtocol:mockNewProtocol]);
                expect(testStreamingMediaManager.videoStarted).to(beFalse());
            });
        });
    });
});

QuickSpecEnd
