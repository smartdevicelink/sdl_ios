#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFakeViewControllerPresenter.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenStatus.h"
#import "SDLLockScreenViewController.h"
#import "SDLNotificationConstants.h"
#import "SDLOnLockScreenStatus.h"


QuickSpecBegin(SDLLockScreenManagerSpec)

fdescribe(@"a lock screen manager", ^{
    __block SDLLockScreenManager *testManager = nil;
    __block SDLFakeViewControllerPresenter *fakePresenter = nil;
    
    beforeEach(^{
        fakePresenter = [[SDLFakeViewControllerPresenter alloc] init];
    });
    
    context(@"with a disabled configuration", ^{
        beforeEach(^{
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration disabledConfiguration] notificationDispatcher:nil presenter:fakePresenter];
        });
        
        it(@"should set properties correctly", ^{
            // Note: We can't check the "lockScreenPresented" flag on the Lock Screen Manager because it's a computer property checking the window
            expect(@(fakePresenter.presented)).to(beFalsy());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it is started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should not have a lock screen controller", ^{
                expect(@(fakePresenter.presented)).to(beFalsy());
                expect(testManager.lockScreenViewController).to(beNil());
            });
            
            describe(@"when the lock screen status becomes REQUIRED", ^{
                __block SDLOnLockScreenStatus *testRequiredStatus = nil;
                
                beforeEach(^{
                    testRequiredStatus = [[SDLOnLockScreenStatus alloc] init];
                    testRequiredStatus.lockScreenStatus = [SDLLockScreenStatus REQUIRED];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:testRequiredStatus];
                });
                
                it(@"should not have presented the lock screen", ^{
                    expect(@(fakePresenter.presented)).to(beFalsy());
                });
            });
        });
    });
    
    context(@"with an enabled configuration", ^{
        beforeEach(^{
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfiguration] notificationDispatcher:nil presenter:fakePresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(@(fakePresenter.presented)).to(beFalsy());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(@(fakePresenter.presented)).to(beFalsy());
                expect(testManager.lockScreenViewController).toNot(beNil());
                expect(testManager.lockScreenViewController).to(beAnInstanceOf([SDLLockScreenViewController class]));
            });
        });
    });
    
    context(@"with a custom color configuration", ^{
        __block UIColor *testColor = nil;
        __block UIImage *testImage = nil;
        
        beforeEach(^{
            testColor = [UIColor blueColor];
            testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfigurationWithBackgroundColor:testColor appIcon:testImage] notificationDispatcher:nil presenter:fakePresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(@(fakePresenter.presented)).to(beFalsy());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(@(fakePresenter.presented)).to(beFalsy());
                expect(testManager.lockScreenViewController).toNot(beNil());
                expect(testManager.lockScreenViewController).to(beAnInstanceOf([SDLLockScreenViewController class]));
                expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).backgroundColor).to(equal(testColor));
                expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).appIcon).to(equal(testImage));
            });
        });
    });
    
    context(@"with a custom view controller configuration", ^{
        __block UIViewController *testViewController = nil;
        
        beforeEach(^{
            testViewController = [[UIViewController alloc] init];
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfigurationWithViewController:testViewController] notificationDispatcher:nil presenter:fakePresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(@(fakePresenter.presented)).to(beFalsy());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(@(fakePresenter.presented)).to(beFalsy());
                expect(testManager.lockScreenViewController).toNot(beNil());
                expect(testManager.lockScreenViewController).toNot(beAnInstanceOf([SDLLockScreenViewController class]));
                expect(testManager.lockScreenViewController).to(equal(testViewController));
            });
        });
    });
});

QuickSpecEnd
