#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioStreamManager.h"
#import "SDLError.h"
#import "SDLStreamingAudioManagerMock.h"

QuickSpecBegin(SDLAudioStreamManagerSpec)

describe(@"the audio stream manager", ^{
    __block SDLAudioStreamManager *testManager = nil;
    __block SDLStreamingAudioManagerMock *mockAudioManager = nil;
    __block NSURL *testAudioFileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"testAudio" withExtension:@"mp3"];
    __block NSData *testAudioFileData = [NSData dataWithContentsOfURL:testAudioFileURL options:0 error:nil];

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
        context(@"with a file URL", ^{
            beforeEach(^{
                mockAudioManager.audioConnected = NO;
                [testManager pushWithFileURL:testAudioFileURL];
            });

            describe(@"after attempting to play the file", ^{
                beforeEach(^{
                    [mockAudioManager clearData];
                    [testManager playNextWhenReady];
                });

                it(@"should fail to send data", ^{
                    expect(mockAudioManager.dataSinceClear.length).toEventually(equal(0));
                    expect(mockAudioManager.error.code).toEventually(equal(SDLAudioStreamManagerErrorNotConnected));
                });
            });
        });

        context(@"with a data buffer", ^{
            beforeEach(^{
                mockAudioManager.audioConnected = NO;
                [testManager pushWithData:testAudioFileData];
            });

            describe(@"after attempting to play the file", ^{
                beforeEach(^{
                    [mockAudioManager clearData];
                    [testManager playNextWhenReady];
                });

                it(@"should fail to send data", ^{
                    expect(mockAudioManager.dataSinceClear.length).toEventually(equal(0));
                    expect(mockAudioManager.error.code).toEventually(equal(SDLAudioStreamManagerErrorNotConnected));
                });
            });
        });
    });

    describe(@"after adding an audio file to the queue", ^{
        beforeEach(^{
            mockAudioManager.audioConnected = YES;
            [testManager pushWithFileURL:testAudioFileURL];
        });

        it(@"should have a file in the queue", ^{
            expect(testManager.queue).toEventuallyNot(beEmpty());
        });

        describe(@"after attempting to play the file", ^{
            beforeEach(^{
                [mockAudioManager clearData];
                [testManager playNextWhenReady];
            });

            it(@"should be sending data", ^{
                expect(testManager.isPlaying).toEventually(beTrue());
                expect(mockAudioManager.dataSinceClear.length).toEventually(equal(34380));

                // wait for the delegate to be called when the audio finishes
                float waitTime = 1.1 + 0.25; // length of audio in testAudioFileURL + 0.25 buffer
                NSLog(@"Please wait %f for audio file to finish playing...", waitTime);
                [NSThread sleepForTimeInterval:waitTime];

                expect(mockAudioManager.finishedPlaying).toEventually(beTrue());
            });
        });

        describe(@"after stopping the manager", ^{
            beforeEach(^{
                [testManager stop];
            });

            it(@"should have an empty queue", ^{
                expect(testManager.queue).toEventually(beEmpty());
            });
        });
    });

    describe(@"after adding an audio buffer to the queue", ^{
        beforeEach(^{
            mockAudioManager.audioConnected = YES;
            [testManager pushWithData:testAudioFileData];
        });

        it(@"should have a file in the queue", ^{
            expect(testManager.queue).toEventuallyNot(beEmpty());
        });

        describe(@"after attempting to play the audio buffer", ^{
            beforeEach(^{
                [mockAudioManager clearData];
                [testManager playNextWhenReady];
            });

            it(@"should be sending data", ^{
                expect(testManager.isPlaying).toEventually(beTrue());
                expect(mockAudioManager.dataSinceClear.length).toEventually(equal(14838));

                // Fails when it shouldn't, `weakself` goes to nil in `sdl_playNextWhenReady`
                expect(mockAudioManager.finishedPlaying).toEventually(beTrue());
            });
        });

        describe(@"after stopping the manager", ^{
            beforeEach(^{
                [testManager stop];
            });

            it(@"should have an empty queue", ^{
                expect(testManager.queue).toEventually(beEmpty());
            });
        });
    });
});

QuickSpecEnd
