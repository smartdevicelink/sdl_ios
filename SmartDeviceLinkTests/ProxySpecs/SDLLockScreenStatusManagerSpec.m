//
//  SDLLockScreenStatusManagerSpec
//  SmartDeviceLink-iOS

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLOnDriverDistraction.h"
#import "SDLHMILevel.h"
#import "SDLLockScreenStatusManager.h"
#import "SDLLockScreenStatus.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLRPCNotificationNotification.h"


QuickSpecBegin(SDLLockScreenStatusManagerSpec)

describe(@"the lockscreen status manager", ^{
    __block SDLLockScreenStatusManager *testManager;
    __block SDLNotificationDispatcher *mockDispatcher;

    beforeEach(^{
        mockDispatcher = OCMClassMock([SDLNotificationDispatcher class]);
        testManager = [[SDLLockScreenStatusManager alloc] initWithNotificationDispatcher:mockDispatcher];
    });
    
    it(@"should properly initialize user selected app boolean to false", ^{
        expect(@(testManager.userSelected)).to(beFalse());
    });
    
    it(@"should properly initialize driver is distracted boolean to false", ^{
        expect(@(testManager.driverDistracted)).to(beFalse());
    });
    
    it(@"should properly initialize hmi level object to nil", ^{
        expect(testManager.hmiLevel).to(beNil());
    });
    
    describe(@"when setting HMI level", ^{
        context(@"to FULL", ^{
            beforeEach(^{
                testManager.userSelected = NO;
                testManager.hmiLevel = SDLHMILevelFull;
            });
            
            it(@"should set user selected to true", ^{
                expect(@(testManager.userSelected)).to(beTrue());
            });
        });
        
        context(@"to LIMITED", ^{
            beforeEach(^{
                testManager.userSelected = NO;
                testManager.hmiLevel = SDLHMILevelLimited;
            });
            
            it(@"should set user selected to true", ^{
                expect(@(testManager.userSelected)).to(beTrue());
            });
        });
        
        context(@"to BACKGROUND", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelBackground;
            });
            
            context(@"when user selected is false", ^{
                beforeEach(^{
                    testManager.userSelected = NO;
                });
                
                it(@"should not alter the value", ^{
                    expect(@(testManager.userSelected)).to(beFalse());
                });
            });
            
            context(@"when user selected is true", ^{
                beforeEach(^{
                    testManager.userSelected = YES;
                });
                
                it(@"should not alter the value", ^{
                    expect(@(testManager.userSelected)).to(beTrue());
                });
            });
        });
        
        context(@"to NONE", ^{
            beforeEach(^{
                testManager.userSelected = YES;
                testManager.hmiLevel = SDLHMILevelNone;
            });
            
            it(@"should set user selected to false", ^{
                expect(@(testManager.userSelected)).to(beFalse());
            });
        });
    });
    
    describe(@"when getting lock screen status", ^{
        context(@"when HMI level is nil", ^{
            beforeEach(^{
                testManager.hmiLevel = nil;
            });
            
            it(@"should return lock screen off", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusOff));
#pragma clang diagnostic pop
            });
        });
        
        context(@"when HMI level is NONE", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelNone;
            });
            
            it(@"should return lock screen off", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusOff));
#pragma clang diagnostic pop
            });
        });
        
        context(@"when HMI level is BACKGROUND", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelBackground;
            });
            
            context(@"when user selected is true", ^{
                beforeEach(^{
                    testManager.userSelected = YES;
                });

                context(@"if we do not set the driver distraction state", ^{
                    it(@"should return lock screen required", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
#pragma clang diagnostic pop
                    });
                });

                context(@"if we set the driver distraction state to false", ^{
                    beforeEach(^{
                        testManager.driverDistracted = NO;
                    });

                    it(@"should return lock screen optional", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusOptional));
#pragma clang diagnostic pop
                    });
                });

                context(@"if we set the driver distraction state to true", ^{
                    beforeEach(^{
                        testManager.driverDistracted = YES;
                    });

                    it(@"should return lock screen required", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
#pragma clang diagnostic pop
                    });
                });
            });
            
            context(@"when user selected is false", ^{
                beforeEach(^{
                    testManager.userSelected = NO;
                });
                
                it(@"should return lock screen off", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusOff));
#pragma clang diagnostic pop
                });
            });
        });
        
        context(@"when HMI level is LIMITED", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelLimited;
            });
            
            context(@"if we do not set the driver distraction state", ^{
                it(@"should return lock screen required", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
#pragma clang diagnostic pop
                });
            });
            
            context(@"if we set the driver distraction state to false", ^{
                beforeEach(^{
                    testManager.driverDistracted = NO;
                });
                
                it(@"should return lock screen optional", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusOptional));
#pragma clang diagnostic pop
                });
            });
            
            context(@"if we set the driver distraction state to true", ^{
                beforeEach(^{
                    testManager.driverDistracted = YES;
                });
                
                it(@"should return lock screen required", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
#pragma clang diagnostic pop
                });
            });
        });
        
        context(@"when HMI level is FULL", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelFull;
            });
            
            context(@"if we do not set the driver distraction state", ^{
                it(@"should return lock screen required", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
#pragma clang diagnostic pop
                });
            });
            
            context(@"if we set the driver distraction state to false", ^{
                beforeEach(^{
                    testManager.driverDistracted = NO;
                });
                
                it(@"should return lock screen optional", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusOptional));
#pragma clang diagnostic pop
                });
            });
            
            context(@"if we set the driver distraction state to true", ^{
                beforeEach(^{
                    testManager.driverDistracted = YES;
                });
                
                it(@"should return lock screen required", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testManager.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
#pragma clang diagnostic pop
                });
            });
        });
    });
    
    describe(@"when sending a lock screen status notification", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        __block SDLOnLockScreenStatus *onLockScreenStatusNotification = nil;
#pragma clang diagnostic pop
        
        beforeEach(^{
            testManager.userSelected = YES;
            testManager.driverDistracted = NO;
            testManager.hmiLevel = SDLHMILevelLimited;
            
            onLockScreenStatusNotification = testManager.lockScreenStatusNotification;
        });
        
        it(@"should properly return user selected", ^{
            expect(onLockScreenStatusNotification.userSelected).to(beTrue());
        });
        
        it(@"should properly return driver distraction status", ^{
            expect(onLockScreenStatusNotification.driverDistractionStatus).to(beFalse());
        });
        
        it(@"should properly return HMI level", ^{
            expect(onLockScreenStatusNotification.hmiLevel).to(equal(SDLHMILevelLimited));
        });
        
        it(@"should properly return lock screen status", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(onLockScreenStatusNotification.lockScreenStatus).to(equal(SDLLockScreenStatusOptional));
#pragma clang diagnostic pop
        });
    });

    describe(@"when receiving an HMI status", ^{
        __block id lockScreenIconObserver = nil;
        beforeEach(^{
            SDLOnHMIStatus *hmiStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:SDLHMILevelFull systemContext:SDLSystemContextMain audioStreamingState:SDLAudioStreamingStateAudible videoStreamingState:nil windowID:nil];
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:mockDispatcher rpcNotification:hmiStatus];

            lockScreenIconObserver = OCMObserverMock();
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[NSNotificationCenter defaultCenter] addMockObserver:lockScreenIconObserver name:SDLDidChangeLockScreenStatusNotification object:testManager];
            [[lockScreenIconObserver expect] notificationWithName:SDLDidChangeLockScreenStatusNotification object:[OCMArg any] userInfo:[OCMArg any]];
#pragma clang diagnostic pop

            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should update the driver distraction status and send a notification", ^{
            expect(testManager.hmiLevel).to(equal(SDLHMILevelFull));
            OCMVerifyAll(lockScreenIconObserver);
        });
    });

    describe(@"when receiving a driver distraction status", ^{
        __block id lockScreenIconObserver = nil;
        beforeEach(^{
            SDLOnDriverDistraction *driverDistraction = [[SDLOnDriverDistraction alloc] init];
            driverDistraction.state = SDLDriverDistractionStateOn;
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeDriverDistractionStateNotification object:mockDispatcher rpcNotification:driverDistraction];

            lockScreenIconObserver = OCMObserverMock();
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[NSNotificationCenter defaultCenter] addMockObserver:lockScreenIconObserver name:SDLDidChangeLockScreenStatusNotification object:testManager];
            [[lockScreenIconObserver expect] notificationWithName:SDLDidChangeLockScreenStatusNotification object:[OCMArg any] userInfo:[OCMArg any]];
#pragma clang diagnostic pop

            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should update the driver distraction status and send a notification", ^{
            expect(testManager.driverDistracted).to(beTrue());
            OCMVerifyAll(lockScreenIconObserver);
        });
    });
});

QuickSpecEnd
