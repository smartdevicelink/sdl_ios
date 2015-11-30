#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMILevel.h"
#import "SDLHMIPermissions.h"
#import "SDLNotificationConstants.h"
#import "SDLParameterPermissions.h"
#import "SDLPermissionItem.h"
#import "SDLPermissionManager.h"

QuickSpecBegin(SDLPermissionsManagerSpec)

fdescribe(@"SDLPermissionsManager", ^{
    __block SDLPermissionManager *testPermissionsManager = nil;
    __block NSNotification *testPermissionsNotification = nil;
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
    
    __block NSNotification *limitedHMINotification = nil;
    __block NSNotification *backgroundHMINotification = nil;
    __block NSNotification *noneHMINotification = nil;
    
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
        testPermissionFullLimitedBackgroundAllowed.hmiPermissions = testHMIPermissionsFullLimitedAllowed;
        testPermissionFullLimitedBackgroundAllowed.parameterPermissions = testParameterPermissions;
        
        // Permission Notifications
        testPermissionsNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: @[testPermissionAllAllowed, testPermissionAllDisallowed]}];
        limitedHMINotification = [NSNotification notificationWithName:SDLDidChangeHMIStatusNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: [SDLHMILevel LIMITED]}];
        backgroundHMINotification = [NSNotification notificationWithName:SDLDidChangeHMIStatusNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: [SDLHMILevel BACKGROUND]}];
        noneHMINotification = [NSNotification notificationWithName:SDLDidChangeHMIStatusNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: [SDLHMILevel NONE]}];
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
        __block NSDictionary<SDLPermissionRPCName *, NSNumber<SDLBool> *> *testResultPermissionStatusDict = nil;
        
        context(@"with no permissions data", ^{
            beforeEach(^{
                testResultPermissionStatusDict = [testPermissionsManager statusOfRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed]];
            });
            
            it(@"should return NO for RPC All Allowed", ^{
                expect(testResultPermissionStatusDict[testRPCNameAllAllowed]).to(equal(@NO));
            });
            
            it(@"should return NO for RPC All Disallowed", ^{
                expect(testResultPermissionStatusDict[testRPCNameAllDisallowed]).to(equal(@NO));
            });
        });
        
        context(@"with permissions data", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                testResultPermissionStatusDict = [testPermissionsManager statusOfRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed]];
            });
            
            it(@"should return YES for RPC All Allowed", ^{
                expect(testResultPermissionStatusDict[testRPCNameAllAllowed]).to(equal(@YES));
            });
            
            it(@"should return NO for RPC All Disallowed", ^{
                expect(testResultPermissionStatusDict[testRPCNameAllDisallowed]).to(equal(@NO));
            });
        });
    });
    
    describe(@"adding and using observers", ^{
        describe(@"adding new observers", ^{
            context(@"when no data is present", ^{
                __block BOOL testObserverCalled = NO;
                
                beforeEach(^{
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                        testObserverCalled = YES;
                    }];
                });
                
                it(@"should not call the observer", ^{
                    expect(@(testObserverCalled)).to(equal(@NO));
                });
            });
            
            context(@"when data is already present", ^{
                __block NSInteger numberOfTimesObserverCalled = 0;
                __block NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> *testObserverBlockChangedDict = nil;
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
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = changedDict;
                            testObserverReturnStatus = status;
                        }];
                    });
                    
                    it(@"should call the observer once", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                    });
                    
                    it(@"should have the all allowed rpc as YES", ^{
                        expect(testObserverBlockChangedDict[testRPCNameAllAllowed]).to(equal(@YES));
                    });
                    
                    it(@"should have the all disallowed rpc as NO", ^{
                        expect(testObserverBlockChangedDict[testRPCNameAllDisallowed]).to(equal(@NO));
                    });
                    
                    it(@"should only have the two rpcs in the dictionary", ^{
                        expect(testObserverBlockChangedDict.allKeys).to(haveCount(@2));
                    });
                    
                    it(@"should return the proper status", ^{
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
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = changedDict;
                        }];
                    });
                    
                    it(@"should call the observer once", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                    });
                    
                    it(@"should have the all allowed rpc as YES", ^{
                        expect(testObserverBlockChangedDict[testRPCNameAllAllowed]).to(equal(@YES));
                    });
                    
                    it(@"should have the full & limited rpc as YES", ^{
                        expect(testObserverBlockChangedDict[testRPCNameFullLimitedAllowed]).to(equal(@YES));
                    });
                    
                    it(@"should only have the two rpcs in the dictionary", ^{
                        expect(testObserverBlockChangedDict.allKeys).to(haveCount(@2));
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
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllDisallowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                        }];
                    });
                    
                    it(@"should not call the observer", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@0));
                    });
                });
            });
        });
        
        context(@"updating an observer with new permission data", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            
            __block SDLPermissionItem *testPermissionUpdated = nil;
            __block NSMutableArray<NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> *> *changeDicts = nil;
            __block NSMutableArray<NSNumber<SDLUInt> *> *statuses = nil;
            
            context(@"to match an ANY observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    statuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
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
                    
                    // Send the permission update
                    NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: @[testPermissionUpdated]}];
                    [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                });
                
                it(@"should call the observer twice", ^{
                    expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                });
                
                it(@"should have the All Allowed RPC in the first change dict", ^{
                    expect(changeDicts[0]).to(contain(testRPCNameAllAllowed));
                });
                
                it(@"should have the All Disallowed RPC in the first change dict", ^{
                    expect(changeDicts[0]).to(contain(testRPCNameAllDisallowed));
                });
                
                it(@"should have the All Allowed RPC in the second change dict", ^{
                    expect(changeDicts[1]).to(contain(testRPCNameAllAllowed));
                });
                
                it(@"should have the All Disallowed RPC in the second change dict", ^{
                    expect(changeDicts[1]).to(contain(testRPCNameAllDisallowed));
                });
                
                it(@"should have the correct permission state for the all allowed RPC in the first change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameAllAllowed];
                    expect(isAllowed).to(equal(@YES));
                });
                
                it(@"should have the correct permission state for the all disallowed RPC in the first change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameAllDisallowed];
                    expect(isAllowed).to(equal(@NO));
                });
                
                it(@"should have the correct permission state for the all allowed RPC in the updated change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameAllAllowed];
                    expect(isAllowed).to(equal(@NO));
                });
                
                it(@"should have the correct permission state for the all disallowed RPC in the updated change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameAllDisallowed];
                    expect(isAllowed).to(equal(@NO));
                });
            });
            
            context(@"to match an all allowed observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });
                
                context(@"so that it becomes All Allowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAllAllowed withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
                        }];
                        
                        // Create a permission update disallowing our current HMI level for the observed permission
                        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                        SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                        testHMIPermissionsUpdated.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel LIMITED], [SDLHMILevel NONE], [SDLHMILevel BACKGROUND], [SDLHMILevel FULL]]];
                        testHMIPermissionsUpdated.userDisallowed = [NSMutableArray arrayWithArray:@[]];
                        
                        testPermissionUpdated = [[SDLPermissionItem alloc] init];
                        testPermissionUpdated.rpcName = testRPCNameAllDisallowed;
                        testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                        testPermissionUpdated.parameterPermissions = testParameterPermissions;
                        
                        // Send the permission update
                        NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: @[testPermissionUpdated]}];
                        [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                    });
                    
                    it(@"should call the observer once", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                    });
                    
                    it(@"should have the RPC in the first change dict", ^{
                        expect(changeDicts[0]).to(contain(testRPCNameAllDisallowed));
                    });
                    
                    it(@"should have the correct permissions for the RPC in the first change dict", ^{
                        NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameAllDisallowed];
                        expect(isAllowed).to(equal(@YES));
                    });
                });
                
                context(@"so that it goes from All Allowed to at least some disallowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed] groupType:SDLPermissionGroupTypeAllAllowed withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
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
                        
                        // Send the permission update
                        NSNotification *updatedNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: @[testPermissionUpdated]}];
                        [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];
                    });
                    
                    it(@"should call the observer twice", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                    });
                    
                    it(@"should have the RPC in the first change dict", ^{
                        expect(changeDicts[0]).to(contain(testRPCNameAllAllowed));
                    });
                    
                    it(@"should have the RPC in the second change dict", ^{
                        expect(changeDicts[1]).to(contain(testRPCNameAllAllowed));
                    });
                    
                    it(@"should have the correct permissions for the RPC in the first change dict", ^{
                        NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameAllAllowed];
                        expect(isAllowed).to(equal(@YES));
                    });
                    
                    it(@"should have the RPC in the updated change dict", ^{
                        NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameAllAllowed];
                        expect(isAllowed).to(equal(@NO));
                    });
                });
            });
        });
        
        context(@"updating an observer with a new HMI level", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            __block NSMutableArray<NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> *> *changeDicts = nil;
            __block NSMutableArray<NSNumber<SDLUInt> *> *statuses = nil;
            
            context(@"to match an ANY observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    statuses = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:changedDict];
                    }];
                    
                    // Upgrade the HMI level to LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                });
                
                it(@"should call the observer twice", ^{
                    expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                });
                
                it(@"should have the All Allowed RPC in the first change dict", ^{
                    expect(changeDicts[0]).to(contain(testRPCNameAllAllowed));
                });
                
                it(@"should have the All Disallowed RPC in the first change dict", ^{
                    expect(changeDicts[0]).to(contain(testRPCNameFullLimitedAllowed));
                });
                
                it(@"should have the All Allowed RPC in the second change dict", ^{
                    expect(changeDicts[1]).to(contain(testRPCNameAllAllowed));
                });
                
                it(@"should have the All Disallowed RPC in the second change dict", ^{
                    expect(changeDicts[1]).to(contain(testRPCNameFullLimitedAllowed));
                });
                
                it(@"should have the correct permission state for the all allowed RPC in the first change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameAllAllowed];
                    expect(isAllowed).to(equal(@YES));
                });
                
                it(@"should have the correct permissions for the full / limited RPC in the first change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameFullLimitedAllowed];
                    expect(isAllowed).to(equal(@NO));
                });
                
                it(@"should have the correct permission state for the all allowed RPC in the updated change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameAllAllowed];
                    expect(isAllowed).to(equal(@YES));
                });
                
                it(@"should have the correct permission state for the full / limited RPC in the updated change dict", ^{
                    NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameFullLimitedAllowed];
                    expect(isAllowed).to(equal(@YES));
                });
            });
            
            context(@"to match an all allowed observer", ^{
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });
                
                context(@"so that it becomes All Allowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    });
                    
                    it(@"should call the observer once", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                    });
                    
                    it(@"should have the RPC in the first change dict", ^{
                        expect(changeDicts[0]).to(contain(testRPCNameFullLimitedAllowed));
                    });
                    
                    it(@"should have the correct permissions for the RPC in the first change dict", ^{
                        NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameFullLimitedAllowed];
                        expect(isAllowed).to(equal(@YES));
                    });
                });
                
                context(@"so that it goes from All Allowed to at least some disallowed", ^{
                    beforeEach(^{
                        // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedBackgroundAllowed] groupType:SDLPermissionGroupTypeAllAllowed withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            [changeDicts addObject:changedDict];
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];
                    });
                    
                    it(@"should call the observer twice", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                    });
                    
                    it(@"should have the RPC in the first change dict", ^{
                        expect(changeDicts[0]).to(contain(testRPCNameFullLimitedBackgroundAllowed));
                    });
                    
                    it(@"should have the RPC in the second change dict", ^{
                        expect(changeDicts[1]).to(contain(testRPCNameFullLimitedBackgroundAllowed));
                    });
                    
                    it(@"should have the correct permissions for the RPC in the first change dict", ^{
                        NSNumber<SDLBool> *isAllowed = changeDicts[0][testRPCNameFullLimitedBackgroundAllowed];
                        expect(isAllowed).to(equal(@YES));
                    });
                    
                    it(@"should have the RPC in the updated change dict", ^{
                        NSNumber<SDLBool> *isAllowed = changeDicts[1][testRPCNameFullLimitedBackgroundAllowed];
                        expect(isAllowed).to(equal(@NO));
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
                NSUUID *observerId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];
                
                // Remove one observer
                [testPermissionsManager removeObserverForIdentifier:observerId];
                
                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should not call an observer", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@0));
            });
        });
        
        context(@"removing a single observer and leaving one remaining", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            __block NSMutableArray<NSUUID *> *testObserverCalledIdentifiers = nil;
            __block SDLPermissionObserverIdentifier *testRemovedObserverId = nil;
            __block SDLPermissionObserverIdentifier *testRemainingObserverId = nil;
            
            beforeEach(^{
                // Reset vars
                numberOfTimesObserverCalled = 0;
                testObserverCalledIdentifiers = [NSMutableArray array];
                
                // Add two observers
                testRemovedObserverId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledIdentifiers addObject:testRemovedObserverId];
                }];
                
                testRemainingObserverId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledIdentifiers addObject:testRemainingObserverId];
                }];
                
                // Remove one observer
                [testPermissionsManager removeObserverForIdentifier:testRemovedObserverId];
                
                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should call one observer", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@1));
            });
            
            it(@"should not call the observer for the removed RPC", ^{
                expect(testObserverCalledIdentifiers).notTo(contain(testRemovedObserverId));
            });
            
            it(@"should call the observer for the remaining RPC", ^{
                expect(testObserverCalledIdentifiers).to(contain(testRemainingObserverId));
            });
        });
        
        context(@"removing all observers", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            
            beforeEach(^{
                // Reset vars
                numberOfTimesObserverCalled = 0;
                
                // Add two observers
                [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];
                
                // Remove all observers
                [testPermissionsManager removeAllObservers];
                
                // Add some permissions
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should not call the observer", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@0));
            });
        });
    });
});

QuickSpecEnd
