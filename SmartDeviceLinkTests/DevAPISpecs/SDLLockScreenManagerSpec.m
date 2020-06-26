#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLFakeViewControllerPresenter.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenStatus.h"
#import "SDLLockScreenStatusManager.h"
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
@property (strong, nonatomic) SDLLockScreenStatusManager *statusManager;

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
    __block SDLFakeViewControllerPresenter *fakeViewControllerPresenter = nil;
    __block SDLNotificationDispatcher *dispatcherMock = nil;
    
    beforeEach(^{
        fakeViewControllerPresenter = [[SDLFakeViewControllerPresenter alloc] init];
        dispatcherMock = OCMClassMock([SDLNotificationDispatcher class]);
    });
    
    context(@"with a disabled configuration", ^{
        beforeEach(^{
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration disabledConfiguration] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });
        
        it(@"should set properties correctly", ^{
            // Note: We can't check the "lockScreenPresented" flag on the Lock Screen Manager because it's a computer property checking the window
            expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it is started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should not have a lock screen controller", ^{
                expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
                expect(testManager.lockScreenViewController).to(beNil());
            });
            
            describe(@"when the lock screen status becomes REQUIRED", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                __block SDLOnLockScreenStatus *testRequiredStatus = nil;

                beforeEach(^{
                    testRequiredStatus = [[SDLOnLockScreenStatus alloc] init];
                    testRequiredStatus.lockScreenStatus = SDLLockScreenStatusRequired;
                    [dispatcherMock postNotificationName:SDLDidChangeLockScreenStatusNotification infoObject:testRequiredStatus];
#pragma clang diagnostic pop
                });
                
                it(@"should not have presented the lock screen", ^{
                    expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
                });
            });
        });
    });
    
    context(@"with an enabled configuration", ^{
        beforeEach(^{
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfiguration] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
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
                    SDLRPCNotificationNotification *testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager rpcNotification:testRequiredStatus];
#pragma clang diagnostic pop
                    [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];
                });
                
                it(@"should have presented the lock screen", ^{
                    expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beTrue());
                });
                
                it(@"should not have a vehicle icon", ^{
                    expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).to(beNil());
                });

                describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled as true", ^{
                    __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;

                    beforeEach(^{
                        testDriverDistraction = [[SDLOnDriverDistraction alloc] init];
                        testDriverDistraction.lockScreenDismissalEnabled = @YES;
                        
                        testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:dispatcherMock rpcNotification:testDriverDistraction];
                        
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
                        expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
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
                        expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
                    });
                });
            });
        });
    });

    context(@"when a vehicle icon is received", ^{
        __block UIImage *testIcon = nil;
        SDLLockScreenConfiguration *testsConfig = [SDLLockScreenConfiguration enabledConfiguration];

        beforeEach(^{
            testIcon = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        });

        it(@"should should set the vehicle icon on the default lockscreen if showDeviceLogo set to true", ^{
            testsConfig.showDeviceLogo = YES;
            fakeViewControllerPresenter.lockViewController = [[SDLLockScreenViewController alloc] init];
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testsConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];

            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];

            expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).toEventually(equal(testIcon));
        });

        it(@"should should not set the vehicle icon on the default lockscreen if showDeviceLogo set to false", ^{
            testsConfig.showDeviceLogo = NO;
            fakeViewControllerPresenter.lockViewController = [[SDLLockScreenViewController alloc] init];
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testsConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];

            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];

            expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).toEventually(beNil());
        });

        it(@"should should not modify a custom lockscreen", ^{
            testsConfig.showDeviceLogo = YES;
            UIViewController *customLockScreen = [[UIViewController alloc] init];
            fakeViewControllerPresenter.lockViewController = customLockScreen;
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testsConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];

            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];

            expect(fakeViewControllerPresenter.lockViewController).toEventually(equal(customLockScreen));
        });
    });

    context(@"with a custom color configuration", ^{
        __block UIColor *testColor = nil;
        __block UIImage *testImage = nil;
        
        beforeEach(^{
            testColor = [UIColor blueColor];
            testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfigurationWithAppIcon:testImage backgroundColor:testColor] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
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
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfigurationWithViewController:testViewController] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });
        
        it(@"should set properties correctly", ^{
            expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should set up the view controller correctly", ^{
                expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beFalse());
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

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:config notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
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
        __block SDLFakeViewControllerPresenter *fakeViewControllerPresenter = nil;
        __block SDLRPCNotificationNotification *testLockStatusNotification = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        __block SDLOnLockScreenStatus *testStatus = nil;
#pragma clang diagnostic pop

        beforeEach(^{
            fakeViewControllerPresenter = [[SDLFakeViewControllerPresenter alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStatus = [[SDLOnLockScreenStatus alloc] init];
#pragma clang diagnostic pop

            SDLLockScreenConfiguration *config = [SDLLockScreenConfiguration enabledConfiguration];
            config.displayMode = SDLLockScreenConfigurationDisplayModeAlways;

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:config notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
            [testManager start];
        });

        context(@"receiving a lock screen status of required", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testStatus.lockScreenStatus = SDLLockScreenStatusRequired;
                testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager rpcNotification:testStatus];
#pragma clang diagnostic pop

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];
            });

            it(@"should present the lock screen if not already presented", ^{
                expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beTrue());
            });
        });

        context(@"receiving a lock screen status of off", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testStatus.lockScreenStatus = SDLLockScreenStatusOff;
                testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager rpcNotification:testStatus];
#pragma clang diagnostic pop

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];
            });

            it(@"should present the lock screen if not already presented", ^{
                expect(fakeViewControllerPresenter.shouldShowLockScreen).toEventually(beTrue());
            });
        });
    });

    describe(@"A lock screen status of OPTIONAL", ^{
        __block SDLLockScreenConfiguration *testLockScreenConfig = nil;
        __block id mockViewControllerPresenter = nil;
        __block SDLRPCNotificationNotification *testLockStatusNotification = nil;

        beforeEach(^{
            mockViewControllerPresenter = OCMClassMock([SDLFakeViewControllerPresenter class]);
            testLockScreenConfig = [SDLLockScreenConfiguration enabledConfiguration];
        });

        context(@"showInOptionalState is true", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testLockScreenConfig.showInOptionalState = true;
#pragma clang diagnostic pop

                testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testLockScreenConfig notificationDispatcher:dispatcherMock presenter:mockViewControllerPresenter];
                testManager.canPresent = YES;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLOnLockScreenStatus *testOptionalStatus = [[SDLOnLockScreenStatus alloc] init];
            testOptionalStatus.lockScreenStatus = SDLLockScreenStatusOptional;
            testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager rpcNotification:testOptionalStatus];
#pragma clang diagnostic pop
            });

            it(@"should present the lock screen if not already presented", ^{
                OCMStub([mockViewControllerPresenter lockViewController]).andReturn([OCMArg any]);
                OCMExpect([mockViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:[OCMArg any]]).ignoringNonObjectArgs();

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];

                OCMVerifyAllWithDelay(mockViewControllerPresenter, 0.5);
            });
        });

        context(@"showInOptionalState is false", ^{
            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testLockScreenConfig.showInOptionalState = false;
#pragma clang diagnostic pop

                testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testLockScreenConfig notificationDispatcher:dispatcherMock presenter:mockViewControllerPresenter];
                testManager.canPresent = YES;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLOnLockScreenStatus *testOptionalStatus = [[SDLOnLockScreenStatus alloc] init];
            testOptionalStatus.lockScreenStatus = SDLLockScreenStatusOptional;
            testLockStatusNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager rpcNotification:testOptionalStatus];
#pragma clang diagnostic pop
            });

            it(@"should dismiss the lock screen if already presented", ^{
                OCMStub([mockViewControllerPresenter lockViewController]).andReturn([OCMArg any]);
                OCMExpect([mockViewControllerPresenter updateLockScreenToShow:NO withCompletionHandler:[OCMArg any]]).ignoringNonObjectArgs();

                [[NSNotificationCenter defaultCenter] postNotification:testLockStatusNotification];

                OCMVerifyAllWithDelay(mockViewControllerPresenter, 0.5);
            });
        });
    });
});

QuickSpecEnd
