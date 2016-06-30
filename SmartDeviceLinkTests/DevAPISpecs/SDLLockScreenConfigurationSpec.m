#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockScreenConfiguration.h"

QuickSpecBegin(SDLLockScreenConfigurationSpec)

fdescribe(@"a lock screen configuration", ^{
    __block SDLLockScreenConfiguration *testConfig = nil;
    
    context(@"in the disabled configuration", ^{
        beforeEach(^{
            testConfig = [SDLLockScreenConfiguration disabledConfiguration];
        });
        
        it(@"should properly set properties", ^{
            expect(@(testConfig.enableAutomaticLockScreen)).to(beFalsy());
            expect(@(testConfig.showInOptional)).to(beFalsy());
            expect(testConfig.backgroundColor).to(equal([UIColor blackColor]));
            expect(testConfig.appIcon).to(beNil());
            expect(testConfig.customViewController).to(beNil());
        });
    });
    
    context(@"in the base enabled configuration", ^{
        beforeEach(^{
            testConfig = [SDLLockScreenConfiguration enabledConfiguration];
        });
        
        it(@"should properly set properties", ^{
            expect(@(testConfig.enableAutomaticLockScreen)).to(beTruthy());
            expect(@(testConfig.showInOptional)).to(beFalsy());
            expect(testConfig.backgroundColor).to(equal([UIColor blackColor]));
            expect(testConfig.appIcon).to(beNil());
            expect(testConfig.customViewController).to(beNil());
        });
    });
    
    context(@"in the background customizable enabled configuration", ^{
        __block UIColor *testBackgroundColor = nil;
        __block UIImage *testImage = nil;
        
        beforeEach(^{
            testBackgroundColor = [UIColor blueColor];
            testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            
            testConfig = [SDLLockScreenConfiguration enabledConfigurationWithBackgroundColor:testBackgroundColor appIcon:testImage];
        });
        
        it(@"should properly set properties", ^{
            expect(@(testConfig.enableAutomaticLockScreen)).to(beTruthy());
            expect(@(testConfig.showInOptional)).to(beFalsy());
            expect(testConfig.backgroundColor).to(equal([UIColor blueColor]));
            expect(testConfig.appIcon).to(equal(testImage));
            expect(testConfig.customViewController).to(beNil());
        });
    });
    
    context(@"in the view controller customizable enabled configuration", ^{
        __block UIViewController *testVC = nil;
        
        beforeEach(^{
            testVC = [[UIViewController alloc] init];
            
            testConfig = [SDLLockScreenConfiguration enabledConfigurationWithViewController:testVC];
        });
        
        it(@"should properly set properties", ^{
            expect(@(testConfig.enableAutomaticLockScreen)).to(beTruthy());
            expect(@(testConfig.showInOptional)).to(beFalsy());
            expect(testConfig.backgroundColor).to(equal([UIColor blackColor]));
            expect(testConfig.appIcon).to(beNil());
            expect(testConfig.customViewController).to(equal(testVC));
        });
    });
});

QuickSpecEnd
