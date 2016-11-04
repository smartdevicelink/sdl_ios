
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMILevel.h"
#import "SDLHMIPermissions.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnPermissionsChange.h"
#import "SDLParameterPermissions.h"
#import "SDLPermissionItem.h"
#import "SDLPermissionManager.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"

QuickSpecBegin(SDLPermissionsManagerSpec)

describe(@"SDLPermissionsManager", ^{
    __block SDLPermissionManager *testPermissionsManager = nil;
    
    __block NSString *testRPCNameAllAllowed = nil;
    __block NSString *testRPCNameAllDisallowed = nil;
    __block NSString *testRPCNameFullLimitedAllowed = nil;
    __block NSString *testRPCNameFullLimitedBackgroundAllowed = nil;
    
    __block SDLPermissionItem *testPermissionAllAllowed = nil;
    __block SDLHMIPermissions *testHMIPermissionsAllAllowed = nil;
    __block SDLPermissionItem *testPermissionAllDisallowed = nil;
    __block SDLHMIPermissions *testHMIPermissionsAllDisallowed = nil;
    __block SDLPermissionItem *testPermissionFullLimitedAllowed = nil;
    __block SDLHMIPermissions *testHMIPermissionsFullLimitedAllowed = nil;
    __block SDLPermissionItem *testPermissionFullLimitedBackgroundAllowed = nil;
    __block SDLHMIPermissions *testHMIPermissionsFullLimitedBackgroundAllowed = nil;
    
    __block SDLOnPermissionsChange *testPermissionsChange = nil;
    
    __block SDLOnHMIStatus *testLimitedHMIStatus = nil;
    __block SDLOnHMIStatus *testBackgroundHMIStatus = nil;
    __block SDLOnHMIStatus *testNoneHMIStatus = nil;
    
    __block SDLRPCNotificationNotification *testPermissionsNotification = nil;
    __block SDLRPCNotificationNotification *limitedHMINotification = nil;
    __block SDLRPCNotificationNotification *backgroundHMINotification = nil;
    __block SDLRPCNotificationNotification *noneHMINotification = nil;
    
    beforeEach(^{
        // Permission Names
        testRPCNameAllAllowed = @"AllAllowed";
        testRPCNameAllDisallowed = @"AllDisallowed";
        testRPCNameFullLimitedAllowed = @"FullAndLimitedAllowed";
        testRPCNameFullLimitedBackgroundAllowed = @"FullAndLimitedAndBackgroundAllowed";
        
        // Create a manager
        testPermissionsManager = [[SDLPermissionManager alloc] init];
        
        // Permission states
        testHMIPermissionsAllAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsAllAllowed.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
        
        testHMIPermissionsAllDisallowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsAllDisallowed.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
        
        testHMIPermissionsFullLimitedAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsFullLimitedAllowed.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel FULL], [SDLHMILevel LIMITED]]];
        testHMIPermissionsFullLimitedAllowed.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel NONE]]];
        
        testHMIPermissionsFullLimitedBackgroundAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsFullLimitedBackgroundAllowed.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel BACKGROUND]]];
        testHMIPermissionsFullLimitedBackgroundAllowed.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel NONE]]];
        
        // Assemble Permissions
        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
        
        testPermissionAllAllowed = [[SDLPermissionItem alloc] init];
        testPermissionAllAllowed.rpcName = testRPCNameAllAllowed;
        testPermissionAllAllowed.hmiPermissions = testHMIPermissionsAllAllowed;
        testPermissionAllAllowed.parameterPermissions = testParameterPermissions;
        
        testPermissionAllDisallowed = [[SDLPermissionItem alloc] init];
        testPermissionAllDisallowed.rpcName = testRPCNameAllDisallowed;
        testPermissionAllDisallowed.hmiPermissions = testHMIPermissionsAllDisallowed;
        testPermissionAllDisallowed.parameterPermissions = testParameterPermissions;
        
        testPermissionFullLimitedAllowed = [[SDLPermissionItem alloc] init];
        testPermissionFullLimitedAllowed.rpcName = testRPCNameFullLimitedAllowed;
        testPermissionFullLimitedAllowed.hmiPermissions = testHMIPermissionsFullLimitedAllowed;
        testPermissionFullLimitedAllowed.parameterPermissions = testParameterPermissions;
        
        testPermissionFullLimitedBackgroundAllowed = [[SDLPermissionItem alloc] init];
        testPermissionFullLimitedBackgroundAllowed.rpcName = testRPCNameFullLimitedBackgroundAllowed;
        testPermissionFullLimitedBackgroundAllowed.hmiPermissions = testHMIPermissionsFullLimitedBackgroundAllowed;
        testPermissionFullLimitedBackgroundAllowed.parameterPermissions = testParameterPermissions;
        
        // Create OnHMIStatus objects
        testLimitedHMIStatus = [[SDLOnHMIStatus alloc] init];
        testLimitedHMIStatus.hmiLevel = [SDLHMILevel LIMITED];
        
        testBackgroundHMIStatus = [[SDLOnHMIStatus alloc] init];
        testBackgroundHMIStatus.hmiLevel = [SDLHMILevel BACKGROUND];
        
        testNoneHMIStatus = [[SDLOnHMIStatus alloc] init];
        testNoneHMIStatus.hmiLevel = [SDLHMILevel NONE];
        
        // Create OnPermissionsChange object
        testPermissionsChange = [[SDLOnPermissionsChange alloc] init];
        testPermissionsChange.permissionItem = [NSMutableArray arrayWithArray:@[testPermissionAllAllowed, testPermissionAllDisallowed, testPermissionFullLimitedAllowed, testPermissionFullLimitedBackgroundAllowed]];
        
        // Permission Notifications
        testPermissionsNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangePermissionsNotification object:nil rpcNotification:testPermissionsChange];
        limitedHMINotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testLimitedHMIStatus];
        backgroundHMINotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testBackgroundHMIStatus];
        noneHMINotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testNoneHMIStatus];
    });
    
    describe(@"checking if a permission is allowed", ^{
        __block NSString *someRPCName = nil;
        __block BOOL testResultBOOL = NO;
        
        context(@"when no permissions exist", ^{
            beforeEach(^{
                someRPCName = @"some rpc name";
                
                testResultBOOL = [testPermissionsManager isRPCAllowed:someRPCName];
            });
            
            it(@"should not be allowed", ^{
                expect(@(testResultBOOL)).to(equal(@NO));
            });
        });
        
        context(@"when permissions exist but no HMI level", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                testResultBOOL = [testPermissionsManager isRPCAllowed:testRPCNameAllAllowed];
            });
            
            it(@"should not be allowed", ^{
                expect(@(testResultBOOL)).to(equal(@NO));
            });
        });
        
        context(@"when permissions exist", ^{
            context(@"and the permission is allowed", ^{
                beforeEach(^{
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    testResultBOOL = [testPermissionsManager isRPCAllowed:testRPCNameAllAllowed];
                });
                
                it(@"should be allowed", ^{
                    expect(@(testResultBOOL)).to(equal(@YES));
                });
            });
            
            context(@"and the permission is denied", ^{
                beforeEach(^{
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    testResultBOOL = [testPermissionsManager isRPCAllowed:testRPCNameAllDisallowed];
                });
                
                it(@"should be denied", ^{
                    expect(@(testResultBOOL)).to(equal(@NO));
                });
            });
        });
    });
    
    describe(@"checking the group status of RPCs", ^{
        __block SDLPermissionGroupStatus testResultStatus = SDLPermissionGroupStatusUnknown;
        
        context(@"with no permissions data", ^{
            beforeEach(^{
                testResultStatus = [testPermissionsManager groupStatusOfRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed]];
            });
            
            it(@"should return unknown", ^{
                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusUnknown)));
            });
        });
        
        context(@"for an all allowed group", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                testResultStatus = [testPermissionsManager groupStatusOfRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed]];
            });
            
            it(@"should return mixed", ^{
                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusAllowed)));
            });
        });
        
        context(@"for an all disallowed group", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                testResultStatus = [testPermissionsManager groupStatusOfRPCs:@[testRPCNameFullLimitedAllowed, testRPCNameAllDisallowed]];
            });
            
            it(@"should return mixed", ^{
                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusDisallowed)));
            });
        });
        
        context(@"for a mixed group", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                testResultStatus = [testPermissionsManager groupStatusOfRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed]];
            });
            
            it(@"should return mixed", ^{
                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusMixed)));
            });
        });
    });
    
    describe(@"checking the status of RPCs", ^{
        __block NSDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> *testResultPermissionStatusDict = nil;
        
        context(@"with no permissions data", ^{
            beforeEach(^{
                testResultPermissionStatusDict = [testPermissionsManager statusOfRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed]];
            });
            
            it(@"should return correct permission statuses", ^{
                expect(testResultPermissionStatusDict[testRPCNameAllAllowed]).to(equal(@NO));
                expect(testResultPermissionStatusDict[testRPCNameAllDisallowed]).to(equal(@NO));
            });
        });
        
        context(@"with permissions data", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                testResultPermissionStatusDict = [testPermissionsManager statusOfRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed]];
            });
            
            it(@"should return correct permission statuses", ^{
                expect(testResultPermissionStatusDict[testRPCNameAllAllowed]).to(equal(@YES));
                expect(testResultPermissionStatusDict[testRPCNameAllDisallowed]).to(equal(@NO));
            });
        });
    });
    
    describe(@"adding and using observers", ^{
        describe(@"adding new observers", ^{
            context(@"when no data is present", ^{
                __block BOOL testObserverCalled = NO;
                __block SDLPermissionGroupStatus testObserverStatus = SDLPermissionGroupStatusUnknown;
                __block NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> *testObserverChangeDict = nil;
                
                beforeEach(^{
                    testObserverCalled = NO;
                    testObserverStatus = SDLPermissionGroupStatusUnknown;
                    testObserverChangeDict = nil;
                    
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
                        testObserverChangeDict = change;
                        testObserverStatus = status;
                        testObserverCalled = YES;
                    }];
                });
                
                it(@"should return correct permission statuses", ^{
                    expect(@(testObserverCalled)).to(equal(@YES));
                    expect(@(testObserverStatus)).to(equal(@(SDLPermissionGroupStatusUnknown)));
                    expect(testObserverChangeDict[testRPCNameAllAllowed]).to(equal(@NO));
                    expect(testObserverChangeDict[testRPCNameAllDisallowed]).to(equal(@NO));
                });
            });
            
            context(@"when data is already present", ^{
                __block NSInteger numberOfTimesObserverCalled = 0;
                __block NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> *testObserverBlockChangedDict = nil;
                __block SDLPermissionGroupStatus testObserverReturnStatus = SDLPermissionGroupStatusUnknown;
                
                context(@"to match an ANY observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = changedDict;
                            testObserverReturnStatus = status;
                        }];
                    });
                    
                    it(@"should call the observer with proper status", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                        expect(testObserverBlockChangedDict[testRPCNameAllAllowed]).to(equal(@YES));
                        expect(testObserverBlockChangedDict[testRPCNameAllDisallowed]).to(equal(@NO));
                        expect(testObserverBlockChangedDict.allKeys).to(haveCount(@2));
                        expect(@(testObserverReturnStatus)).to(equal(@(SDLPermissionGroupStatusMixed)));
                    });
                });
                
                context(@"to match an all allowed observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level LIMITED
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = change;
                            testObserverReturnStatus = status;
                        }];
                    });
                    
                    it(@"should call the observer with proper status", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                        expect(testObserverBlockChangedDict[testRPCNameAllAllowed]).to(equal(@YES));
                        expect(testObserverBlockChangedDict[testRPCNameFullLimitedAllowed]).to(equal(@YES));
                        expect(testObserverBlockChangedDict.allKeys).to(haveCount(@2));
                        expect(@(testObserverReturnStatus)).to(equal(@(SDLPermissionGroupStatusAllowed)));
                    });
                });
                
                context(@"that does not match an all allowed observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level NONE
                        [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllDisallowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverReturnStatus = status;
                        }];
                    });
                    
                    it(@"should call the observer with status Disallowed", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                        expect(@(testObserverReturnStatus)).to(equal(@(SDLPermissionGroupStatusDisallowed)));
                    });
                });
            });
        });
        
        context(@"updating an observer with new permission data", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            
            __block SDLOnPermissionsChange *testPermissionChangeUpdate = nil;
            __block SDLPermissionItem *testPermissionUpdated = nil;
            __block NSMutableArray<NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> *> *changeDicts = nil;
            __block NSMutableArray<NSNumber<SDLUInt> *> *testStatuses = nil;
            
            context(@"to match an ANY observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    testStatuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:changedDict];
                    }];
                    
                    // Create a permission update disallowing our current HMI level for the observed permission
                    SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                    SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                    testHMIPermissionsUpdated.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]]];
                    testHMIPermissionsUpdated.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
                    
                    testPermissionUpdated = [[SDLPermissionItem alloc] init];
                    testPermissionUpdated.rpcName = testRPCNameAllAllowed;
                    testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                    testPermissionUpdated.parameterPermissions = testParameterPermissions;
                    
                    testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                    testPermissionChangeUpdate.permissionItem = [NSMutableArray arrayWithObject:testPermissionUpdated];
                    
                    // Send the permission update
                    NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoObject: testPermissionChangeUpdate}];
                    [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                });
                
                it(@"should call the observer twice", ^{
                    expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                });
                
                it(@"should have proper data in the first change dict", ^{
                    expect(changeDicts[0].allKeys).to(contain(testRPCNameAllAllowed));
                    expect(changeDicts[0].allKeys).to(contain(testRPCNameAllDisallowed));
                    
                    NSNumber<SDLBool> *allAllowed = changeDicts[0][testRPCNameAllAllowed];
                    expect(allAllowed).to(equal(@YES));
                    
                    NSNumber<SDLBool> *allDisallowed = changeDicts[0][testRPCNameAllDisallowed];
                    expect(allDisallowed).to(equal(@NO));
                });
                
                it(@"should have the proper data in the second change dict", ^{
                    expect(changeDicts[1].allKeys).to(contain(testRPCNameAllAllowed));
                    expect(changeDicts[1].allKeys).to(contain(testRPCNameAllDisallowed));
                    
                    NSNumber<SDLBool> *allAllowed = changeDicts[1][testRPCNameAllAllowed];
                    expect(allAllowed).to(equal(@NO));
                    
                    NSNumber<SDLBool> *allDisallowed = changeDicts[1][testRPCNameAllDisallowed];
                    expect(allDisallowed).to(equal(@NO));
                });
            });
            
            context(@"to match an all allowed observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    testStatuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });
                
                context(@"so that it becomes All Allowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllDisallowed, testRPCNameFullLimitedBackgroundAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:change];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        // Create a permission update allowing our current HMI level for the observed permission
                        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                        SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                        testHMIPermissionsUpdated.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel LIMITED], [SDLHMILevel NONE], [SDLHMILevel BACKGROUND], [SDLHMILevel FULL]]];
                        testHMIPermissionsUpdated.userDisallowed = [NSMutableArray arrayWithArray:@[]];
                        
                        testPermissionUpdated = [[SDLPermissionItem alloc] init];
                        testPermissionUpdated.rpcName = testRPCNameAllDisallowed;
                        testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                        testPermissionUpdated.parameterPermissions = testParameterPermissions;
                        
                        testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                        testPermissionChangeUpdate.permissionItem = [NSMutableArray arrayWithObject:testPermissionUpdated];
                        
                        // Send the permission update
                        NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoObject: testPermissionChangeUpdate}];
                        [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                    });
                    
                    it(@"should call the observer twice", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                    });
                    
                    it(@"should have proper data in the first change dict", ^{
                        expect(changeDicts[0].allKeys).to(haveCount(@2));
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusMixed)));
                    });
                    
                    it(@"should have the proper data in the second change dict", ^{
                        expect(changeDicts[1].allKeys).to(haveCount(@2));
                        expect(testStatuses[1]).to(equal(@(SDLPermissionGroupStatusAllowed)));
                    });
                });
                
                context(@"so that it goes from All Allowed to mixed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:change];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        // Create a permission update disallowing our current HMI level for the observed permission
                        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                        SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                        testHMIPermissionsUpdated.allowed = [NSMutableArray arrayWithArray:@[]];
                        testHMIPermissionsUpdated.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
                        
                        testPermissionUpdated = [[SDLPermissionItem alloc] init];
                        testPermissionUpdated.rpcName = testRPCNameAllAllowed;
                        testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                        testPermissionUpdated.parameterPermissions = testParameterPermissions;
                        
                        testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                        testPermissionChangeUpdate.permissionItem = [NSMutableArray arrayWithObject:testPermissionUpdated];
                        
                        // Send the permission update
                        NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoObject: testPermissionChangeUpdate}];
                        [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                    });
                    
                    it(@"should call the observer twice", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                    });
                    
                    it(@"should have proper data in the first change dict", ^{
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusAllowed)));
                        expect(changeDicts[0].allKeys).to(contain(testRPCNameAllAllowed));
                        
                        NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameAllAllowed];
                        expect(isAllowed).to(equal(@YES));
                    });
                    
                    it(@"should have the proper data in the second change dict", ^{
                        expect(testStatuses[1]).to(equal(@(SDLPermissionGroupStatusDisallowed)));
                        expect(changeDicts[1].allKeys).to(contain(testRPCNameAllAllowed));
                        
                        NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameAllAllowed];
                        expect(isAllowed).to(equal(@NO));
                    });
                });
            });
            
            context(@"to not match an all allowed observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    testStatuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });
                
                context(@"from mixed to disallowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:change];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        // Create a permission update disallowing our current HMI level for the observed permission
                        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                        SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                        testHMIPermissionsUpdated.allowed = [NSMutableArray arrayWithArray:@[]];
                        testHMIPermissionsUpdated.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
                        
                        testPermissionUpdated = [[SDLPermissionItem alloc] init];
                        testPermissionUpdated.rpcName = testRPCNameAllAllowed;
                        testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                        testPermissionUpdated.parameterPermissions = testParameterPermissions;
                        
                        testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                        testPermissionChangeUpdate.permissionItem = [NSMutableArray arrayWithObject:testPermissionUpdated];
                        
                        // Send the permission update
                        NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoObject: testPermissionChangeUpdate}];
                        [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                    });
                    
                    it(@"should call the observer with a mixed status", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusMixed)));
                    });
                });
                
                context(@"from disallowed to mixed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:change];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        // Create a permission update disallowing our current HMI level for the observed permission
                        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                        SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                        testHMIPermissionsUpdated.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel LIMITED], [SDLHMILevel BACKGROUND]]];
                        testHMIPermissionsUpdated.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel FULL], [SDLHMILevel NONE]]];
                        
                        testPermissionUpdated = [[SDLPermissionItem alloc] init];
                        testPermissionUpdated.rpcName = testRPCNameAllAllowed;
                        testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                        testPermissionUpdated.parameterPermissions = testParameterPermissions;
                        
                        testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                        testPermissionChangeUpdate.permissionItem = [NSMutableArray arrayWithObject:testPermissionUpdated];
                        
                        // Send the permission update
                        NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoObject: testPermissionChangeUpdate}];
                        [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                    });
                    
                    it(@"should call the observer", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusDisallowed)));
                    });
                });
            });
        });
        
        context(@"updating an observer with a new HMI level", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            __block NSMutableArray<NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> *> *changeDicts = nil;
            __block NSMutableArray<NSNumber<SDLUInt> *> *testStatuses = nil;
            
            context(@"to match an ANY observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    testStatuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:changedDict];
                        [testStatuses addObject:@(status)];
                    }];
                    
                    // Upgrade the HMI level to LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                });
                
                it(@"should call the observer twice", ^{
                    expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                });
                
                it(@"should have proper data in the first change dict", ^{
                    NSNumber<SDLBool> *allAllowed = changeDicts[0][testRPCNameAllAllowed];
                    expect(allAllowed).to(equal(@YES));
                    
                    NSNumber<SDLBool> *fullLimitedAllowed = changeDicts[0][testRPCNameFullLimitedAllowed];
                    expect(fullLimitedAllowed).to(equal(@NO));
                    
                    expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusMixed)));
                });
                
                it(@"should have the proper data in the second change dict", ^{
                    NSNumber<SDLBool> *allAllowed = changeDicts[1][testRPCNameAllAllowed];
                    expect(allAllowed).to(equal(@YES));
                    
                    NSNumber<SDLBool> *fullLimitedAllowed = changeDicts[1][testRPCNameFullLimitedAllowed];
                    expect(fullLimitedAllowed).to(equal(@YES));
                    
                    expect(testStatuses[1]).to(equal(@(SDLPermissionGroupStatusAllowed)));
                });
            });
            
            context(@"to match an all allowed observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    testStatuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });
                
                context(@"so that it becomes All Allowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    });
                    
                    it(@"should call the observer", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                        
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusDisallowed)));
                        expect(testStatuses[1]).to(equal(@(SDLPermissionGroupStatusAllowed)));
                    });
                });
                
                context(@"so that it goes from All Allowed to at least some disallowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedBackgroundAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];
                    });
                    
                    it(@"should call the observer twice", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                    });
                    
                    it(@"should have proper data in the first change dict", ^{
                        expect(changeDicts[0].allKeys).to(contain(testRPCNameFullLimitedBackgroundAllowed));
                        
                        NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameFullLimitedBackgroundAllowed];
                        expect(isAllowed).to(equal(@YES));
                        
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusAllowed)));
                    });
                    
                    it(@"should have the proper data in the second change dict", ^{
                        expect(changeDicts[1].allKeys).to(contain(testRPCNameFullLimitedBackgroundAllowed));
                        
                        NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameFullLimitedBackgroundAllowed];
                        expect(isAllowed).to(equal(@NO));
                        
                        expect(testStatuses[1]).to(equal(@(SDLPermissionGroupStatusDisallowed)));
                    });
                });
            });
            
            context(@"to not match an all allowed observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    testStatuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });
                
                context(@"that goes from disallowed to mixed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    });
                    
                    it(@"should call the observer", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                        
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusDisallowed)));
                    });
                });
                
                context(@"that goes from mixed to disallowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedAllowed, testRPCNameFullLimitedBackgroundAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
                            [testStatuses addObject:@(status)];
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];
                    });
                    
                    it(@"should call the observer", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                        expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusMixed)));
                    });
                });
            });
        });
    });
    
    describe(@"removing observers", ^{
        context(@"removing the only observer", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            
            beforeEach(^{
                // Reset vars
                numberOfTimesObserverCalled = 0;
                
                // Add two observers
                NSUUID *observerId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];
                
                // Remove one observer
                [testPermissionsManager removeObserverForIdentifier:observerId];
                
                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should only call the observer once", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@1));
            });
        });
        
        context(@"removing a single observer and leaving one remaining", ^{
            __block NSUInteger numberOfTimesObserverCalled = 0;
            
            beforeEach(^{
                // Reset vars
                numberOfTimesObserverCalled = 0;
                
                // Add two observers
                NSUUID *testRemovedObserverId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];
                
                [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];
                
                // Remove one observer
                [testPermissionsManager removeObserverForIdentifier:testRemovedObserverId];
                
                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should call three observers", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@3));
            });
        });
        
        context(@"removing all observers", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            
            beforeEach(^{
                // Reset vars
                numberOfTimesObserverCalled = 0;
                
                // Add two observers
                [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];
                
                [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];
                
                // Remove all observers
                [testPermissionsManager removeAllObservers];
                
                // Add some permissions
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should not call the observer", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@2));
            });
        });
    });
});

QuickSpecEnd
