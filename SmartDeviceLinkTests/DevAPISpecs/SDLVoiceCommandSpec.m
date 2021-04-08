#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVoiceCommand.h"

QuickSpecBegin(SDLVoiceCommandSpec)

describe(@"a voice command", ^{
    __block SDLVoiceCommand *testCommand = nil;
    __block SDLVoiceCommand *testCommand2 = nil;

    describe(@"initializing", ^{
        __block NSArray<NSString *> *someVoiceCommands = nil;
        __block NSArray<NSString *> *someVoiceCommands2 = nil;

        beforeEach(^{
            someVoiceCommands = @[@"some command"];
            someVoiceCommands2 = @[@"Test 1", @"Test 1", @"Test 1"];
        });

        it(@"should initialize properly", ^{
            testCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:someVoiceCommands handler:^{}];

            expect(testCommand.voiceCommands).to(equal(someVoiceCommands));
        });

        it(@"should initialize properly if it have multiple of the same command string", ^{
            testCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:someVoiceCommands2 handler:^{}];

            expect(testCommand2.voiceCommands).toNot(equal(someVoiceCommands2));
            expect(testCommand2.voiceCommands).to(haveCount(1));
        });
    });
});

QuickSpecEnd
