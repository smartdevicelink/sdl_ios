#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVoiceCommand.h"

QuickSpecBegin(SDLVoiceCommandSpec)

describe(@"a voice command", ^{
    __block SDLVoiceCommand *testCommand = nil;
    __block SDLVoiceCommand *testCommandEmpty = nil;

    describe(@"initializing", ^{
        __block NSArray<NSString *> *someVoiceCommands = nil;
        __block NSArray<NSString *> *someVoiceCommandsEmpty = nil;

        beforeEach(^{
            someVoiceCommands = @[@"some command"];
        });

        it(@"should initialize properly", ^{
            testCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:someVoiceCommands handler:^{}];

            expect(testCommand.voiceCommands).to(equal(someVoiceCommands));
        });

        it(@"should not initialize", ^{
            testCommandEmpty = [[SDLVoiceCommand alloc] initWithVoiceCommands:someVoiceCommandsEmpty handler:^{}];

            expect(testCommandEmpty).to(beNil());
        });
    });
});

QuickSpecEnd
