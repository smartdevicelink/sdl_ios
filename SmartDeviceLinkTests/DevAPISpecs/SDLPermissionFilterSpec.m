#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPermissionConstants.h"
#import "SDLPermissionFilter.h"

QuickSpecBegin(SDLPermissionFilterSpec)

describe(@"A filter", ^{
    __block NSString *testRPCName1 = nil;
    __block NSString *testRPCName2 = nil;
    
    beforeEach(^{
        testRPCName1 = @"testRPCName1";
        testRPCName2 = @"testRPCName2";
    });
    
    describe(@"should initialize correctly", ^{
        __block NSArray<SDLPermissionRPCName> *testRPCNames = nil;
        __block SDLPermissionGroupType testGroupType = SDLPermissionGroupTypeAny;
        __block SDLPermissionFilter *testFilter = nil;
        
        __block NSDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> *testObserverReturnChangedDict = nil;
        
        beforeEach(^{
            testRPCNames = @[testRPCName1, testRPCName2];
            testGroupType = SDLPermissionGroupTypeAny;
        });
        
        context(@"using initWithRPCNames:changeType:observer:", ^{
            beforeEach(^{
                testFilter = [[SDLPermissionFilter alloc] initWithRPCNames:testRPCNames groupType:testGroupType observer:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    testObserverReturnChangedDict = changedDict;
                }];
            });
            
            it(@"should set the rpcNames array correctly", ^{
                expect(testFilter.rpcNames).to(equal(testRPCNames));
            });
            
            describe(@"it should set up the observer correctly", ^{
                __block NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> *testObserverChangedDict = nil;
                __block NSNumber<SDLBool> *testRPCName1Bool = nil;
                __block NSNumber<SDLBool> *testRPCName2Bool = nil;
                __block SDLPermissionGroupStatus testObserverGroupStatus = SDLPermissionGroupStatusUnknown;
                
                beforeEach(^{
                    testRPCName1Bool = @YES;
                    testRPCName2Bool = @NO;
                    testObserverChangedDict = @{testRPCName1: testRPCName1Bool,
                                                testRPCName2: testRPCName2Bool};
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
                testFilter = [SDLPermissionFilter filterWithRPCNames:testRPCNames groupType:testGroupType observer:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {
                    testObserverReturnChangedDict = changedDict;
                }];
            });
            
            it(@"should set the rpcNames array correctly", ^{
                expect(testFilter.rpcNames).to(equal(testRPCNames));
            });
            
            describe(@"it should set up the observer correctly", ^{
                __block NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> *testObserverChangedDict = nil;
                __block NSNumber<SDLBool> *testRPCName1Bool = nil;
                __block NSNumber<SDLBool> *testRPCName2Bool = nil;
                __block SDLPermissionGroupStatus testObserverGroupStatus = SDLPermissionGroupStatusUnknown;
                
                beforeEach(^{
                    testRPCName1Bool = @YES;
                    testRPCName2Bool = @NO;
                    testObserverChangedDict = @{testRPCName1: testRPCName1Bool,
                                                testRPCName2: testRPCName2Bool};
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
            testFilter = [SDLPermissionFilter filterWithRPCNames:@[testRPCName1] groupType:SDLPermissionGroupTypeAny observer:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {}];
            testCopiedFilter = [testFilter copy];
        });
        
        it(@"should say copied filters are not the same instance", ^{
            expect(testCopiedFilter).toNot(beIdenticalTo(testFilter));
        });
        
        it(@"should copy the identifier correctly", ^{
            expect(testCopiedFilter.identifier).to(equal(testFilter.identifier));
        });
        
        it(@"should copy the filter array correctly", ^{
            expect(testCopiedFilter.rpcNames).to(equal(testFilter.rpcNames));
        });
        
        it(@"should copy the change type correctly", ^{
            expect(@(testCopiedFilter.groupType)).to(equal(@(testFilter.groupType)));
        });
        
        it(@"should copy the observer correctly", ^{
            expect(testCopiedFilter.handler).to(equal(testFilter.handler));
        });
    });
    
    describe(@"testing equality", ^{
        __block SDLPermissionFilter *testSameFilter1 = nil;
        __block SDLPermissionFilter *testSameFilter2 = nil;
        __block SDLPermissionFilter *testDifferentFilter = nil;
        
        beforeEach(^{
            testSameFilter1 = [SDLPermissionFilter filterWithRPCNames:@[testRPCName1] groupType:SDLPermissionGroupTypeAny observer:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {}];
            testSameFilter2 = [testSameFilter1 copy];
            
            testDifferentFilter = [SDLPermissionFilter filterWithRPCNames:@[testRPCName1] groupType:SDLPermissionGroupTypeAny observer:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionGroupStatus status) {}];
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
