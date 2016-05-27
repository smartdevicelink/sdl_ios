#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGlobals.h"

QuickSpecBegin(SDLGlobalsSpec)

describe(@"The SDLGlobals class", ^{
    __block SDLGlobals *testGlobals = nil;
    __block NSNumber *v1And2MTUSize = @1024;
    __block NSNumber *v3And4MTUSize = @131084;
    
    beforeEach(^{
        testGlobals = [[SDLGlobals alloc] init];
    });
    
    describe(@"when just initialized", ^{
        it(@"should properly set protocol version", ^{
            expect(@(testGlobals.protocolVersion)).to(equal(@1));
        });
        
        it(@"should properly set max head unit version", ^{
            expect(@(testGlobals.maxHeadUnitVersion)).to(equal(@0));
        });
        
        it(@"should throw an exception trying to get max MTU size", ^{
            expect(@(testGlobals.maxMTUSize)).to(equal(v1And2MTUSize));
        });
    });
    
    describe(@"setting maxHeadUnitVersion should alter negotiated protocol version", ^{
        it(@"should use the max head unit version when lower than max proxy version", ^{
            NSUInteger someIntLowerThanMaxProxyVersion = 2;
            testGlobals.maxHeadUnitVersion = someIntLowerThanMaxProxyVersion;
            expect(@(testGlobals.protocolVersion)).to(equal(@(someIntLowerThanMaxProxyVersion)));
            expect(@(testGlobals.maxHeadUnitVersion)).to(equal(@(someIntLowerThanMaxProxyVersion)));
        });
        
        it(@"should use the max proxy version when lower than max head unit version", ^{
            NSUInteger someIntHigherThanMaxProxyVersion = 1000;
            testGlobals.maxHeadUnitVersion = someIntHigherThanMaxProxyVersion;
            expect(@(testGlobals.protocolVersion)).to(beLessThan(@(someIntHigherThanMaxProxyVersion)));
            expect(@(testGlobals.maxHeadUnitVersion)).to(equal(@(someIntHigherThanMaxProxyVersion)));
        });
    });
    
    describe(@"getting the max MTU version", ^{
        context(@"when protocol version is 1 - 2", ^{
            it(@"should return the correct value when protocol version is 1", ^{
                testGlobals.maxHeadUnitVersion = 1;
                expect(@(testGlobals.maxMTUSize)).to(equal(v1And2MTUSize));
            });
            
            it(@"should return the correct value when protocol version is 2", ^{
                testGlobals.maxHeadUnitVersion = 2;
                expect(@(testGlobals.maxMTUSize)).to(equal(v1And2MTUSize));
            });
        });
        
        context(@"when protocol version is 3 - 4", ^{
            it(@"should return the correct value when protocol version is 3", ^{
                testGlobals.maxHeadUnitVersion = 3;
                expect(@(testGlobals.maxMTUSize)).to(equal(v3And4MTUSize));
            });
            
            it(@"should return the correct value when protocol version is 4", ^{
                testGlobals.maxHeadUnitVersion = 4;
                expect(@(testGlobals.maxMTUSize)).to(equal(v3And4MTUSize));
            });
            
            describe(@"when the max proxy version is lower than max head unit version", ^{
                beforeEach(^{
                    NSUInteger someIntHigherThanMaxProxyVersion = 1000;
                    testGlobals.maxHeadUnitVersion = someIntHigherThanMaxProxyVersion;
                });
                
                it(@"should return the v1 - 2 value", ^{
                    expect(@(testGlobals.maxMTUSize)).to(equal(v1And2MTUSize));
                });
            });
        });
    });
});

QuickSpecEnd
