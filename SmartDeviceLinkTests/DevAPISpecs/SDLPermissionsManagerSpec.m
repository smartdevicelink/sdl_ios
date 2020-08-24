
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMILevel.h"
#import "SDLHMIPermissions.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnPermissionsChange.h"
#import "SDLParameterPermissions.h"
#import "SDLPermissionFilter.h"
#import "SDLPermissionItem.h"
#import "SDLPermissionManager.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"

@interface SDLPermissionManager ()

@property (strong, nonatomic) NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> *permissions;
@property (strong, nonatomic) NSMutableArray<SDLPermissionFilter *> *filters;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (assign, nonatomic) BOOL requiresEncryption;

@end

QuickSpecBegin(SDLPermissionsManagerSpec)

describe(@"SDLPermissionsManager", ^{
    __block SDLPermissionManager *testPermissionsManager = nil;

    __block NSString *testRPCNameAllAllowed = nil;
    __block NSString *testRPCNameAllDisallowed = nil;
    __block NSString *testRPCNameFullLimitedAllowed = nil;
    __block NSString *testRPCNameFullLimitedBackgroundAllowed = nil;

    __block NSString *testRPCParameterNameAllAllowed = nil;
    __block NSString *testRPCParameterNameAllDisallowed = nil;
    __block NSString *testRPCParameterNameFullLimitedAllowed = nil;

    __block SDLParameterPermissions *testParameterPermissionAllowed = nil;
    __block SDLParameterPermissions *testParameterPermissionUserDisallowed = nil;
    __block SDLParameterPermissions *testParameterPermissionFullLimitedAllowed = nil;

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

    __block SDLPermissionElement *testPermissionElementAllAllowed = nil;
    __block SDLPermissionElement *testPermissionElementFullLimitedAllowed = nil;
    __block SDLPermissionElement *testPermissionElementFullLimitedBackgroundAllowed = nil;
    __block SDLPermissionElement *testPermissionElementDisallowed = nil;

    beforeEach(^{
        // Permission Names
        testRPCNameAllAllowed = @"AllAllowed";
        testRPCNameAllDisallowed = @"AllDisallowed";
        testRPCNameFullLimitedAllowed = @"FullAndLimitedAllowed";
        testRPCNameFullLimitedBackgroundAllowed = @"FullAndLimitedAndBackgroundAllowed";

        // Parameter Permission Names
        testRPCParameterNameAllAllowed = @"AllAllowed";
        testRPCParameterNameAllDisallowed = @"AllDisallowed";
        testRPCParameterNameFullLimitedAllowed = @"FullAndLimitedAllowed";

        // Create a manager
        testPermissionsManager = [[SDLPermissionManager alloc] init];

        // Permission states
        testHMIPermissionsAllAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsAllAllowed.allowed = @[SDLHMILevelBackground, SDLHMILevelFull, SDLHMILevelLimited, SDLHMILevelNone];

        testHMIPermissionsAllDisallowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsAllDisallowed.userDisallowed = @[SDLHMILevelBackground, SDLHMILevelFull, SDLHMILevelLimited, SDLHMILevelNone];

        testHMIPermissionsFullLimitedAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsFullLimitedAllowed.allowed = @[SDLHMILevelFull, SDLHMILevelLimited];
        testHMIPermissionsFullLimitedAllowed.userDisallowed = @[SDLHMILevelBackground, SDLHMILevelNone];

        testHMIPermissionsFullLimitedBackgroundAllowed = [[SDLHMIPermissions alloc] init];
        testHMIPermissionsFullLimitedBackgroundAllowed.allowed = @[SDLHMILevelFull, SDLHMILevelLimited, SDLHMILevelBackground];
        testHMIPermissionsFullLimitedBackgroundAllowed.userDisallowed = @[SDLHMILevelNone];

        // Assemble Parameter Permissions
        testParameterPermissionAllowed = [[SDLParameterPermissions alloc] init];
        testParameterPermissionAllowed.allowed = @[testRPCParameterNameAllAllowed];

        testParameterPermissionUserDisallowed = [[SDLParameterPermissions alloc] init];
        testParameterPermissionUserDisallowed.userDisallowed = @[testRPCParameterNameAllDisallowed];

        testParameterPermissionFullLimitedAllowed = [[SDLParameterPermissions alloc] init];
        testParameterPermissionFullLimitedAllowed.allowed = @[testRPCParameterNameAllAllowed, testRPCParameterNameFullLimitedAllowed];

        // Assemble Permissions
        SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];

        testPermissionAllAllowed = [[SDLPermissionItem alloc] init];
        testPermissionAllAllowed.rpcName = testRPCNameAllAllowed;
        testPermissionAllAllowed.hmiPermissions = testHMIPermissionsAllAllowed;
        testPermissionAllAllowed.parameterPermissions = testParameterPermissionAllowed;

        testPermissionAllDisallowed = [[SDLPermissionItem alloc] init];
        testPermissionAllDisallowed.rpcName = testRPCNameAllDisallowed;
        testPermissionAllDisallowed.hmiPermissions = testHMIPermissionsAllDisallowed;
        testPermissionAllDisallowed.parameterPermissions = testParameterPermissionUserDisallowed;

        testPermissionFullLimitedAllowed = [[SDLPermissionItem alloc] init];
        testPermissionFullLimitedAllowed.rpcName = testRPCNameFullLimitedAllowed;
        testPermissionFullLimitedAllowed.hmiPermissions = testHMIPermissionsFullLimitedAllowed;
        testPermissionFullLimitedAllowed.parameterPermissions = testParameterPermissionFullLimitedAllowed;

        testPermissionFullLimitedBackgroundAllowed = [[SDLPermissionItem alloc] init];
        testPermissionFullLimitedBackgroundAllowed.rpcName = testRPCNameFullLimitedBackgroundAllowed;
        testPermissionFullLimitedBackgroundAllowed.hmiPermissions = testHMIPermissionsFullLimitedBackgroundAllowed;
        testPermissionFullLimitedBackgroundAllowed.parameterPermissions = testParameterPermissions;

        // Create OnHMIStatus objects
        testLimitedHMIStatus = [[SDLOnHMIStatus alloc] init];
        testLimitedHMIStatus.hmiLevel = SDLHMILevelLimited;

        testBackgroundHMIStatus = [[SDLOnHMIStatus alloc] init];
        testBackgroundHMIStatus.hmiLevel = SDLHMILevelBackground;

        testNoneHMIStatus = [[SDLOnHMIStatus alloc] init];
        testNoneHMIStatus.hmiLevel = SDLHMILevelNone;

        // Create OnPermissionsChange object
        testPermissionsChange = [[SDLOnPermissionsChange alloc] init];
        testPermissionsChange.permissionItem = @[testPermissionAllAllowed, testPermissionAllDisallowed, testPermissionFullLimitedAllowed, testPermissionFullLimitedBackgroundAllowed];

        // Permission Notifications
        testPermissionsNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangePermissionsNotification object:nil rpcNotification:testPermissionsChange];
        limitedHMINotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testLimitedHMIStatus];
        backgroundHMINotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testBackgroundHMIStatus];
        noneHMINotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testNoneHMIStatus];

        // Permission Elements
        testPermissionElementAllAllowed = [[SDLPermissionElement alloc] initWithRPCName:testRPCNameAllAllowed parameterPermissions:@[testRPCParameterNameAllAllowed]];
        testPermissionElementFullLimitedAllowed = [[SDLPermissionElement alloc] initWithRPCName:testRPCNameFullLimitedAllowed parameterPermissions:@[testRPCParameterNameFullLimitedAllowed]];
        testPermissionElementFullLimitedBackgroundAllowed = [[SDLPermissionElement alloc] initWithRPCName:testRPCNameFullLimitedBackgroundAllowed parameterPermissions: nil];
        testPermissionElementDisallowed = [[SDLPermissionElement alloc] initWithRPCName:testRPCNameAllDisallowed parameterPermissions:@[testRPCParameterNameAllDisallowed]];
    });

    it(@"should clear when stopped", ^{
        [testPermissionsManager stop];

        expect(testPermissionsManager.filters).to(beEmpty());
        expect(testPermissionsManager.permissions).to(beEmpty());
        expect(testPermissionsManager.currentHMILevel).to(beNil());
        expect(testPermissionsManager.requiresEncryption).to(beFalse());
    });

    describe(@"checking if a permission is allowed", ^{
        __block NSString *someRPCName = nil;
        __block SDLRPCFunctionName someRPCFunctionName = nil;
        __block BOOL testResultBOOL = NO;

        context(@"when no permissions exist", ^{
            it(@"should not be allowed", ^{
                someRPCFunctionName = @"SomeRPCFunctionName";
                testResultBOOL = [testPermissionsManager isRPCNameAllowed:someRPCName];

                expect(testResultBOOL).to(beFalse());
            });
        });

        context(@"when permissions exist but no HMI level", ^{
            it(@"should not be allowed", ^{
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                testResultBOOL = [testPermissionsManager isRPCNameAllowed:someRPCName];

                expect(testResultBOOL).to(beFalse());
            });
        });

        context(@"when permissions exist", ^{
            context(@"and the permission is allowed", ^{
                beforeEach(^{
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                    testResultBOOL = [testPermissionsManager isRPCNameAllowed:testRPCNameAllAllowed];
                });

                it(@"should be allowed", ^{
                    expect(testResultBOOL).to(beTrue());
                });
            });

            context(@"and the permission is denied", ^{
                beforeEach(^{
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                    testResultBOOL = [testPermissionsManager isRPCNameAllowed:testRPCNameAllDisallowed];
                });

                it(@"should be denied", ^{
                    expect(testResultBOOL).to(beFalse());
                });
            });
        });
    });

    describe(@"checking the group status of RPCs", ^{
        __block SDLPermissionGroupStatus testResultStatus = SDLPermissionGroupStatusUnknown;

        context(@"with no permissions data", ^{
            it(@"should return unknown", ^{
                testResultStatus = [testPermissionsManager groupStatusOfRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed]];

                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusUnknown)));
            });
        });

        context(@"for an all allowed group", ^{
            it(@"should return allowed", ^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                testResultStatus = [testPermissionsManager groupStatusOfRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed]];

                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusAllowed)));
            });
        });

        context(@"for an all disallowed group", ^{
            it(@"should return disallowed", ^{
                [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                testResultStatus = [testPermissionsManager groupStatusOfRPCPermissions:@[testPermissionElementFullLimitedAllowed, testPermissionElementDisallowed]];

                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusDisallowed)));
            });
        });

        context(@"for a mixed group", ^{
            it(@"should return mixed", ^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                testResultStatus = [testPermissionsManager groupStatusOfRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementDisallowed]];

                expect(@(testResultStatus)).to(equal(@(SDLPermissionGroupStatusMixed)));
            });
        });
    });

    describe(@"checking the status of RPCs", ^{
        __block NSDictionary<SDLRPCFunctionName, SDLRPCPermissionStatus *> *testResultRPCPermissionStatusDict = nil;
        __block SDLRPCPermissionStatus *allowedResultStatus = nil;
        __block SDLRPCPermissionStatus *disallowedResultStatus = nil;

        __block NSDictionary *testAllowedDict = nil;
        __block SDLRPCPermissionStatus *testAllowedStatus = nil;
        __block NSDictionary *testDisallowedDict = nil;
        __block SDLRPCPermissionStatus *testDisallowedStatus = nil;

        context(@"with no permissions data", ^{
            it(@"should return the correct permission statuses", ^{
                testResultRPCPermissionStatusDict = [testPermissionsManager statusesOfRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementDisallowed]];
                allowedResultStatus = testResultRPCPermissionStatusDict[testPermissionElementAllAllowed.rpcName];
                disallowedResultStatus = testResultRPCPermissionStatusDict[testPermissionElementDisallowed.rpcName];

                testAllowedDict = [[NSDictionary alloc] initWithObjectsAndKeys:@(0), testRPCParameterNameAllAllowed, nil];
                testAllowedStatus = [[SDLRPCPermissionStatus alloc] initWithRPCName:testPermissionElementAllAllowed.rpcName isRPCAllowed:YES rpcParameters:testAllowedDict];
                testDisallowedDict = [[NSDictionary alloc] initWithObjectsAndKeys:@(0), testRPCParameterNameAllDisallowed, nil];
                testDisallowedStatus = [[SDLRPCPermissionStatus alloc] initWithRPCName:testPermissionElementDisallowed.rpcName isRPCAllowed:YES rpcParameters:testDisallowedDict];

                expect(allowedResultStatus.rpcName).to(equal(testAllowedStatus.rpcName));
                expect(allowedResultStatus.rpcParameters).to(equal(testAllowedStatus.rpcParameters));
                expect(allowedResultStatus.rpcAllowed).to(equal(@NO));

                expect(disallowedResultStatus.rpcName).to(equal(testDisallowedStatus.rpcName));
                expect(disallowedResultStatus.rpcParameters).to(equal(testDisallowedStatus.rpcParameters));
                expect(disallowedResultStatus.rpcAllowed).to(equal(@NO));
            });
        });

        context(@"with permissions data", ^{
            it(@"should return the correct permission statuses", ^{
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                testResultRPCPermissionStatusDict = [testPermissionsManager statusesOfRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementDisallowed]];

                allowedResultStatus = testResultRPCPermissionStatusDict[testPermissionElementAllAllowed.rpcName];
                disallowedResultStatus = testResultRPCPermissionStatusDict[testPermissionElementDisallowed.rpcName];

                testAllowedDict = [[NSDictionary alloc] initWithObjectsAndKeys:@(1), testRPCParameterNameAllAllowed, nil];
                testAllowedStatus = [[SDLRPCPermissionStatus alloc] initWithRPCName:testPermissionElementAllAllowed.rpcName isRPCAllowed:YES rpcParameters:testAllowedDict];

                testDisallowedDict = [[NSDictionary alloc] initWithObjectsAndKeys:@(0), testRPCParameterNameAllDisallowed, nil];
                testDisallowedStatus = [[SDLRPCPermissionStatus alloc] initWithRPCName:testPermissionElementDisallowed.rpcName isRPCAllowed:NO rpcParameters:testDisallowedDict];

                expect(allowedResultStatus.rpcName).to(equal(testAllowedStatus.rpcName));
                expect(allowedResultStatus.rpcParameters).to(equal(testAllowedStatus.rpcParameters));
                expect(allowedResultStatus.rpcAllowed).to(equal(testAllowedStatus.rpcAllowed));

                expect(disallowedResultStatus.rpcName).to(equal(testDisallowedStatus.rpcName));
                expect(disallowedResultStatus.rpcParameters).to(equal(testDisallowedStatus.rpcParameters));
                expect(disallowedResultStatus.rpcAllowed).to(equal(testDisallowedStatus.rpcAllowed));
            });
        });
    });

    describe(@"adding and using observers", ^{
        describe(@"adding new observers", ^{
            context(@"when no data is present", ^{
                __block BOOL testObserverCalled = NO;
                __block SDLPermissionGroupStatus testObserverStatus = SDLPermissionGroupStatusUnknown;
                __block NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> *testObserverChangeDict = nil;

                beforeEach(^{
                    testObserverCalled = NO;
                    testObserverStatus = SDLPermissionGroupStatusUnknown;
                    testObserverChangeDict = nil;

                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        testObserverChangeDict = updatedPermissionStatuses;
                        testObserverStatus = status;
                        testObserverCalled = YES;
                    }];
                });

                it(@"should return correct permission statuses", ^{
                    expect(@(testObserverCalled)).to(equal(@YES));
                    expect(@(testObserverStatus)).to(equal(@(SDLPermissionGroupStatusUnknown)));
                    expect(testObserverChangeDict[testRPCNameAllAllowed].rpcAllowed).to(equal(@NO));
                    expect(testObserverChangeDict[testRPCNameAllDisallowed].rpcAllowed).to(equal(@NO));
                });
            });

            context(@"when data is already present", ^{
                __block NSInteger numberOfTimesObserverCalled = 0;
                __block NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> *testObserverBlockChangedDict = nil;
                __block SDLPermissionGroupStatus testObserverReturnStatus = SDLPermissionGroupStatusUnknown;

                beforeEach(^{
                    numberOfTimesObserverCalled = 0;
                    testObserverBlockChangedDict = nil;
                    testObserverReturnStatus = SDLPermissionGroupStatusUnknown;
                });

                context(@"to match an ANY observer", ^{
                    beforeEach(^{
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                        // This should be called should be called immediately since the `groupType` is `any`
                        [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = updatedPermissionStatuses;
                            testObserverReturnStatus = status;
                        }];
                    });

                    it(@"should call the observer with proper status", ^{
                        expect(numberOfTimesObserverCalled).to(equal(1));
                        expect(testObserverBlockChangedDict[testRPCNameAllAllowed].rpcAllowed).to(beTrue());
                        expect(testObserverBlockChangedDict[testRPCNameAllDisallowed].rpcAllowed).to(beFalse());
                        expect(testObserverBlockChangedDict.allKeys).to(haveCount(2));
                        expect(@(testObserverReturnStatus)).to(equal(SDLPermissionGroupStatusMixed));
                    });
                });

                context(@"to match an All Allowed observer", ^{
                    beforeEach(^{
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level LIMITED
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                        // This should be called called immediately since data is already present and all rpcs are allowed
                        [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = updatedPermissionStatuses;
                            testObserverReturnStatus = status;
                        }];
                    });

                    it(@"should call the observer with proper status", ^{
                        expect(numberOfTimesObserverCalled).to(equal(1));
                        expect(testObserverBlockChangedDict[testRPCNameAllAllowed].rpcAllowed).to(beTrue());
                        expect(testObserverBlockChangedDict[testRPCNameFullLimitedAllowed].rpcAllowed).to(beTrue());
                        expect(testObserverBlockChangedDict.allKeys).to(haveCount(2));
                        expect(@(testObserverReturnStatus)).to(equal(SDLPermissionGroupStatusAllowed));
                    });
                });

                context(@"that does not match an All Allowed observer", ^{
                    beforeEach(^{
                        // Post the notification before setting the observer to make sure data is already present
                        // HMI Full & Limited allowed, hmi level NONE
                        [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                        // This should not be called at all since not all rpcs are allowed
                        [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementDisallowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                            numberOfTimesObserverCalled++;
                            testObserverBlockChangedDict = updatedPermissionStatuses;
                            testObserverReturnStatus = status;
                        }];
                    });

                    it(@"should not call the observer", ^{
                        expect(numberOfTimesObserverCalled).to(equal(0));
                        expect(testObserverBlockChangedDict).to(beNil());
                        expect(@(testObserverReturnStatus)).to(equal(SDLPermissionGroupStatusUnknown));
                    });
                });
            });
        });

        context(@"getting new permission data", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            __block NSMutableArray<NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> *> *changeDicts = nil;
            __block NSMutableArray<NSNumber<SDLUInt> *> *testStatuses = nil;

            beforeEach(^{
                numberOfTimesObserverCalled = 0;
                changeDicts = [NSMutableArray array];
                testStatuses = [NSMutableArray array];
            });

            context(@"with an ANY group type observer", ^{
                beforeEach(^{
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                    // Set an observer that should be called immediately for the preexisting data, then called again when new data is sent
                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementDisallowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                    }];
                });

                it(@"should notify the observer when permissions have changed", ^{
                    // Create a permission update disallowing our current HMI level for the observed permission
                    SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                    testHMIPermissionsUpdated.allowed = @[SDLHMILevelBackground, SDLHMILevelFull];
                    testHMIPermissionsUpdated.userDisallowed = @[SDLHMILevelLimited, SDLHMILevelNone];

                    SDLPermissionItem *testPermissionUpdated = [[SDLPermissionItem alloc] init];
                    testPermissionUpdated.rpcName = testRPCNameAllAllowed;
                    testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                    testPermissionUpdated.parameterPermissions = [[SDLParameterPermissions alloc] init];

                    SDLOnPermissionsChange *testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                    testPermissionChangeUpdate.permissionItem = [NSArray arrayWithObject:testPermissionUpdated];

                    // Send the permission update
                    SDLRPCNotificationNotification *updatedNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangePermissionsNotification object:nil rpcNotification:testPermissionChangeUpdate];
                    [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];

                    expect(numberOfTimesObserverCalled).to(equal(2));

                    expect(changeDicts[0].allKeys).to(contain(testRPCNameAllAllowed));
                    expect(changeDicts[0].allKeys).to(contain(testRPCNameAllDisallowed));
                    SDLRPCPermissionStatus *allAllowed1 = changeDicts[0][testRPCNameAllAllowed];
                    expect(allAllowed1.rpcAllowed).to(beTrue());
                    SDLRPCPermissionStatus *allDisallowed1 = changeDicts[0][testRPCNameAllDisallowed];
                    expect(allDisallowed1.rpcAllowed).to(beFalse());

                    expect(changeDicts[1].allKeys).to(contain(testRPCNameAllAllowed));
                    expect(changeDicts[1].allKeys).to(contain(testRPCNameAllDisallowed));
                    SDLRPCPermissionStatus *allAllowed2 = changeDicts[1][testRPCNameAllAllowed];
                    expect(allAllowed2.rpcAllowed).to(beFalse());
                    SDLRPCPermissionStatus *allDisallowed2 = changeDicts[1][testRPCNameAllDisallowed];
                    expect(allDisallowed2.rpcAllowed).to(beFalse());
                });

                it(@"should not notify the observer if permissions have not changed", ^{
                    SDLOnPermissionsChange *testNoPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                    testNoPermissionChangeUpdate.permissionItem = [NSArray arrayWithObject:testPermissionElementAllAllowed];

                    // Send the permission update
                    SDLRPCNotificationNotification *updatedNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangePermissionsNotification object:nil rpcNotification:testNoPermissionChangeUpdate];
                    [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];

                    expect(numberOfTimesObserverCalled).to(equal(1));

                    expect(changeDicts[0].allKeys).to(contain(testRPCNameAllAllowed));
                    expect(changeDicts[0].allKeys).to(contain(testRPCNameAllDisallowed));
                    SDLRPCPermissionStatus *allAllowed = changeDicts[0][testRPCNameAllAllowed];
                    expect(allAllowed.rpcAllowed).to(beTrue());
                    SDLRPCPermissionStatus *allDisallowed = changeDicts[0][testRPCNameAllDisallowed];
                    expect(allDisallowed.rpcAllowed).to(beFalse());
                });
            });

            context(@"with an All Allowed group type observer", ^{
                beforeEach(^{
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });

                it(@"should notify the observer when permissions change from some-not-allowed to all-allowed", ^{
                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                        [testStatuses addObject:@(status)];
                    }];

                    SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                    testHMIPermissionsUpdated.allowed = @[SDLHMILevelBackground, SDLHMILevelFull, SDLHMILevelLimited];
                    testHMIPermissionsUpdated.userDisallowed = @[SDLHMILevelNone];

                    SDLParameterPermissions *updatedParameterPermissions = [[SDLParameterPermissions alloc] init];
                    updatedParameterPermissions.userDisallowed = @[];
                    updatedParameterPermissions.allowed = @[testRPCNameFullLimitedAllowed];

                    SDLPermissionItem *testPermissionUpdated = [[SDLPermissionItem alloc] init];
                    testPermissionUpdated.rpcName = testRPCNameFullLimitedAllowed;
                    testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                    testPermissionUpdated.parameterPermissions = updatedParameterPermissions;

                    SDLOnPermissionsChange *testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                    testPermissionChangeUpdate.permissionItem = [NSArray arrayWithObject:testPermissionUpdated];

                    // Send the permission update
                    SDLRPCNotificationNotification *updatedNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangePermissionsNotification object:nil rpcNotification:testPermissionChangeUpdate];
                    [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];

                    expect(numberOfTimesObserverCalled).to(equal(1));
                    expect(testStatuses[0]).to(equal(SDLPermissionGroupStatusAllowed));
                    expect(changeDicts[0].allKeys).to(contain(testRPCNameFullLimitedAllowed));
                    SDLRPCPermissionStatus *isAllowed = changeDicts[0][testRPCNameFullLimitedAllowed];
                    expect(isAllowed.rpcAllowed).to(beTrue());
                });

                it(@"should notify the observer when permissions change from all-allowed to some-not-allowed", ^{
                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                        [testStatuses addObject:@(status)];
                    }];

                    // Create a permission update disallowing our current HMI level for the observed permission
                    SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                    SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                    testHMIPermissionsUpdated.allowed = @[];
                    testHMIPermissionsUpdated.userDisallowed = @[SDLHMILevelBackground, SDLHMILevelFull, SDLHMILevelLimited, SDLHMILevelNone];

                    SDLPermissionItem *testPermissionUpdated = [[SDLPermissionItem alloc] init];
                    testPermissionUpdated.rpcName = testRPCNameAllAllowed;
                    testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                    testPermissionUpdated.parameterPermissions = testParameterPermissions;

                    SDLOnPermissionsChange *testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                    testPermissionChangeUpdate.permissionItem = [NSArray arrayWithObject:testPermissionUpdated];

                    // Send the permission update
                    SDLRPCNotificationNotification *updatedNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangePermissionsNotification object:nil rpcNotification:testPermissionChangeUpdate];
                    [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];

                    expect(numberOfTimesObserverCalled).to(equal(2));

                    expect(testStatuses[0]).to(equal(SDLPermissionGroupStatusAllowed));
                    expect(changeDicts[0].allKeys).to(contain(testRPCNameAllAllowed));
                    SDLRPCPermissionStatus *isAllowed1 = changeDicts[0][testRPCNameAllAllowed];
                    expect(isAllowed1.rpcAllowed).to(beTrue());

                    expect(testStatuses[1]).to(equal(SDLPermissionGroupStatusDisallowed));
                    expect(changeDicts[1].allKeys).to(contain(testRPCNameAllAllowed));
                    SDLRPCPermissionStatus *isAllowed2 = changeDicts[1][testRPCNameAllAllowed];
                    expect(isAllowed2.rpcAllowed).to(beFalse());
                });

                it(@"should not notify the observer when permissions change from all-not-allowed (mixed) to all-not-allowed (disallowed)", ^{
                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementDisallowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                        [testStatuses addObject:@(status)];
                    }];

                    // Create a permission update disallowing our current HMI level for the observed permission
                    SDLParameterPermissions *testParameterPermissions = [[SDLParameterPermissions alloc] init];
                    SDLHMIPermissions *testHMIPermissionsUpdated = [[SDLHMIPermissions alloc] init];
                    testHMIPermissionsUpdated.allowed = @[];
                    testHMIPermissionsUpdated.userDisallowed = @[SDLHMILevelBackground, SDLHMILevelFull, SDLHMILevelLimited, SDLHMILevelNone];

                    SDLPermissionItem *testPermissionUpdated = [[SDLPermissionItem alloc] init];
                    testPermissionUpdated.rpcName = testRPCNameAllAllowed;
                    testPermissionUpdated.hmiPermissions = testHMIPermissionsUpdated;
                    testPermissionUpdated.parameterPermissions = testParameterPermissions;

                    SDLOnPermissionsChange *testPermissionChangeUpdate = [[SDLOnPermissionsChange alloc] init];
                    testPermissionChangeUpdate.permissionItem = [NSArray arrayWithObject:testPermissionUpdated];

                    // Send the permission update
                    SDLRPCNotificationNotification *updatedNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangePermissionsNotification object:nil rpcNotification:testPermissionChangeUpdate];
                    [[NSNotificationCenter defaultCenter] postNotification:updatedNotification];

                    expect(numberOfTimesObserverCalled).to(equal(0));
                    expect(changeDicts).to(beEmpty());
                    expect(testStatuses).to(beEmpty());
                });
            });
        });

        context(@"getting a new HMI level", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;
            __block NSMutableArray<NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> *> *changeDicts = nil;
            __block NSMutableArray<NSNumber<SDLUInt> *> *testStatuses = nil;

            beforeEach(^{
                numberOfTimesObserverCalled = 0;
                changeDicts = [NSMutableArray array];
                testStatuses = [NSMutableArray array];
            });

            context(@"with an ANY group type observer", ^{
                beforeEach(^{
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                        [testStatuses addObject:@(status)];
                    }];

                    // Upgrade the HMI level to LIMITED
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                });

                it(@"should notify the observer when the hmi level changes to allow or disallow any of the RPCs", ^{
                    expect(@(numberOfTimesObserverCalled)).to(equal(@2));

                    SDLRPCPermissionStatus *allAllowed1 = changeDicts[0][testRPCNameAllAllowed];
                    expect(allAllowed1.rpcAllowed).to(beTrue());
                    SDLRPCPermissionStatus *fullLimitedAllowed1 = changeDicts[0][testRPCNameFullLimitedAllowed];
                    expect(fullLimitedAllowed1.rpcAllowed).to(beFalse());
                    expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusMixed)));

                    SDLRPCPermissionStatus *allAllowed2 = changeDicts[1][testRPCNameAllAllowed];
                    expect(allAllowed2.rpcAllowed).to(beTrue());
                    SDLRPCPermissionStatus *fullLimitedAllowed2 = changeDicts[1][testRPCNameFullLimitedAllowed];
                    expect(fullLimitedAllowed2.rpcAllowed).to(beTrue());
                    expect(testStatuses[1]).to(equal(@(SDLPermissionGroupStatusAllowed)));
                });
            });

            context(@"with an All Allowed group type observer", ^{
                beforeEach(^{
                    // Post the notification before setting the observer to make sure data is already present
                    // HMI Full & Limited allowed, hmi level BACKGROUND
                    [[NSNotificationCenter defaultCenter] postNotification:backgroundHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                });

                it(@"should notify the observer when the hmi level changes the status from some-not-allowed to all-allowed", ^{
                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                        [testStatuses addObject:@(status)];
                    }];

                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];

                    expect(numberOfTimesObserverCalled).to(equal(1));
                    expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusAllowed)));
                });

                it(@"should notify the observer when the hmi level changes the status from all-allowed to some-not-allowed", ^{
                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementFullLimitedBackgroundAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                        [testStatuses addObject:@(status)];
                    }];

                    [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];

                    expect(numberOfTimesObserverCalled).to(equal(2));

                    expect(changeDicts[0].allKeys).to(contain(testRPCNameFullLimitedBackgroundAllowed));
                    SDLRPCPermissionStatus *allAllowed1 = changeDicts[0][testRPCNameFullLimitedBackgroundAllowed];
                    expect(allAllowed1.rpcAllowed).to(beTrue());
                    expect(testStatuses[0]).to(equal(@(SDLPermissionGroupStatusAllowed)));

                    expect(changeDicts[1].allKeys).to(contain(testRPCNameFullLimitedBackgroundAllowed));
                    SDLRPCPermissionStatus *allAllowed2 = changeDicts[1][testRPCNameFullLimitedBackgroundAllowed];
                    expect(allAllowed2.rpcAllowed).to(beFalse());
                    expect(testStatuses[1]).to(equal(@(SDLPermissionGroupStatusDisallowed)));
                });

                it(@"should not notify the observer when the hmi level changes but the status has not changed from all-allowed to some-not-allowed or from some-not-allowed to all-allowed", ^{
                    [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementFullLimitedBackgroundAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
                        numberOfTimesObserverCalled++;
                        [changeDicts addObject:updatedPermissionStatuses];
                        [testStatuses addObject:@(status)];
                    }];

                    [[NSNotificationCenter defaultCenter] postNotification:noneHMINotification];

                    expect(numberOfTimesObserverCalled).to(equal(0));
                    expect(changeDicts).to(beEmpty());
                    expect(testStatuses).to(beEmpty());
                });
            });
        });
    });

    describe(@"checking parameter permissions", ^{
        __block SDLRPCFunctionName someRPCFunctionName = nil;
        __block NSString *someRPCParameterName = nil;
        __block BOOL testResultBOOL = NO;

        context(@"when no permissions exist", ^{
            beforeEach(^{
                someRPCFunctionName = @"SomeRPCFunctionName";
                someRPCParameterName = @"SomeRPCParameterName";
                testResultBOOL = [testPermissionsManager isPermissionParameterAllowed:someRPCFunctionName parameter:someRPCParameterName];
            });

            it(@"should not be allowed", ^{
                expect(testResultBOOL).to(beFalse());
            });
        });

        context(@"when permissions exist but no HMI level", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
                testResultBOOL = [testPermissionsManager isPermissionParameterAllowed:testRPCNameAllAllowed parameter:testRPCParameterNameAllAllowed];
            });

            it(@"should not be allowed", ^{
                expect(testResultBOOL).to(beFalse());
            });
        });

        context(@"when permissions exist and HMI level exists", ^{
            context(@"and the parameter permission is allowed", ^{
                beforeEach(^{
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                    testResultBOOL = [testPermissionsManager isPermissionParameterAllowed:testRPCNameAllAllowed parameter:testRPCParameterNameAllAllowed];
                });

                it(@"should be allowed", ^{
                    expect(testResultBOOL).to(beTrue());
                });
            });

            context(@"and the parameter permission is denied", ^{
                beforeEach(^{
                    [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                    [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                    testResultBOOL = [testPermissionsManager isPermissionParameterAllowed:testRPCNameAllDisallowed parameter:testRPCParameterNameAllDisallowed];
                });

                it(@"should not be allowed", ^{
                    expect(testResultBOOL).to(beFalse());
                });
            });

            context(@"when user disallowed parameter permissions is not nil", ^{
                context(@"and the parameter is disallowed", ^{
                    beforeEach(^{
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                    testResultBOOL = [testPermissionsManager isPermissionParameterAllowed:testRPCNameFullLimitedAllowed parameter:testRPCParameterNameAllDisallowed];
                    });

                    it(@"should not be allowed", ^{
                        expect(testResultBOOL).to(beFalse());
                    });
                });

                context(@"and the parameter is allowed", ^{
                    beforeEach(^{
                        [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                        [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];

                        testResultBOOL = [testPermissionsManager isPermissionParameterAllowed:testRPCNameFullLimitedAllowed parameter:testRPCParameterNameAllAllowed];
                    });

                    it(@"should be allowed", ^{
                        expect(testResultBOOL).to(beTrue());
                    });
                });
            });
        });
    });

    describe(@"removing observers", ^{
        context(@"removing the only observer", ^{
            __block NSInteger numberOfTimesObserverCalled = 0;

            beforeEach(^{
                // Add observer
                SDLPermissionObserverIdentifier observerIdentifier = [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber *> * _Nonnull change, SDLPermissionGroupStatus status) {
                    numberOfTimesObserverCalled++;
                }];

                // Remove the observer
                [testPermissionsManager removeObserverForIdentifier:observerIdentifier];

                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });

            it(@"should call the observer once (it should be called immediately after the subscription due to the `groupType` being set to `any`)", ^{
                expect(numberOfTimesObserverCalled).to(equal(1));
            });
        });

        context(@"removing a single observer and leaving one remaining", ^{
            __block NSInteger numberOfTimesObserver1Called = 0;
            __block NSInteger numberOfTimesObserver2Called = 0;

            beforeEach(^{
                // Add two observers
                SDLPermissionObserverIdentifier observerIdentifier1 = [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber *> * _Nonnull change, SDLPermissionGroupStatus status) {
                    numberOfTimesObserver1Called++;
                }];

                [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber *> * _Nonnull change, SDLPermissionGroupStatus status) {
                    numberOfTimesObserver2Called++;
                }];

                // Remove one of the observers
                [testPermissionsManager removeObserverForIdentifier:observerIdentifier1];

                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });

            it(@"should call the observers a total three times (the first two should be called immediately after the subscription due to the `groupType` being set to `any`)", ^{
                expect(numberOfTimesObserver1Called).to(equal(1));
                expect(numberOfTimesObserver2Called).to(equal(2));
            });
        });

        context(@"removing all observers", ^{
            __block NSInteger numberOfTimesObserver1Called = 0;
            __block NSInteger numberOfTimesObserver2Called = 0;

            beforeEach(^{
                // Add two observers
                [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber *> * _Nonnull change, SDLPermissionGroupStatus status) {
                    numberOfTimesObserver1Called++;
                }];

                [testPermissionsManager subscribeToRPCPermissions:@[testPermissionElementAllAllowed, testPermissionElementFullLimitedAllowed] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber *> * _Nonnull change, SDLPermissionGroupStatus status) {
                    numberOfTimesObserver2Called++;
                }];

                // Remove all observers
                [testPermissionsManager removeAllObservers];

                // Post a notification
                [[NSNotificationCenter defaultCenter] postNotification:limitedHMINotification];
                [[NSNotificationCenter defaultCenter] postNotification:testPermissionsNotification];
            });

            it(@"should call each observer once (it should be called immediately after the subscription due to the `groupType` being set to `any`)", ^{
                expect(numberOfTimesObserver1Called).to(equal(1));
                expect(numberOfTimesObserver2Called).to(equal(1));
            });
        });
    });
});

QuickSpecEnd
