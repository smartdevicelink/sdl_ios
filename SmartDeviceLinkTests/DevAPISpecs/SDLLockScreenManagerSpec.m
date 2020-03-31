#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLFakeViewControllerPresenter.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenStatus.h"
#import "SDLLockScreenViewController.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLOnDriverDistraction.h"
#import "SDLRPCNotificationNotification.h"

@interface SDLLockScreenManager ()

@property (assign, nonatomic) BOOL canPresent;
@property (strong, nonatomic, readwrite) SDLLockScreenConfiguration *config;
@property (strong, nonatomic) id<SDLViewControllerPresentable> presenter;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, nullable) SDLOnLockScreenStatus *lastLockNotification;
#pragma clang diagnostic pop

@property (strong, nonatomic, nullable) SDLOnDriverDistraction *lastDriverDistractionNotification;
@property (assign, nonatomic, readwrite, getter=isLockScreenDismissable) BOOL lockScreenDismissable;
@property (assign, nonatomic) BOOL lockScreenDismissedByUser;

@end

QuickSpecBegin(SDLLockScreenManagerSpec)

describe(@"a lock screen manager", ^{
    __block SDLLockScreenManager *testManager = nil;
    __block SDLFakeViewControllerPresenter *fakePresenter = nil;
    __block SDLNotificationDispatcher *testNotificationDispatcher = nil;
    
    beforeEach(^{
        fakePresenter = [[SDLFakeViewControllerPresenter alloc] init];
    });
    
    context(@"with a disabled configuration", ^{
        beforeEach(^{
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration disabledConfiguration] notificationDispatcher:nil presenter:fakePresenter];
        });
        
        it(@"should set properties correctly", ^{
            // Note: We can't check the "lockScreenPresented" flag on the Lock Screen Manager because it's a computer property checking the window
            expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it is started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should not have a lock screen controller", ^{
                expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
                expect(testManager.lockScreenViewController).to(beNil());
            });
            
            describe(@"when the lock screen status becomes REQUIRED", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                __block SDLOnLockScreenStatus *testRequiredStatus = nil;

                beforeEach(^{
                    testRequiredStatus = [[SDLOnLockScreenStatus alloc] init];
                    testRequiredStatus.lockScreenStatus = SDLLockScreenStatusRequired;
                    [testNotificationDispatcher postNotificationName:SDLDidChangeLockScreenStatusNotification infoObject:testRequiredStatus];
#pragma clang diagnostic pop
                });
                
                it(@"should not have presented the lock screen", ^{
                    expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
                });
            });
        });
    });
    
    context(@"with an enabled configuration", ^{
        beforeEach(^{
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfiguration] notificationDispatcher:nil presenter:fakePresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
                expect(testManager.lockScreenViewController).toNot(beNil());
                expect(testManager.lockScreenViewController).to(beAnInstanceOf([SDLLockScreenViewController class]));
            });
            
            describe(@"when the lock screen status becomes REQUIRED", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                __block SDLOnLockScreenStatus *testRequiredStatus = nil;
#pragma clang diagnostic pop
                __block SDLOnDriverDistraction *testDriverDistraction = nil;

                beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    testRequiredStatus = [[SDLOnLockScreenStatus alloc] init];
                    testRequiredStatus.lockScreenStatus = SDLLockScreenStatusRequired;
                    SDLRPCNotificationNotification *testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:nil rpcNotification:testRequiredStatus];
#pragma clang diagnostic pop
                    [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];
                });
                
                it(@"should have presented the lock screen", ^{
                    expect(fakePresenter.shouldShowLockScreen).toEventually(beTrue());
                });
                
                it(@"should not have a vehicle icon", ^{
                    expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).to(beNil());
                });
                
                describe(@"when a vehicle icon is received", ^{
                    __block UIImage *testIcon = nil;
                    
                    beforeEach(^{
                        testIcon = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];
                    });
                    
                    it(@"should have a vehicle icon", ^{
                        expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).toNot(beNil());
                        expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).to(equal(testIcon));
                    });
                });
                
                describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled as true", ^{
                    __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;

                    beforeEach(^{
                        testDriverDistraction = [[SDLOnDriverDistraction alloc] init];
                        testDriverDistraction.lockScreenDismissalEnabled = @YES;
                        
                        testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:nil rpcNotification:testDriverDistraction];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:testDriverDistractionNotification];
                    });
                    
                    it(@"should be able to be dismissed", ^{
                        expect(testManager.isLockScreenDismissable).toEventually(equal(YES));
                    });
                });
                
                describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled as false", ^{
                    __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;
                    
                    beforeEach(^{
                        testDriverDistraction = [[SDLOnDriverDistraction alloc] init];
                        testDriverDistraction.lockScreenDismissalEnabled = @0;
                        
                        testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:nil rpcNotification:testDriverDistraction];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:testDriverDistractionNotification];
                    });
                    
                    it(@"should not be able to be dismissed", ^{
                        expect(testManager.isLockScreenDismissable).toEventually(equal(NO));
                    });
                    
                });
                
                describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled nil bit", ^{
                    __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;
                    
                    beforeEach(^{
                        testDriverDistraction = [[SDLOnDriverDistraction alloc] init];
                        
                        testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:nil rpcNotification:testDriverDistraction];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:testDriverDistractionNotification];
                    });
                    
                    it(@"should not be able to be dismissed", ^{
                        expect(testManager.isLockScreenDismissable).toEventually(equal(NO));
                    });
                    
                });
                
                describe(@"then the manager is stopped", ^{
                    beforeEach(^{
                        [testManager stop];
                    });
                    
                    it(@"should have dismissed the lock screen", ^{
                        expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
                    });
                });
                
                describe(@"then the status becomes OFF", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    __block SDLOnLockScreenStatus *testOffStatus = nil;

                    beforeEach(^{
                        testOffStatus = [[SDLOnLockScreenStatus alloc] init];
                        testOffStatus.lockScreenStatus = SDLLockScreenStatusOff;
                        SDLRPCNotificationNotification *testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:nil rpcNotification:testOffStatus];
#pragma clang diagnostic pop
                        [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];
                    });
                    
                    it(@"should have dismissed the lock screen", ^{
                        expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
                    });
                });
            });
        });
    });

    context(@"with showDeviceLogo as NO",  ^{
        beforeEach(^{
            SDLLockScreenConfiguration *config = [SDLLockScreenConfiguration enabledConfiguration];
            config.showDeviceLogo = NO;

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:config notificationDispatcher:nil presenter:fakePresenter];
            [testManager start];
        });

        describe(@"when a vehicle icon is received", ^{
            __block UIImage *testIcon = nil;

            beforeEach(^{
                testIcon = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];
            });

            it(@"should not have a vehicle icon if showDeviceLogo is set to NO", ^{
                expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).to(beNil());
            });
        });

    });

    context(@"with a custom color configuration", ^{
        __block UIColor *testColor = nil;
        __block UIImage *testImage = nil;
        
        beforeEach(^{
            testColor = [UIColor blueColor];
            testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfigurationWithAppIcon:testImage backgroundColor:testColor] notificationDispatcher:nil presenter:fakePresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
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
            expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(fakePresenter.shouldShowLockScreen).toEventually(beFalse());
                expect(testManager.lockScreenViewController).toNot(beNil());
                expect(testManager.lockScreenViewController).toNot(beAnInstanceOf([SDLLockScreenViewController class]));
                expect(testManager.lockScreenViewController).to(equal(testViewController));
            });
        });
    });

    context(@"with a dismissable false configuration", ^{
        beforeEach(^{
            SDLLockScreenConfiguration *config = [SDLLockScreenConfiguration enabledConfiguration];
            config.enableDismissGesture = NO;

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:config notificationDispatcher:nil presenter:fakePresenter];
            [testManager start];
        });

        describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled as true", ^{
            __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;

            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                SDLOnLockScreenStatus *status = [[SDLOnLockScreenStatus alloc] init];
                status.lockScreenStatus = SDLLockScreenStatusRequired;
#pragma clang diagnostic pop
                testManager.lastLockNotification = status;

                SDLOnDriverDistraction *testDriverDistraction = [[SDLOnDriverDistraction alloc] init];
                testDriverDistraction.lockScreenDismissalEnabled = @YES;

                testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:nil rpcNotification:testDriverDistraction];

                [[NSNotificationCenter defaultCenter] postNotification:testDriverDistractionNotification];
            });

            it(@"should not be able to be dismissed", ^{
                expect(testManager.isLockScreenDismissable).toEventually(equal(NO));
            });
        });
    });

    describe(@"with an always enabled configuration", ^{
        __block SDLFakeViewControllerPresenter *fakePresenter = nil;
        __block SDLRPCNotificationNotification *testLockStatusNotification = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        __block SDLOnLockScreenStatus *testStatus = nil;
#pragma clang diagnostic pop

        beforeEach(^{
            fakePresenter = [[SDLFakeViewControllerPresenter alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStatus = [[SDLOnLockScreenStatus alloc] init];
#pragma clang diagnostic pop

            SDLLockScreenConfiguration *config = [SDLLockScreenConfiguration enabledConfiguration];
            config.displayMode = SDLLockScreenConfigurationDisplayModeAlways;

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:config notificationDispatcher:nil presenter:fakePresenter];
            [testManager start];
        });

        context(@"receiving a lock screen status of required", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testStatus.lockScreenStatus = SDLLockScreenStatusRequired;
                testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:nil rpcNotification:testStatus];
#pragma clang diagnostic pop

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];
            });

            it(@"should present the lock screen if not already presented", ^{
                expect(fakePresenter.shouldShowLockScreen).toEventually(beTrue());
            });
        });

        context(@"receiving a lock screen status of off", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testStatus.lockScreenStatus = SDLLockScreenStatusOff;
                testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:nil rpcNotification:testStatus];
#pragma clang diagnostic pop

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];
            });

            it(@"should present the lock screen if not already presented", ^{
                expect(fakePresenter.shouldShowLockScreen).toEventually(beTrue());
            });
        });
    });

    describe(@"A lock screen status of OPTIONAL", ^{
        __block SDLLockScreenManager *testLockScreenManager = nil;
        __block SDLLockScreenConfiguration *testLockScreenConfig = nil;
        __block id mockViewControllerPresenter = nil;
        __block SDLRPCNotificationNotification *testLockStatusNotification = nil;

        beforeEach(^{
            mockViewControllerPresenter = OCMClassMock([SDLFakeViewControllerPresenter class]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLOnLockScreenStatus *testOptionalStatus = [[SDLOnLockScreenStatus alloc] init];
            testOptionalStatus.lockScreenStatus = SDLLockScreenStatusOptional;
            testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:nil rpcNotification:testOptionalStatus];
#pragma clang diagnostic pop
            testLockScreenConfig = [SDLLockScreenConfiguration enabledConfiguration];
        });

        context(@"showInOptionalState is true", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testLockScreenConfig.showInOptionalState = true;
#pragma clang diagnostic pop

                testLockScreenManager = [[SDLLockScreenManager alloc] initWithConfiguration:testLockScreenConfig notificationDispatcher:nil presenter:mockViewControllerPresenter];

                [testLockScreenManager start]; // Sets `canPresent` to `true`
            });

            it(@"should present the lock screen if not already presented", ^{
                OCMStub([mockViewControllerPresenter lockViewController]).andReturn([OCMArg any]);

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];

                // Since lock screen must be presented/dismissed on the main thread, force the test to execute manually on the main thread. If this is not done, the test case may fail.
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
                OCMVerify([mockViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:nil]);
            });
        });

        context(@"showInOptionalState is false", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testLockScreenConfig.showInOptionalState = false;
#pragma clang diagnostic pop

                testLockScreenManager = [[SDLLockScreenManager alloc] initWithConfiguration:testLockScreenConfig notificationDispatcher:nil presenter:mockViewControllerPresenter];

                [testLockScreenManager start]; // Sets `canPresent` to `true`
            });

            it(@"should dismiss the lock screen if already presented", ^{
                OCMStub([mockViewControllerPresenter lockViewController]).andReturn([OCMArg any]);

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];

                // Since lock screen must be presented/dismissed on the main thread, force the test to execute manually on the main thread. If this is not done, the test case may fail.
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
                OCMVerify([mockViewControllerPresenter updateLockScreenToShow:NO withCompletionHandler:nil]);
            });
        });
    });
});

QuickSpecEnd
