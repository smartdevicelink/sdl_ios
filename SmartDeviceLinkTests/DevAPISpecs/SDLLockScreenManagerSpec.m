#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLFakeViewControllerPresenter.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenStatusInfo.h"
#import "SDLLockScreenStatusManager.h"
#import "SDLLockScreenViewController.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnDriverDistraction.h"
#import "SDLRPCNotificationNotification.h"

@interface SDLLockScreenManager ()

@property (assign, nonatomic) BOOL canPresent;
@property (strong, nonatomic, readwrite) SDLLockScreenConfiguration *config;
@property (strong, nonatomic) id<SDLViewControllerPresentable> presenter;
@property (strong, nonatomic) SDLLockScreenStatusManager *statusManager;

@property (strong, nonatomic, nullable) SDLLockScreenStatusInfo *lastLockNotification;
@property (strong, nonatomic, nullable) SDLOnDriverDistraction *lastDriverDistractionNotification;
@property (assign, nonatomic, readwrite, getter=isLockScreenDismissable) BOOL lockScreenDismissable;
@property (assign, nonatomic) BOOL lockScreenDismissedByUser;

- (void)sdl_updateLockScreenDismissable;

@end

QuickSpecBegin(SDLLockScreenManagerSpec)

describe(@"a lock screen manager", ^{
    __block SDLLockScreenManager *testManager = nil;
    __block SDLNotificationDispatcher *dispatcherMock = nil;
    __block id fakeViewControllerPresenter = nil;

    beforeEach(^{
        testManager = nil;
        dispatcherMock = nil;
        fakeViewControllerPresenter = nil;
    });

    context(@"with a disabled configuration", ^{
        beforeEach(^{
            fakeViewControllerPresenter = OCMPartialMock([[SDLFakeViewControllerPresenter alloc] init]);
            dispatcherMock = OCMClassMock([SDLNotificationDispatcher class]);

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration disabledConfiguration] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });
        
        it(@"should set properties correctly", ^{
            // Note: We can't check the "lockScreenPresented" flag on the Lock Screen Manager because it's a computer property checking the window
            expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after the manager has been started", ^{
            beforeEach(^{
                [testManager start];
            });
            
            it(@"should not have a lock screen controller", ^{
                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
                expect(testManager.lockScreenViewController).to(beNil());
            });
            
            describe(@"when the lock screen status becomes REQUIRED", ^{
                __block SDLLockScreenStatusInfo *testRequiredStatus = nil;

                beforeEach(^{
                    testRequiredStatus = [[SDLLockScreenStatusInfo alloc] init];
                    testRequiredStatus.lockScreenStatus = SDLLockScreenStatusRequired;
                    [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager userInfo:@{SDLNotificationUserInfoObject: testRequiredStatus}];
                });
                
                it(@"should not have presented the lock screen", ^{
                    OCMReject([fakeViewControllerPresenter updateLockScreenToShow:[OCMArg any] withCompletionHandler:nil]);

                    OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);
                });
            });
        });
    });
    
    context(@"with an enabled configuration", ^{
        beforeEach(^{
            fakeViewControllerPresenter = OCMPartialMock([[SDLFakeViewControllerPresenter alloc] init]);
            dispatcherMock = OCMClassMock([SDLNotificationDispatcher class]);

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfiguration] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });

        it(@"should set properties correctly", ^{
            expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });
        
        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });

            it(@"should set up the view controller correctly", ^{
                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
                expect(testManager.lockScreenViewController).toNot(beNil());
                expect(testManager.lockScreenViewController).to(beAnInstanceOf([SDLLockScreenViewController class]));
            });

            describe(@"when the lock screen status becomes REQUIRED", ^{
                __block SDLLockScreenStatusInfo *testRequiredStatus = nil;
                __block SDLOnDriverDistraction *testDriverDistraction = nil;

                beforeEach(^{
                    testRequiredStatus = [[SDLLockScreenStatusInfo alloc] init];
                    testRequiredStatus.lockScreenStatus = SDLLockScreenStatusRequired;

                    testDriverDistraction = [[SDLOnDriverDistraction alloc] init];

                    [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:dispatcherMock userInfo:@{SDLNotificationUserInfoObject: testRequiredStatus}];
                });

                it(@"should have presented the lock screen and the lockscreen should not have a vehicle icon", ^{
                    OCMExpect([fakeViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:[OCMArg any]]);

                    OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);

                    expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).to(beNil());
                });

                describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled set to true", ^{
                    __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;

                    beforeEach(^{
                        testDriverDistraction.lockScreenDismissalEnabled = @YES;

                        testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:dispatcherMock rpcNotification:testDriverDistraction];

                        [[NSNotificationCenter defaultCenter] postNotification:testDriverDistractionNotification];
                    });

                    it(@"should be able to be dismissed", ^{
                        expect(testManager.isLockScreenDismissable).toEventually(beTrue());
                    });
                });

                describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled set to false", ^{
                    __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;

                    beforeEach(^{
                        testDriverDistraction.lockScreenDismissalEnabled = @NO;

                        testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:dispatcherMock rpcNotification:testDriverDistraction];

                        [[NSNotificationCenter defaultCenter] postNotification:testDriverDistractionNotification];
                    });

                    it(@"should not be able to be dismissed", ^{
                        expect(testManager.isLockScreenDismissable).toEventually(beFalse());
                    });
                });

                describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled set to nil", ^{
                    __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;

                    beforeEach(^{
                        testDriverDistractionNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:dispatcherMock rpcNotification:testDriverDistraction];

                        [[NSNotificationCenter defaultCenter] postNotification:testDriverDistractionNotification];
                    });

                    it(@"should not be able to be dismissed", ^{
                        expect(testManager.isLockScreenDismissable).toEventually(beFalse());
                    });
                });

                describe(@"then the manager is stopped", ^{
                    beforeEach(^{
                        [testManager stop];
                    });

                    it(@"should have dismissed the lock screen", ^{
                        OCMVerify([fakeViewControllerPresenter stopWithCompletionHandler:[OCMArg any]]);

                        expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).to(beFalse());
                    });
                });

                describe(@"then the status becomes OFF", ^{
                    __block SDLLockScreenStatusInfo *testOffStatus = nil;

                    beforeEach(^{
                        testOffStatus = [[SDLLockScreenStatusInfo alloc] init];
                        testOffStatus.lockScreenStatus = SDLLockScreenStatusOff;

                        [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:dispatcherMock userInfo:@{SDLNotificationUserInfoObject: testOffStatus}];
                    });

                    it(@"should have dismissed the lock screen", ^{
                        OCMExpect([fakeViewControllerPresenter updateLockScreenToShow:NO withCompletionHandler:[OCMArg any]]);

                        OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);

                        expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).to(beFalse());
                    });
                });
            });
        });
    });

    context(@"when a vehicle icon is received", ^{
        __block UIImage *testIcon = nil;
        SDLLockScreenConfiguration *testsConfig = [SDLLockScreenConfiguration enabledConfiguration];

        beforeEach(^{
            fakeViewControllerPresenter = OCMPartialMock([[SDLFakeViewControllerPresenter alloc] init]);
            dispatcherMock = OCMClassMock([SDLNotificationDispatcher class]);

            testIcon = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        });

        it(@"should should set the vehicle icon on the default lockscreen if showDeviceLogo set to true", ^{
            testsConfig.showDeviceLogo = YES;

            OCMStub([fakeViewControllerPresenter lockViewController]).andReturn([[SDLLockScreenViewController alloc] init]);
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testsConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];

            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];

            expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).toEventually(equal(testIcon));
        });

        it(@"should should not set the vehicle icon on the default lockscreen if showDeviceLogo set to false", ^{
            testsConfig.showDeviceLogo = NO;
            OCMStub([fakeViewControllerPresenter lockViewController]).andReturn([[SDLLockScreenViewController alloc] init]);
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testsConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];

            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];

            expect(((SDLLockScreenViewController *)testManager.lockScreenViewController).vehicleIcon).toEventually(beNil());
        });

        it(@"should should not modify a custom lockscreen", ^{
            testsConfig.showDeviceLogo = YES;
            UIViewController *customLockScreen = [[UIViewController alloc] init];
            OCMStub([fakeViewControllerPresenter lockViewController]).andReturn(customLockScreen);
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testsConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];

            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:@{ SDLNotificationUserInfoObject: testIcon }];

            expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).lockViewController).toEventually(equal(customLockScreen));
        });
    });

    context(@"with a custom color configuration", ^{
        __block UIColor *testColor = nil;
        __block UIImage *testImage = nil;

        beforeEach(^{
            fakeViewControllerPresenter = OCMPartialMock([[SDLFakeViewControllerPresenter alloc] init]);
            dispatcherMock = OCMClassMock([SDLNotificationDispatcher class]);

            testColor = [UIColor blueColor];
            testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfigurationWithAppIcon:testImage backgroundColor:testColor] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });

        it(@"should set properties correctly", ^{
            expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).to(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });

        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });

            it(@"should set up the view controller correctly", ^{
                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
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
            fakeViewControllerPresenter = OCMPartialMock([[SDLFakeViewControllerPresenter alloc] init]);
            dispatcherMock = OCMClassMock([SDLNotificationDispatcher class]);

            testViewController = [[UIViewController alloc] init];
            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:[SDLLockScreenConfiguration enabledConfigurationWithViewController:testViewController] notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
        });

        it(@"should set properties correctly", ^{
            expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
            expect(testManager.lockScreenViewController).to(beNil());
        });

        describe(@"after it's started", ^{
            beforeEach(^{
                [testManager start];
            });

            it(@"should set up the view controller correctly", ^{
                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
                expect(testManager.lockScreenViewController).toNot(beNil());
                expect(testManager.lockScreenViewController).toNot(beAnInstanceOf([SDLLockScreenViewController class]));
                expect(testManager.lockScreenViewController).to(equal(testViewController));
            });
        });
    });

    context(@"with a dismissable false configuration", ^{
        beforeEach(^{
            fakeViewControllerPresenter = OCMPartialMock([[SDLFakeViewControllerPresenter alloc] init]);
            dispatcherMock = OCMClassMock([SDLNotificationDispatcher class]);

            SDLLockScreenConfiguration *config = [SDLLockScreenConfiguration enabledConfiguration];
            config.enableDismissGesture = NO;

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:config notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
            [testManager start];
        });

        describe(@"when a driver distraction notification is posted with lockScreenDismissableEnabled as true", ^{
            __block SDLRPCNotificationNotification *testDriverDistractionNotification = nil;

            beforeEach(^{
                SDLLockScreenStatusInfo *status = [[SDLLockScreenStatusInfo alloc] init];
                status.lockScreenStatus = SDLLockScreenStatusRequired;
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
        __block SDLLockScreenStatusInfo *testStatus = nil;

        beforeEach(^{
            fakeViewControllerPresenter = OCMPartialMock([[SDLFakeViewControllerPresenter alloc] init]);

            testStatus = [[SDLLockScreenStatusInfo alloc] init];
            SDLLockScreenConfiguration *config = [SDLLockScreenConfiguration enabledConfiguration];
            config.displayMode = SDLLockScreenConfigurationDisplayModeAlways;

            testManager = [[SDLLockScreenManager alloc] initWithConfiguration:config notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
            [testManager start];
        });

        context(@"receiving a lock screen status of required", ^{
            beforeEach(^{
                testStatus.lockScreenStatus = SDLLockScreenStatusRequired;

                OCMStub([fakeViewControllerPresenter lockViewController]).andReturn([[SDLLockScreenViewController alloc] init]);

                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager userInfo:@{SDLNotificationUserInfoObject: testStatus}];
            });

            it(@"should present the lock screen if not already presented", ^{
                OCMExpect([fakeViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:[OCMArg any]]);

                OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);

                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beTrue());
            });
        });

        context(@"receiving a lock screen status of off", ^{
            beforeEach(^{
                testStatus.lockScreenStatus = SDLLockScreenStatusOff;

                OCMStub([fakeViewControllerPresenter lockViewController]).andReturn([[SDLLockScreenViewController alloc] init]);

                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager userInfo:@{SDLNotificationUserInfoObject: testStatus}];
            });

            it(@"should present the lock screen if not already presented", ^{
                OCMExpect([fakeViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:[OCMArg any]]);

                OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);

                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beTrue());
            });
        });

        context(@"receiving a lock screen status of off after the user dismissed the lockscreen", ^{
            beforeEach(^{
                testStatus.lockScreenStatus = SDLLockScreenStatusOff;

                OCMStub([fakeViewControllerPresenter lockViewController]).andReturn([[SDLLockScreenViewController alloc] init]);

                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager userInfo:@{SDLNotificationUserInfoObject: testStatus}];
            });

            it(@"should not present the lock screen if it was already dismissed by the user", ^{
                testManager.lockScreenDismissedByUser = YES;

                OCMReject([fakeViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:[OCMArg any]]);

                OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);

                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beFalse());
            });

            it(@"should present the lock screen if it was already dismissed by the user but a new `OnDriverDistraction` notification with the `lockScreenDismissalEnabled` set to `false` is received", ^{
                testManager.canPresent = YES;
                testManager.lockScreenDismissedByUser = YES;

                SDLOnDriverDistraction *testLastDriverDistractionNotification = [[SDLOnDriverDistraction alloc] init];
                testLastDriverDistractionNotification.lockScreenDismissalEnabled = @NO;
                testLastDriverDistractionNotification.state = SDLDriverDistractionStateOn;
                testManager.lastDriverDistractionNotification = testLastDriverDistractionNotification;

                OCMExpect([fakeViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:[OCMArg any]]);

                OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);

                expect(((SDLFakeViewControllerPresenter *)fakeViewControllerPresenter).shouldShowLockScreen).toEventually(beTrue());

                expect(testManager.lockScreenDismissable).to(beFalse());
            });
        });
    });

    describe(@"A lock screen status of OPTIONAL", ^{
        __block SDLLockScreenConfiguration *testLockScreenConfig = nil;
        __block SDLLockScreenStatusInfo *testOptionalStatus;

        beforeEach(^{
            fakeViewControllerPresenter = OCMClassMock([SDLFakeViewControllerPresenter class]);
            testLockScreenConfig = [SDLLockScreenConfiguration enabledConfiguration];

            testOptionalStatus = [[SDLLockScreenStatusInfo alloc] init];
            testOptionalStatus.lockScreenStatus = SDLLockScreenStatusOptional;
        });

        context(@"displayMode is set to always show the lockscreen", ^{
            beforeEach(^{
                testLockScreenConfig.displayMode = SDLLockScreenConfigurationDisplayModeOptionalOrRequired;
                testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testLockScreenConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
                testManager.canPresent = YES;
            });

            it(@"should present the lock screen if not already presented", ^{
                OCMStub([fakeViewControllerPresenter lockViewController]).andReturn([OCMArg any]);
                OCMExpect([fakeViewControllerPresenter updateLockScreenToShow:YES withCompletionHandler:[OCMArg any]]).ignoringNonObjectArgs();

                 [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager userInfo:@{SDLNotificationUserInfoObject: testOptionalStatus}];

                OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);
            });

            it(@"should set lockScreenDismissedByUser to `false`", ^{
                testManager.canPresent = YES;
                testManager.lockScreenDismissedByUser = YES;

                SDLOnDriverDistraction *testLastDriverDistractionNotification = [[SDLOnDriverDistraction alloc] init];
                testLastDriverDistractionNotification.lockScreenDismissalEnabled = @NO;
                testLastDriverDistractionNotification.state = SDLDriverDistractionStateOn;
                testManager.lastDriverDistractionNotification = testLastDriverDistractionNotification;

                [testManager sdl_updateLockScreenDismissable];
                expect(testManager.lockScreenDismissedByUser).to(equal(NO));
            });
        });

        context(@"displayMode is set to never show the lockscreen", ^{
            beforeEach(^{
                testLockScreenConfig.displayMode = SDLLockScreenConfigurationDisplayModeNever;
                testManager = [[SDLLockScreenManager alloc] initWithConfiguration:testLockScreenConfig notificationDispatcher:dispatcherMock presenter:fakeViewControllerPresenter];
                testManager.canPresent = YES;
            });

            it(@"should dismiss the lock screen if already presented", ^{
                OCMStub([fakeViewControllerPresenter lockViewController]).andReturn([OCMArg any]);
                OCMExpect([fakeViewControllerPresenter updateLockScreenToShow:NO withCompletionHandler:[OCMArg any]]).ignoringNonObjectArgs();

                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidChangeLockScreenStatusNotification object:testManager.statusManager userInfo:@{SDLNotificationUserInfoObject: testOptionalStatus}];

                OCMVerifyAllWithDelay(fakeViewControllerPresenter, 0.5);
            });
        });
    });
});

QuickSpecEnd
