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
    });

    it(@"should have proper initial vars", ^{
        expect(testManager.delegate).to(beNil());
        expect(testManager.playing).to(beFalse());
        expect(testManager.queue).to(beEmpty());

        // Also just double check that we actually have a URL
        expect(testAudioFileURL).toNot(beNil());
    });
});

QuickSpecEnd
