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
    
    __block NSNotification *testHMINotification = nil;
    __block SDLHMILevel *startingHMILevel = nil;
    
    beforeEach(^{
        startingHMILevel = [SDLHMILevel BACKGROUND];
        
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
        testHMINotification = [NSNotification notificationWithName:SDLDidChangeHMIStatusNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: startingHMILevel}];
    });
    
    describe(@"when checking if a permission is allowed", ^{
        __block NSString *someRPCName = nil;
        __block SDLHMILevel *someHMILevel = nil;
        __block BOOL testResultBOOL = NO;
        
        context(@"when no permissions exist", ^{
            beforeEach(^{
                someRPCName = @"some rpc name";
                someHMILevel = [SDLHMILevel BACKGROUND];
                
                testResultBOOL = [testPermissionsManager isRPCAllowed:someRPCName];
            });
            
            it(@"should not be allowed", ^{
                expect(@(testResultBOOL)).to(equal(@NO));
            });
        });
        
        context(@"when permissions exist", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:testHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                someHMILevel = [SDLHMILevel NONE];
                
                testResultBOOL = [testPermissionsManager isRPCAllowed:testRPCNameAllAllowed];
            });
            
            it(@"should be allowed", ^{
                expect(@(testResultBOOL)).to(equal(@YES));
            });
        });
    });
    
    describe(@"when adding and using observers", ^{
        context(@"adding multiple observers", ^{
            context(@"when no data is present", ^{
                __block BOOL testObserverCalled = NO;
                
                beforeEach(^{
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                        testObserverCalled = YES;
                    }];
                });
                
                it(@"should not call the observer", ^{
                    expect(@(testObserverCalled)).to(equal(@NO));
                });
            });
            
            context(@"when data is already present", ^{
                __block NSInteger numberOfTimesObserverCalled = 0;
                __block NSMutableArray<NSString *> *testObserverCalledRPCNames = nil;
                __block NSMutableArray<SDLPermissionItem *> *testObserverCalledOldPermissions = nil;
                __block NSMutableArray<SDLPermissionItem *> *testObserverCalledNewPermissions = nil;
                
                beforeEach(^{
                    // Reset vars
                    numberOfTimesObserverCalled = 0;
                    testObserverCalledRPCNames = [NSMutableArray array];
                    testObserverCalledOldPermissions = [NSMutableArray array];
                    testObserverCalledNewPermissions = [NSMutableArray array];
                    
                    // Post the notification before setting the observer to make sure data is already present
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    // This should be called twice, once for each RPC being observed. It should be called immediately since data should already be present
                    [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameAllDisallowed] usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                        numberOfTimesObserverCalled++;
                        [testObserverCalledRPCNames addObject:rpcName];
                        
                        if (oldPermission != nil) {
                            [testObserverCalledOldPermissions addObject:oldPermission];
                        }
                        
                        [testObserverCalledNewPermissions addObject:newPermission];
                    }];
                });
                
                it(@"should call the observer twice", ^{
                    expect(@(numberOfTimesObserverCalled)).to(equal(@2));
                });
                
                it(@"should have the first RPC name", ^{
                    expect(testObserverCalledRPCNames).to(contain(testRPCName1));
                });
                
                it(@"should have the second RPC name", ^{
                    expect(testObserverCalledRPCNames).to(contain(testRPCName2));
                });
                
                it(@"should not have an old permission", ^{
                    expect(testObserverCalledOldPermissions).to(beEmpty());
                });
                
                it(@"should have the first new permission", ^{
                    expect(testObserverCalledNewPermissions).to(contain(testPermission1));
                });
                
                it(@"should have the second new permission", ^{
                    expect(testObserverCalledNewPermissions).to(contain(testPermission2));
                });
            });
        });
        
        context(@"updating an observer with new data", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            __block NSMutableArray<NSString *> *testObserverCalledRPCNames = nil;
            __block NSMutableArray<SDLPermissionItem *> *testObserverCalledOldPermissions = nil;
            __block NSMutableArray<SDLPermissionItem *> *testObserverCalledNewPermissions = nil;
            
            __block SDLPermissionItem *testPermissionUpdated = nil;
            
            beforeEach(^{
                // Reset vars
                numberOfTimesObserverCalled = 0;
                testObserverCalledRPCNames = [NSMutableArray array];
                testObserverCalledOldPermissions = [NSMutableArray array];
                testObserverCalledNewPermissions = [NSMutableArray array];
                
                // Set the "preexisting" data
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                
                // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                [testPermissionsManager addObserverForRPC:testRPCNameAllAllowed usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledRPCNames addObject:rpcName];
                    
                    if (oldPermission != nil) {
                        [testObserverCalledOldPermissions addObject:oldPermission];
                    }
                    
                    [testObserverCalledNewPermissions addObject:newPermission];
                }];
                
                // Create a new permission update to update a preexisting permission.
                SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                testHMIPermissionsUpdated.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]]];
                testHMIPermissionsUpdated.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
                
                SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                
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
            
            it(@"should only have one old permission", ^{
                expect(testObserverCalledOldPermissions).to(haveCount(@1));
            });
            
            it(@"should have the correct old permission", ^{
                expect(testObserverCalledOldPermissions[0]).to(equal(testPermission1));
            });
            
            it(@"should have the first new permission", ^{
                expect(testObserverCalledNewPermissions).to(contain(testPermission1));
            });
            
            it(@"should have the second new permission", ^{
                expect(testObserverCalledNewPermissions).to(contain(testPermissionUpdated));
            });
        });
    });
    
    describe(@"removing observers", ^{
        context(@"removing a single observer and leaving one remaining", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            __block NSMutableArray<NSString *> *testObserverCalledIdentifiers = nil;
            __block SDLPermissionObserverIdentifier *testRemovedObserverId = nil;
            __block SDLPermissionObserverIdentifier *testRemainingObserverId = nil;
            
            beforeEach(^{
                // Reset vars
                testObserverCalledIdentifiers = [NSMutableArray array];
                
                // Add two observers
                testRemovedObserverId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] onChange:SDLPermissionChangeTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledRPCNames addObject:testRemovedObserverId];
                }];
                
                testRemainingObserverId = [testPermissionsManager addObserverForRPCs:@[testRPCNameAllAllowed, testRPCNameFullLimitedAllowed] onChange:SDLPermissionChangeTypeAny withBlock:^(NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledRPCNames addObject:testRemainingObserverId];
                }];
                
                // Remove one observer
                [testPermissionsManager removeObserverForIdentifier:testRemovedObserverId];
                
                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:testHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should call the observer once", ^{
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
                [[NSNotificationCenter defaultCenter] postNotification:testHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should not call the observer", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@0));
            });
        });
    });
});

QuickSpecEnd
