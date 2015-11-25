#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMILevel.h"
#import "SDLHMIPermissions.h"
#import "SDLNotificationConstants.h"
#import "SDLParameterPermissions.h"
#import "SDLPermissionItem.h"
#import "SDLPermissionManager.h"

QuickSpecBegin(SDLPermissionsManagerSpec)

describe(@"SDLPermissionsManager", ^{
    __block SDLPermissionManager *testPermissionsManager = nil;
    __block NSNotification *testPermissionsNotification = nil;
    __block NSString *testRPCNameAllAllowed = nil;
    __block NSString *testRPCNameAllDisallowed = nil;
    __block NSString *testRPCNameFullLimitedAllowed = nil;
    __block SDLPermissionItem *testPermissionAllAllowed = nil;
    __block SDLHMIPermissions *testHMIPermissionsAllAllowed = nil;
    __block SDLPermissionItem *testPermissionAllDisallowed = nil;
    __block SDLHMIPermissions *testHMIPermissionsAllDisallowed = nil;
    __block SDLPermissionItem *testPermissionFullLimitedAllowed = nil;
    __block SDLHMIPermissions *testHMIPermissionsFullLimitedAllowed = nil;
    
    __block NSNotification *limitedHMINotification = nil;
    __block NSNotification *backgroundHMINotification = nil;
    __block NSNotification *noneHMINotification = nil;
    
    beforeEach(^{
        
        testRPCNameAllAllowed = @"AllAllowed";
        testRPCNameAllDisallowed = @"AllDisallowed";
        testRPCNameFullLimitedAllowed = @"FullAndLimitedAllowed";
        
        testPermissionsManager = [[SDLPermissionManager alloc] init];
        
        testHMIPermissionsAllAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsAllAllowed.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
        testHMIPermissionsAllDisallowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsAllDisallowed.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
        testHMIPermissionsFullLimitedAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsFullLimitedAllowed.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel FULL], [SDLHMILevel LIMITED]]];
        testHMIPermissionsFullLimitedAllowed.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel NONE]]];
        
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
        
        context(@"when permissions exist", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                testResultBOOL = [testPermissionsManager isRPCAllowed:testRPCNameAllAllowed];
            });
            
            it(@"should be allowed", ^{
                expect(@(testResultBOOL)).to(equal(@YES));
            });
        });
    });
    
    xdescribe(@"checking the permission status for RPCs", ^{
        
    });
    
    xdescribe(@"checking the permission allowed dictionary for RPCs", ^{
        
    });
    
    describe(@"adding and using observers", ^{
        describe(@"adding new observers", ^{
            context(@"when no data is present", ^{
                __block BOOL testObserverCalled = NO;
                
                beforeEach(^{
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionStatus status) {
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
                __block SDLPermissionStatus testObserverReturnStatus = SDLPermissionStatusUnknown;
                __block SDLPermissionStatus testStatus = SDLPermissionStatusUnknown;
                
                context(@"to match an ANY observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] groupType:SDLPermissionGroupTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionStatus status) {
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
                        expect(@(testObserverReturnStatus)).to(equal(@(SDLPermissionStatusMixed)));
                    });
                });
                
                context(@"to match an all allowed observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        testChangeType = SDLPermissionChangeTypeAllAllowed;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level LIMITED
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] onChange:testChangeType withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = changedDict;
                            testObserverBlockChangeType = changeType;
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
                    
                    it(@"should return the proper change type", ^{
                        expect(@(testObserverBlockChangeType)).to(equal(@(testChangeType)));
                    });
                });
                
                context(@"to match an all disallowed observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        testChangeType = SDLPermissionChangeTypeAllDisallowed;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level BACKGROUND
                        [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedAllowed, testRPCNameAllDisallowed] onChange:testChangeType withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = changedDict;
                            testObserverBlockChangeType = changeType;
                        }];
                    });
                    
                    it(@"should call the observer once", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@1));
                    });
                    
                    it(@"should have the full / limited rpc as NO", ^{
                        expect(testObserverBlockChangedDict[testRPCNameAllAllowed]).to(equal(@NO));
                    });
                    
                    it(@"should have the all disallowed rpc as NO", ^{
                        expect(testObserverBlockChangedDict[testRPCNameFullLimitedAllowed]).to(equal(@NO));
                    });
                    
                    it(@"should only have the two rpcs in the dictionary", ^{
                        expect(testObserverBlockChangedDict.allKeys).to(haveCount(@2));
                    });
                    
                    it(@"should return the proper change type", ^{
                        expect(@(testObserverBlockChangeType)).to(equal(@(testChangeType)));
                    });
                });
                
                context(@"that does not match an all allowed observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        testChangeType = SDLPermissionChangeTypeAllAllowed;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level NONE
                        [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameAllDisallowed, testRPCNameFullLimitedAllowed] onChange:testChangeType withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                            numberOfTimesObserverCalled++;
                        }];
                    });
                    
                    it(@"should not call the observer", ^{
                        expect(@(numberOfTimesObserverCalled)).to(equal(@0));
                    });
                });
                
                context(@"that does not match an all disallowed observer", ^{
                    beforeEach(^{
                        // Reset vars
                        numberOfTimesObserverCalled = 0;
                        
                        testChangeType = SDLPermissionChangeTypeAllDisallowed;
                        
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level LIMITED
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                        
                        // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                        [testPermissionsManager addObserverForRPCs:@[testRPCNameFullLimitedAllowed, testRPCNameAllAllowed] onChange:testChangeType withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
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
            xcontext(@"to match an ANY observer", ^{
                __block NSInteger numberOfTimesObserverCalled = 0;
                
                __block SDLPermissionItem *testPermissionUpdated = nil;
                __block NSMutableArray<NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> *> *changeDicts = nil;
                
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    changeDicts = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed] onChange:SDLPermissionChangeTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
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
                
                it(@"should have the first RPC name", ^{
                    expect(testObserverCalledRPCNames[0]).to(equal(testRPCName1));
                });
                
                it(@"should have the second RPC name", ^{
                    expect(testObserverCalledRPCNames[1]).to(equal(testRPCName1));
                });
            });
            
            xcontext(@"to match an all allowed observer", ^{
                
            });
            
            xcontext(@"to match an all disallowed observer", ^{
                
            });
            
            xcontext(@"updating an observer with a new HMI level", ^{
                
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
                NSUUID *observerId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] onChange:SDLPermissionChangeTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
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
                testRemovedObserverId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] onChange:SDLPermissionChangeTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledIdentifiers addObject:testRemovedObserverId];
                }];
                
                testRemainingObserverId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] onChange:SDLPermissionChangeTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
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
                [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] onChange:SDLPermissionChangeTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
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
