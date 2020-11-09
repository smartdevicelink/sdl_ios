#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLDeleteCommand.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLVoiceCommand.h"
#import "SDLVoiceCommandManager.h"
#import "TestConnectionManager.h"

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

QuickSpecBegin(SDLVoiceCommandOperationSpec)

describe(@"a voice command operation", ^{
    it(@"should have a priority of 'normal'", ^{

    });

    describe(@"initializing the operation", ^{

    });

    describe(@"starting the operation", ^{
        context(@"if it starts cancelled", ^{
            it(@"should return immediately with an error", ^{

            });
        });

        context(@"if it has voice commands to delete", ^{
            context(@"and the delete succeeds", ^{
                <#code#>
            });

            context(@"and the delete fails", ^{
                <#code#>
            });
        });

        context(@"if it doesn't have any voice commands to delete", ^{
            <#code#>
        });
    });
});

QuickSpecEnd
