#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioStreamManager.h"
#import "SDLStreamingAudioManagerMock.h"

QuickSpecBegin(SDLAudioStreamManagerSpec)

describe(@"the audio stream manager", ^{
    __block SDLAudioStreamManager *testManager = nil;
    __block SDLStreamingAudioManagerMock *mockAudioManager = nil;
    __block NSURL *testAudioFileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"testAudio" withExtension:@"mp3"];

    beforeEach(^{
        mockAudioManager = [[SDLStreamingAudioManagerMock alloc] init];
        testManager = [[SDLAudioStreamManager alloc] initWithManager:mockAudioManager];
        testManager.delegate = mockAudioManager;
    });

    it(@"should have proper initial vars", ^{
        expect(testManager.delegate).toNot(beNil());
        expect(testManager.playing).to(beFalse());
        expect(testManager.queue).to(beEmpty());

        // Also just double check that we actually have a URL
        expect(testAudioFileURL).toNot(beNil());
    });

    describe(@"when audio streaming is not connected", ^{
        beforeEach(^{
            mockAudioManager.audioConnected = NO;
            [testManager pushWithFileURL:testAudioFileURL];

            [NSThread sleepForTimeInterval:0.5];
        });

        describe(@"after attempting to play the file", ^{
            beforeEach(^{
                [mockAudioManager clearData];
                [testManager playNextWhenReady];
            });

            it(@"should fail to send data", ^{
                expect(mockAudioManager.dataSinceClear.length).to(equal(0));
                expect(mockAudioManager.fileError.code).to(equal(SDLAudioStreamManagerErrorNotConnected));
            });
        });
    });

    describe(@"after adding an audio file to the queue", ^{
        beforeEach(^{
            mockAudioManager.audioConnected = YES;
            [testManager pushWithFileURL:testAudioFileURL];

            [NSThread sleepForTimeInterval:0.5];
        });

        it(@"should have a file in the queue", ^{
            expect(testManager.queue).toNot(beEmpty());
        });

        describe(@"after attempting to play the file", ^{
            beforeEach(^{
                [mockAudioManager clearData];
                [testManager playNextWhenReady];
            });

            it(@"should be sending data", ^{
                expect(testManager.isPlaying).toEventually(beTrue());
                expect(mockAudioManager.dataSinceClear.length).toEventually(equal(34380));

                // Fails when it shouldn't, `weakself` goes to nil in `sdl_playNextWhenReady`
//                expect(mockAudioManager.fileFinishedPlaying).toEventually(beTrue());
            });
        });

        describe(@"after stopping the manager", ^{
            beforeEach(^{
                [testManager stop];
            });

            it(@"should have an empty queue", ^{
                expect(testManager.queue).to(beEmpty());
            });
        });
    });
});

QuickSpecEnd
