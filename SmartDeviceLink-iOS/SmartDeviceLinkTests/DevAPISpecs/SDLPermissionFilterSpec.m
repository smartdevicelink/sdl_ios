#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "NSNumber+NumberType.h"
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
        __block NSUUID *testFilterId = nil;
        __block NSArray<SDLPermissionRPCName *> *testRPCNames = nil;
        __block SDLPermissionChangeType testChangeType = SDLPermissionChangeTypeAny;
        __block SDLPermissionFilter *testFilter = nil;
        
        __block NSDictionary *testObserverReturnChangedDict = nil;
        __block SDLPermissionChangeType testObserverReturnChangeType = SDLPermissionChangeTypeAny;
        
        beforeEach(^{
            testRPCNames = @[testRPCName1, testRPCName2];
            testChangeType = SDLPermissionChangeTypeAllAllowed;
        });
        
        context(@"using initWithRPCNames:changeType:observer:", ^{
            beforeEach(^{
                testFilter = [[SDLPermissionFilter alloc] initWithRPCNames:testRPCNames changeType:testChangeType observer:^(NSDictionary<SDLPermissionRPCName *, NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                    testObserverReturnChangedDict = changedDict;
                    testObserverReturnChangeType = changeType;
                }];
            });
            
            it(@"should initialize the identifier as an NSUUID", ^{
                expect(testFilter.identifier).to(beAnInstanceOf([NSUUID class]));
            });
            
            it(@"should set the rpcNames array correctly", ^{
                expect(testFilter.rpcNames).to(equal(testRPCNames));
            });
            
            it(@"should set the change type correctly", ^{
                expect(@(testFilter.changeType)).to(equal(@(testChangeType)));
            });
            
            describe(@"it should set up the observer correctly", ^{
                __block NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> *testObserverChangedDict = nil;
                __block NSNumber<SDLBool> *testRPCName1Bool = nil;
                __block NSNumber<SDLBool> *testRPCName2Bool = nil;
                __block SDLPermissionChangeType testObserverChangeType = SDLPermissionChangeTypeAny;
                
                beforeEach(^{
                    testRPCName1Bool = @YES;
                    testRPCName2Bool = @NO;
                    testObserverChangedDict = @{testRPCName1: testRPCName1Bool,
                                                testRPCName2: testRPCName2Bool};
                    testObserverChangeType = SDLPermissionChangeTypeAllAllowed;
                    
                    testFilter.observer(testObserverChangedDict, testObserverChangeType);
                });
                
                it(@"should call the changedDict correctly", ^{
                    expect(testObserverReturnChangedDict).to(equal(testObserverChangedDict));
                });
                
                it(@"should call the changeType correctly", ^{
                    expect(@(testObserverReturnChangeType)).to(equal(@(testObserverChangeType)));
                });
            });
        });
        
        context(@"using filterWithRPCNames:changeType:observer:", ^{
            beforeEach(^{
                testFilter = [SDLPermissionFilter filterWithRPCNames:testRPCNames changeType:testChangeType observer:^(NSDictionary<SDLPermissionRPCName *, NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionChangeType changeType) {
                    testObserverReturnChangedDict = changedDict;
                    testObserverReturnChangeType = changeType;
                }];
            });
            
            it(@"should initialize the identifier as an NSUUID", ^{
                expect(testFilter.identifier).to(beAnInstanceOf([NSUUID class]));
            });
            
            it(@"should set the rpcNames array correctly", ^{
                expect(testFilter.rpcNames).to(equal(testRPCNames));
            });
            
            it(@"should set the change type correctly", ^{
                expect(@(testFilter.changeType)).to(equal(@(testChangeType)));
            });
            
            describe(@"it should set up the observer correctly", ^{
                __block NSDictionary<SDLPermissionRPCName *,NSNumber<SDLBool> *> *testObserverChangedDict = nil;
                __block NSNumber<SDLBool> *testRPCName1Bool = nil;
                __block NSNumber<SDLBool> *testRPCName2Bool = nil;
                __block SDLPermissionChangeType testObserverChangeType = SDLPermissionChangeTypeAny;
                
                beforeEach(^{
                    testRPCName1Bool = @YES;
                    testRPCName2Bool = @NO;
                    testObserverChangedDict = @{testRPCName1: testRPCName1Bool,
                                                testRPCName2: testRPCName2Bool};
                    testObserverChangeType = SDLPermissionChangeTypeAllAllowed;
                    
                    testFilter.observer(testObserverChangedDict, testObserverChangeType);
                });
                
                it(@"should call the changedDict correctly", ^{
                    expect(testObserverReturnChangedDict).to(equal(testObserverChangedDict));
                });
                
                it(@"should call the changeType correctly", ^{
                    expect(@(testObserverReturnChangeType)).to(equal(@(testObserverChangeType)));
                });
            });
        });
    });
    
    describe(@"copying a filter", ^{
        
    });
});

QuickSpecEnd
