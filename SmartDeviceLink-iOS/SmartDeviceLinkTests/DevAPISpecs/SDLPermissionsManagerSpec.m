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
    __block NSString *testRPCName1 = nil;
    __block NSString *testRPCName2 = nil;
    __block SDLPermissionItem *testPermission1 = nil;
    __block SDLPermissionItem *testPermission2 = nil;
    __block SDLHMIPermissions *testHMIPermissions1 = nil;
    __block SDLHMIPermissions *testHMIPermissions2 = nil;
    
    beforeEach(^{
        testRPCName1 = @"Show";
        testRPCName2 = @"Speak";
        
        testPermissionsManager = [[SDLPermissionManager alloc] init];
        
        testHMIPermissions1 = [[SDLHMIPermissions alloc] init];
        testHMIPermissions1.allowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
        testHMIPermissions2 = [[SDLHMIPermissions alloc] init];
        testHMIPermissions2.userDisallowed = [NSMutableArray arrayWithArray:@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL], [SDLHMILevel LIMITED], [SDLHMILevel NONE]]];
        
        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
        
        testPermission1 = [[SDLPermissionItem alloc] init];
        testPermission1.rpcName = testRPCName1;
        testPermission1.hmiPermissions = testHMIPermissions1;
        testPermission1.parameterPermissions = testParameterPermissions;
        
        testPermission2 = [[SDLPermissionItem alloc] init];
        testPermission2.rpcName = testRPCName2;
        testPermission2.hmiPermissions = testHMIPermissions2;
        testPermission2.parameterPermissions = testParameterPermissions;
        
        testPermissionsNotification = [NSNotification notificationWithName:SDLDidChangePermissionsNotification object:nil userInfo:@{SDLNotificationUserInfoNotificationObject: @[testPermission1, testPermission2]}];
    });
    
    describe(@"when checking if a permission is allowed", ^{
        __block NSString *someRPCName = nil;
        __block SDLHMILevel *someHMILevel = nil;
        __block BOOL testResultBOOL = NO;
        
        context(@"when no permissions exist", ^{
            beforeEach(^{
                someRPCName = @"some rpc name";
                someHMILevel = [SDLHMILevel BACKGROUND];
                
                testResultBOOL = [testPermissionsManager isRPCAllowed:someRPCName forHMILevel:someHMILevel];
            });
            
            it(@"should not be allowed", ^{
                expect(@(testResultBOOL)).to(equal(@NO));
            });
        });
        
        context(@"when permissions exist", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                someHMILevel = [SDLHMILevel NONE];
                
                testResultBOOL = [testPermissionsManager isRPCAllowed:testRPCName1 forHMILevel:someHMILevel];
            });
            
            it(@"should be allowed", ^{
                expect(@(testResultBOOL)).to(equal(@YES));
            });
        });
    });
    
    describe(@"when adding and using observers", ^{
        context(@"adding a single observer", ^{
            context(@"when no data is present", ^{
                __block BOOL testObserverCalled = NO;
                
                beforeEach(^{
                    [testPermissionsManager addObserverForRPC:testRPCName1 usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                        testObserverCalled = YES;
                    }];
                });
                
                it(@"should not call the observer", ^{
                    expect(@(testObserverCalled)).to(equal(@NO));
                });
            });
            
            context(@"when data is already present", ^{
                __block BOOL testObserverCalled = NO;
                __block NSString *testObserverCalledRPCName = nil;
                __block SDLPermissionItem *testObserverCalledOldPermission = nil;
                __block SDLPermissionItem *testObserverCalledNewPermission = nil;
                
                beforeEach(^{
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                    
                    // This should be called immediately since data is already present
                    [testPermissionsManager addObserverForRPC:testRPCName1 usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                        testObserverCalled = YES;
                        testObserverCalledRPCName = rpcName;
                        testObserverCalledOldPermission = oldPermission;
                        testObserverCalledNewPermission = newPermission;
                    }];
                });
                
                it(@"should call the observer", ^{
                    expect(@(testObserverCalled)).to(equal(@YES));
                });
                
                it(@"should have the correct RPC name", ^{
                    expect(testObserverCalledRPCName).to(equal(testRPCName1));
                });
                
                it(@"should not have an old permission", ^{
                    expect(testObserverCalledOldPermission).to(beNil());
                });
                
                it(@"should have the correct new permission", ^{
                    expect(testObserverCalledNewPermission).to(equal(testPermission1));
                });
            });
        });
        
        context(@"adding multiple observers", ^{
            context(@"when no data is present", ^{
                __block BOOL testObserverCalled = NO;
                
                beforeEach(^{
                    [testPermissionsManager addObserverForRPCs:@[testRPCName1, testRPCName2] usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
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
                    [testPermissionsManager addObserverForRPCs:@[testRPCName1, testRPCName2] usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
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
                [testPermissionsManager addObserverForRPC:testRPCName1 usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
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
                testPermissionUpdated.rpcName = testRPCName1;
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
            __block NSMutableArray<NSString *> *testObserverCalledRPCNames = nil;
            __block NSMutableArray<SDLPermissionItem *> *testObserverCalledOldPermissions = nil;
            __block NSMutableArray<SDLPermissionItem *> *testObserverCalledNewPermissions = nil;
            
            beforeEach(^{
                // Reset vars
                numberOfTimesObserverCalled = 0;
                testObserverCalledRPCNames = [NSMutableArray array];
                testObserverCalledOldPermissions = [NSMutableArray array];
                testObserverCalledNewPermissions = [NSMutableArray array];
                
                // Add two observers
                [testPermissionsManager addObserverForRPCs:@[testRPCName1, testRPCName2] usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledRPCNames addObject:rpcName];
                    
                    if (oldPermission != nil) {
                        [testObserverCalledOldPermissions addObject:oldPermission];
                    }
                    
                    [testObserverCalledNewPermissions addObject:newPermission];
                }];
                
                // Remove one observer
                [testPermissionsManager removeObserversForRPC:testRPCName1];
                
                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should call the observer once", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@1));
            });
            
            it(@"should not call the observer for the removed RPC", ^{
                expect(testObserverCalledRPCNames).notTo(contain(testRPCName1));
            });
            
            it(@"should call the observer for the not remaining RPC", ^{
                expect(testObserverCalledRPCNames).to(contain(testRPCName2));
            });
        });
        
        context(@"removing multiple observers", ^{
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
                
                // Add two observers
                [testPermissionsManager addObserverForRPCs:@[testRPCName1, testRPCName2] usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledRPCNames addObject:rpcName];
                    
                    if (oldPermission != nil) {
                        [testObserverCalledOldPermissions addObject:oldPermission];
                    }
                    
                    [testObserverCalledNewPermissions addObject:newPermission];
                }];
                
                // Remove both observers
                [testPermissionsManager removeObserversForRPCs:@[testRPCName1, testRPCName2]];
                
                // Add a permission
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should never call the observer", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@0));
            });
        });
        
        context(@"removing all observers", ^{
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
                
                // Add two observers
                [testPermissionsManager addObserverForRPCs:@[testRPCName1, testRPCName2] usingBlock:^(NSString * _Nonnull rpcName, SDLPermissionItem * _Nullable oldPermission, SDLPermissionItem * _Nonnull newPermission) {
                    numberOfTimesObserverCalled++;
                    [testObserverCalledRPCNames addObject:rpcName];
                    
                    if (oldPermission != nil) {
                        [testObserverCalledOldPermissions addObject:oldPermission];
                    }
                    
                    [testObserverCalledNewPermissions addObject:newPermission];
                }];
                
                // Remove all observers
                [testPermissionsManager removeAllObservers];
                
                // Add some permissions
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });
            
            it(@"should not call the observer", ^{
                expect(@(numberOfTimesObserverCalled)).to(equal(@0));
            });
        });
    });
});

QuickSpecEnd
