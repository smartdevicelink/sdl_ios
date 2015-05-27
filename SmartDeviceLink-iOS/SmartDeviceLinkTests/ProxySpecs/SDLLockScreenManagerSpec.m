//
//  SDLHexUtilitySpec.m
//  SmartDeviceLink-iOS

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMILevel.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenStatus.h"


QuickSpecBegin(SDLLockScreenManagerSpec)

describe(@"the lockscreen manager", ^{
    __block SDLLockScreenManager *lockScreenManager;
    beforeEach(^{
        lockScreenManager = [[SDLLockScreenManager alloc] init];
    });
    
    it(@"should properly initialize user selected app boolean to false", ^{
        expect(@(lockScreenManager.bUserSelected)).to(beFalse());
    });
    
    it(@"should properly initialize driver is distracted boolean to false", ^{
        expect(@(lockScreenManager.bDriverDistractionStatus)).to(beFalse());
    });
    
    it(@"should properly initialize hmi level object to nil", ^{
        expect(lockScreenManager.hmiLevel).to(beNil());
    });
    
    describe(@"when setting HMI level", ^{
        context(@"to FULL", ^{
            beforeEach(^{
                lockScreenManager.bUserSelected = NO;
                lockScreenManager.hmiLevel = [SDLHMILevel FULL];
            });
            
            it(@"should set user selected to true", ^{
                expect(@(lockScreenManager.bUserSelected)).to(beTrue());
            });
        });
        
        context(@"to LIMITED", ^{
            beforeEach(^{
                lockScreenManager.bUserSelected = NO;
                lockScreenManager.hmiLevel = [SDLHMILevel LIMITED];
            });
            
            it(@"should set user selected to true", ^{
                expect(@(lockScreenManager.bUserSelected)).to(beTrue());
            });
        });
        
        context(@"to BACKGROUND", ^{
            beforeEach(^{
                lockScreenManager.hmiLevel = [SDLHMILevel BACKGROUND];
            });
            
            context(@"when user selected is false", ^{
                beforeEach(^{
                    lockScreenManager.bUserSelected = NO;
                });
                
                it(@"should not alter the value", ^{
                    expect(@(lockScreenManager.bUserSelected)).to(beFalse());
                });
            });
            
            context(@"when user selected is true", ^{
                beforeEach(^{
                    lockScreenManager.bUserSelected = YES;
                });
                
                it(@"should not alter the value", ^{
                    expect(@(lockScreenManager.bUserSelected)).to(beTrue());
                });
            });
        });
        
        context(@"to NONE", ^{
            beforeEach(^{
                lockScreenManager.bUserSelected = YES;
                lockScreenManager.hmiLevel = [SDLHMILevel NONE];
            });
            
            it(@"should set user selected to false", ^{
                expect(@(lockScreenManager.bUserSelected)).to(beFalse());
            });
        });
    });
    
    describe(@"when getting lock screen status", ^{
        context(@"when HMI level is nil", ^{
            beforeEach(^{
                lockScreenManager.hmiLevel = nil;
            });
            
            it(@"should return lock screen off", ^{
                expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus OFF]));
            });
        });
        
        context(@"when HMI level is NONE", ^{
            beforeEach(^{
                lockScreenManager.hmiLevel = [SDLHMILevel NONE];
            });
            
            it(@"should return lock screen off", ^{
                expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus OFF]));
            });
        });
        
        context(@"when HMI level is BACKGROUND", ^{
            beforeEach(^{
                lockScreenManager.hmiLevel = [SDLHMILevel BACKGROUND];
            });
            
            context(@"when user selected is true", ^{
                beforeEach(^{
                    lockScreenManager.bUserSelected = YES;
                });
                
                it(@"should return lock screen required", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus REQUIRED]));
                });
            });
            
            context(@"when user selected is false", ^{
                beforeEach(^{
                    lockScreenManager.bUserSelected = NO;
                });
                
                it(@"should return lock screen off", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus OFF]));
                });
            });
        });
        
        context(@"when HMI level is LIMITED", ^{
            beforeEach(^{
                lockScreenManager.hmiLevel = [SDLHMILevel LIMITED];
            });
            
            context(@"if we do not set the driver distraction state", ^{
                it(@"should return lock screen required", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus REQUIRED]));
                });
            });
            
            context(@"if we set the driver distraction state to false", ^{
                beforeEach(^{
                    lockScreenManager.bDriverDistractionStatus = NO;
                });
                
                it(@"should return lock screen optional", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus OPTIONAL]));
                });
            });
            
            context(@"if we set the driver distraction state to true", ^{
                beforeEach(^{
                    lockScreenManager.bDriverDistractionStatus = YES;
                });
                
                it(@"should return lock screen required", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus REQUIRED]));
                });
            });
        });
        
        context(@"when HMI level is FULL", ^{
            beforeEach(^{
                lockScreenManager.hmiLevel = [SDLHMILevel FULL];
            });
            
            context(@"if we do not set the driver distraction state", ^{
                it(@"should return lock screen required", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus REQUIRED]));
                });
            });
            
            context(@"if we set the driver distraction state to false", ^{
                beforeEach(^{
                    lockScreenManager.bDriverDistractionStatus = NO;
                });
                
                it(@"should return lock screen optional", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus OPTIONAL]));
                });
            });
            
            context(@"if we set the driver distraction state to true", ^{
                beforeEach(^{
                    lockScreenManager.bDriverDistractionStatus = YES;
                });
                
                it(@"should return lock screen required", ^{
                    expect(lockScreenManager.lockScreenStatus).to(equal([SDLLockScreenStatus REQUIRED]));
                });
            });
        });
    });
    
    describe(@"when getting lock screen status notification", ^{
        __block SDLOnLockScreenStatus *onLockScreenStatusNotification = nil;
        beforeEach(^{
            lockScreenManager.bUserSelected = YES;
            lockScreenManager.bDriverDistractionStatus = NO;
            lockScreenManager.hmiLevel = [SDLHMILevel LIMITED];
            
            onLockScreenStatusNotification = lockScreenManager.lockScreenStatusNotification;
        });
        
        it(@"should properly return user selected", ^{
            expect(onLockScreenStatusNotification.userSelected).to(beTrue());
        });
        
        it(@"should properly return driver distraction status", ^{
            expect(onLockScreenStatusNotification.driverDistractionStatus).to(beFalse());
        });
        
        it(@"should properly return HMI level", ^{
            expect(onLockScreenStatusNotification.hmiLevel).to(equal([SDLHMILevel LIMITED]));
        });
        
        it(@"should properly return lock screen status", ^{
            expect(onLockScreenStatusNotification.lockScreenStatus).to(equal([SDLLockScreenStatus OPTIONAL]));
        });
    });
});

QuickSpecEnd
