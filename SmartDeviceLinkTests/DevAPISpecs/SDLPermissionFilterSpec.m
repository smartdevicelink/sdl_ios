#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPermissionConstants.h"
#import "SDLPermissionElement.h"
#import "SDLPermissionFilter.h"

QuickSpecBegin(SDLPermissionFilterSpec)

fdescribe(@"A filter", ^{
    __block NSString *testRPCName1 = nil;
    __block NSString *testRPCName2 = nil;
    __block SDLPermissionElement *testPermissionElement1 = nil;
    __block SDLPermissionElement *testPermissionElement2 = nil;
    
    beforeEach(^{
        testRPCName1 = @"testRPCName1";
        testRPCName2 = @"testRPCName2";
        testPermissionElement1 = [[SDLPermissionElement alloc] initWithRPCName:testRPCName1 parameterPermissions:nil];
        testPermissionElement2 = [[SDLPermissionElement alloc] initWithRPCName:testRPCName2 parameterPermissions:nil];
    });
    
    describe(@"should initialize correctly", ^{
        __block NSArray<SDLPermissionElement *> *testPermissionElements = nil;
        __block SDLPermissionGroupType testGroupType = SDLPermissionGroupTypeAny;
        __block SDLPermissionFilter *testFilter = nil;
        
        __block NSDictionary<SDLPermissionElement *, NSNumber<SDLBool> *> *testObserverReturnChangedDict = nil;
        
        beforeEach(^{
            testPermissionElements = @[testPermissionElement1, testPermissionElement2];
            testGroupType = SDLPermissionGroupTypeAny;
        });
        
        context(@"using initWithRPCNames:changeType:observer:", ^{
            beforeEach(^{
                testFilter = [[SDLPermissionFilter alloc] initWithRPCNames:testPermissionElements groupType:testGroupType observer:^(NSDictionary<SDLPermissionElement *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    testObserverReturnChangedDict = changedDict;
                }];
            });
            
            it(@"should set the rpcNames array correctly", ^{
                expect(testFilter.permissionElements).to(equal(testPermissionElements));
            });
            
            describe(@"it should set up the observer correctly", ^{
                __block NSDictionary<SDLPermissionElement*,NSNumber<SDLBool> *> *testObserverChangedDict = nil;
                __block NSNumber<SDLBool> *testRPCName1Bool = nil;
                __block NSNumber<SDLBool> *testRPCName2Bool = nil;
                __block SDLPermissionGroupStatus testObserverGroupStatus = SDLPermissionGroupStatusUnknown;
                
                beforeEach(^{
                    testRPCName1Bool = @YES;
                    testRPCName2Bool = @NO;
                    testObserverChangedDict = @{testPermissionElement1: testRPCName1Bool,
                                                testPermissionElement2: testRPCName2Bool};
                    testObserverGroupStatus = SDLPermissionGroupStatusMixed;
                    
                    testFilter.handler(testObserverChangedDict, testObserverGroupStatus);
                });
                
                it(@"should call the changedDict correctly", ^{
                    expect(testObserverReturnChangedDict).to(equal(testObserverChangedDict));
                });
                
                it(@"should call the status correctly", ^{
                    expect(@(testObserverGroupStatus)).to(equal(@(testObserverGroupStatus)));
                });
            });
        });
        
        context(@"using filterWithRPCNames:changeType:observer:", ^{
            beforeEach(^{
                testFilter = [SDLPermissionFilter filterWithRPCNames:testPermissionElements groupType:testGroupType observer:^(NSDictionary<SDLPermissionElement *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    testObserverReturnChangedDict = changedDict;
                }];
            });
            
            it(@"should set the rpcNames array correctly", ^{
                expect(testFilter.permissionElements).to(equal(testPermissionElements));
            });
            
            describe(@"it should set up the observer correctly", ^{
                __block NSDictionary<SDLPermissionElement*,NSNumber<SDLBool> *> *testObserverChangedDict = nil;
                __block NSNumber<SDLBool> *testRPCName1Bool = nil;
                __block NSNumber<SDLBool> *testRPCName2Bool = nil;
                __block SDLPermissionGroupStatus testObserverGroupStatus = SDLPermissionGroupStatusUnknown;
                
                beforeEach(^{
                    testRPCName1Bool = @YES;
                    testRPCName2Bool = @NO;
                    testObserverChangedDict = @{testPermissionElement1: testRPCName1Bool,
                                                testPermissionElement2: testRPCName2Bool};
                    testObserverGroupStatus = SDLPermissionGroupStatusMixed;
                    
                    testFilter.handler(testObserverChangedDict, testObserverGroupStatus);
                });
                
                it(@"should call the changedDict correctly", ^{
                    expect(testObserverReturnChangedDict).to(equal(testObserverChangedDict));
                });
                
                it(@"should call the status correctly", ^{
                    expect(@(testObserverGroupStatus)).to(equal(@(testObserverGroupStatus)));
                });
            });
        });
    });
    
    describe(@"copying a filter", ^{
        __block SDLPermissionFilter *testFilter = nil;
        __block SDLPermissionFilter *testCopiedFilter = nil;
        
        beforeEach(^{
            testFilter = [SDLPermissionFilter filterWithRPCNames:@[testPermissionElement1] groupType:SDLPermissionGroupTypeAny observer:^(NSDictionary<SDLPermissionElement *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {}];
            testCopiedFilter = [testFilter copy];
        });
        
        it(@"should say copied filters are not the same instance", ^{
            expect(testCopiedFilter).toNot(beIdenticalTo(testFilter));
        });
        
        it(@"should copy the identifier correctly", ^{
            expect(testCopiedFilter.identifier).to(equal(testFilter.identifier));
        });
        
        it(@"should copy the filter array correctly", ^{
            expect(testCopiedFilter.permissionElements).to(equal(testFilter.permissionElements));
        });
        
        it(@"should copy the change type correctly", ^{
            expect(@(testCopiedFilter.groupType)).to(equal(@(testFilter.groupType)));
        });
    });
    
    describe(@"testing equality", ^{
        __block SDLPermissionFilter *testSameFilter1 = nil;
        __block SDLPermissionFilter *testSameFilter2 = nil;
        __block SDLPermissionFilter *testDifferentFilter = nil;
        
        beforeEach(^{
            testSameFilter1 = [SDLPermissionFilter filterWithRPCNames:@[testPermissionElement1] groupType:SDLPermissionGroupTypeAny observer:^(NSDictionary<SDLPermissionElement *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {}];
            testSameFilter2 = [testSameFilter1 copy];
            
            testDifferentFilter = [SDLPermissionFilter filterWithRPCNames:@[testPermissionElement1] groupType:SDLPermissionGroupTypeAny observer:^(NSDictionary<SDLPermissionElement *,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {}];
        });
        
        it(@"should say copied filters are the same", ^{
            expect(testSameFilter1).to(equal(testSameFilter2));
        });
        
        it(@"should say new filters are different", ^{
            expect(testSameFilter1).toNot(equal(testDifferentFilter));
        });
    });
});

QuickSpecEnd
