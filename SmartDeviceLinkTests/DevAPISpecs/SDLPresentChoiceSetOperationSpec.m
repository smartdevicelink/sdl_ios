#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPresentChoiceSetOperation.h"

#import "SDLKeyboardDelegate.h"
#import "SDLKeyboardProperties.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLPresentChoiceSetOperationSpec)

fdescribe(@"present choice operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLPresentChoiceSetOperation *testOp = nil;

    __block NSString *testInitialText = @"Initial Text";
    __block id<SDLKeyboardDelegate> testDelegate = nil;
    __block SDLKeyboardProperties *testInitialProperties = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
        OCMStub([testDelegate customKeyboardConfiguration]).andReturn(nil);

        testInitialProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageArSa layout:SDLKeyboardLayoutAZERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteText:nil];
    });
});

QuickSpecEnd
