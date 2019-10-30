#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockScreenConfiguration.h"

QuickSpecBegin(SDLLockScreenConfigurationSpec)

describe(@"a lock screen configuration", ^{
    __block SDLLockScreenConfiguration *testConfig = nil;
    
    context(@"in the disabled configuration", ^{
        beforeEach(^{
            testConfig = [SDLLockScreenConfiguration disabledConfiguration];
        });
        
        it(@"should properly set properties", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testConfig.enableAutomaticLockScreen).to(beFalse());
            expect(testConfig.showInOptionalState).to(beFalse());
#pragma clang diagnostic pop
            expect(testConfig.enableDismissGesture).to(beFalse());
            expect(testConfig.showDeviceLogo).to(beFalse());
            expect(testConfig.backgroundColor).to(equal([UIColor colorWithRed:(57.0/255.0) green:(78.0/255.0) blue:(96.0/255.0) alpha:1.0]));
            expect(testConfig.appIcon).to(beNil());
            expect(testConfig.customViewController).to(beNil());
        });
    });
    
    context(@"in the base enabled configuration", ^{
        beforeEach(^{
            testConfig = [SDLLockScreenConfiguration enabledConfiguration];
        });
        
        it(@"should properly set properties", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testConfig.enableAutomaticLockScreen).to(beTrue());
            expect(testConfig.showInOptionalState).to(beFalse());
#pragma clang diagnostic pop
            expect(testConfig.enableDismissGesture).to(beTrue());
            expect(testConfig.showDeviceLogo).to(beTrue());
            expect(testConfig.backgroundColor).to(equal([UIColor colorWithRed:(57.0/255.0) green:(78.0/255.0) blue:(96.0/255.0) alpha:1.0]));
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
            
            testConfig = [SDLLockScreenConfiguration enabledConfigurationWithAppIcon:testImage backgroundColor:testBackgroundColor];
        });
        
        it(@"should properly set properties", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testConfig.enableAutomaticLockScreen).to(beTrue());
            expect(testConfig.showInOptionalState).to(beFalse());
#pragma clang diagnostic pop
            expect(testConfig.enableDismissGesture).to(beTrue());
            expect(testConfig.showDeviceLogo).to(beTrue());
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testConfig.enableAutomaticLockScreen).to(beTrue());
            expect(testConfig.showInOptionalState).to(beFalse());
#pragma clang diagnostic pop
            expect(testConfig.enableDismissGesture).to(beTrue());
            expect(testConfig.showDeviceLogo).to(beTrue());
            expect(testConfig.backgroundColor).to(equal([UIColor colorWithRed:(57.0/255.0) green:(78.0/255.0) blue:(96.0/255.0) alpha:1.0]));
            expect(testConfig.appIcon).to(beNil());
            expect(testConfig.customViewController).to(equal(testVC));
        });
    });
});

QuickSpecEnd
