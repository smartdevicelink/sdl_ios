#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVoiceCommand.h"

QuickSpecBegin(SDLVoiceCommandSpec)

describe(@"a voice command", ^{
    __block SDLVoiceCommand *testCommand = nil;

    describe(@"initializing", ^{
        __block NSArray<NSString *> *someVoiceCommands = nil;

        beforeEach(^{
            someVoiceCommands = @[@"some command"];
        });

        it(@"should initialize properly", ^{
            testCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:someVoiceCommands handler:^{}];

            expect(testCommand.voiceCommands).to(equal(someVoiceCommands));
        });
    });
});

QuickSpecEnd
