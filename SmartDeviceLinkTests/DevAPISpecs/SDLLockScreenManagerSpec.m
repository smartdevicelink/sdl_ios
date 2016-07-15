#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"


QuickSpecBegin(SDLLockScreenManagerSpec)

describe(@"a lock screen manager", ^{
    __block SDLLockScreenManager *testManager = nil;
    
    context(@"with a disabled configuration", ^{
        beforeEach(^{
            // TODO: Fake presenter
//            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration disabledConfiguration] notificationDispatcher:nil presenter:<#(nonnull id<SDLViewControllerPresentable>)#>];
        });
        
        it(@"should set properties correctly", ^{
            expect(@(testManager.lockScreenPresented)).to(beFalsy());
            expect(testManager.lockScreenViewController).to(beNil());
        });
    });
    
    context(@"with a basic enabled configuration", ^{
        beforeEach(^{
//            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfiguration] notificationDispatcher:nil presenter:<#(nonnull id<SDLViewControllerPresentable>)#>];
        });
    });
    
    context(@"with a custom color configuration", ^{
        beforeEach(^{
            
        });
    });
    
    context(@"with a custom view controller configuration", ^{
        beforeEach(^{
            
        });
    });
});

QuickSpecEnd
