#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLChoiceSetManager.h"

#import "SDLCheckChoiceVROptionalOperation.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLKeyboardProperties.h"
#import "SDLSystemContext.h"
#import "TestConnectionManager.h"

@interface SDLCheckChoiceVROptionalOperation()

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@interface SDLChoiceSetManager()

@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

@end

QuickSpecBegin(SDLChoiceSetManagerSpec)

fdescribe(@"choice set manager tests", ^{
    __block SDLChoiceSetManager *testManager = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);

        testManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager];
    });

    it(@"should be in the correct startup state", ^{
        expect(testManager.currentState).to(equal(SDLChoiceManagerStateShutdown));

        SDLKeyboardProperties *defaultProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs layout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteText:nil];
        expect(testManager.keyboardConfiguration).to(equal(defaultProperties));
    });

    describe(@"once started", ^{
        beforeEach(^{
            [testManager start];
        });

        it(@"should start checking for VR Optional", ^{
            expect(testManager.currentState).to(equal(SDLChoiceManagerStateCheckingVoiceOptional));

            expect(testManager.transactionQueue.operationCount).to(equal(1)); expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLCheckChoiceVROptionalOperation class]));
        });

        describe(@"after the bad vr optional response", ^{
            beforeEach(^{
                SDLCheckChoiceVROptionalOperation *vrOptionalOp = testManager.transactionQueue.operations.lastObject;
                vrOptionalOp.vrOptional = NO;
                vrOptionalOp.internalError = [NSError errorWithDomain:@"test" code:0 userInfo:nil];
                vrOptionalOp.completionBlock();
            });

            it(@"should be ready", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateStartupError));
            });
        });

        describe(@"after the vr optional response", ^{
            beforeEach(^{
                SDLCheckChoiceVROptionalOperation *vrOptionalOp = testManager.transactionQueue.operations.lastObject;
                vrOptionalOp.vrOptional = YES;
                vrOptionalOp.completionBlock();
            });

            it(@"should be ready", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateReady));
            });
        });
    });
});

QuickSpecEnd
