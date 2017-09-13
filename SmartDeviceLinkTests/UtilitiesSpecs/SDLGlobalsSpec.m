#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGlobals.h"

QuickSpecBegin(SDLGlobalsSpec)

describe(@"The SDLGlobals class", ^{
    __block SDLGlobals *testGlobals = nil;
    
    beforeEach(^{
        testGlobals = [[SDLGlobals alloc] init];
    });
    
    describe(@"when just initialized", ^{
        it(@"should properly set protocol version", ^{
            expect(testGlobals.protocolVersion).to(equal(@"1.0.0"));
        });

        it(@"should properly set the major protocol version", ^{
            expect(testGlobals.majorProtocolVersion).to(equal(1));
        });
        
        it(@"should properly set max head unit version", ^{
            expect(testGlobals.maxHeadUnitVersion).to(equal(@"0.0.0"));
        });
        
        it(@"should give the v1 MTU size", ^{
            expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(SDLV1MTUSize));
        });
    });
    
    describe(@"setting maxHeadUnitVersion should alter negotiated protocol version", ^{
        it(@"should use the max head unit version when lower than max proxy version", ^{
            NSString *someVersionLowerThanMaxProxyVersion = @"2.0.0";
            testGlobals.maxHeadUnitVersion = someVersionLowerThanMaxProxyVersion;

            expect(testGlobals.protocolVersion).to(equal(someVersionLowerThanMaxProxyVersion));
            expect(testGlobals.maxHeadUnitVersion).to(equal(someVersionLowerThanMaxProxyVersion));
        });
        
        it(@"should use the max proxy version when lower than max head unit version", ^{
            NSString *someVersionHigherThanMaxProxyVersion = @"1000.0.0";
            testGlobals.maxHeadUnitVersion = someVersionHigherThanMaxProxyVersion;

            expect(([testGlobals.protocolVersion compare:someVersionHigherThanMaxProxyVersion options:NSNumericSearch] == NSOrderedDescending)).to(beFalsy());
            expect(testGlobals.maxHeadUnitVersion).to(equal(someVersionHigherThanMaxProxyVersion));
        });
    });
    
    describe(@"getting the max MTU version", ^{
        context(@"when protocol version is 1 - 2", ^{
            it(@"should return the correct value when protocol version is 1", ^{
                testGlobals.maxHeadUnitVersion = @"1.0.0";
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(SDLV1MTUSize));
            });
            
            it(@"should return the correct value when protocol version is 2", ^{
                testGlobals.maxHeadUnitVersion = @"2.0.0";
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(SDLV1MTUSize));
            });
        });
        
        context(@"when protocol version is 3 - 4", ^{
            it(@"should return the correct value when protocol version is 3", ^{
                testGlobals.maxHeadUnitVersion = @"3.0.0";
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(SDLV3MTUSize));
            });
            
            it(@"should return the correct value when protocol version is 4", ^{
                testGlobals.maxHeadUnitVersion = @"4.0.0";
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(SDLV3MTUSize));
            });
            
            describe(@"when the max proxy version is lower than max head unit version", ^{
                beforeEach(^{
                    NSString *someVersionHigherThanMaxProxyVersion = @"1000.0.0";
                    testGlobals.maxHeadUnitVersion = someVersionHigherThanMaxProxyVersion;
                });
                
                it(@"should return the v1 - 2 value", ^{
                    expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(SDLV1MTUSize));
                });
            });
        });
    });

#pragma mark Dynamic MTU
    describe(@"when dynamically setting MTU on protocol version 5", ^{
        __block NSUInteger dynamicMTUSize1 = 12345;
        __block NSUInteger dynamicMTUSize2 = 54321;

        beforeEach(^{
            testGlobals.maxHeadUnitVersion = @"5.0.0";
        });

        context(@"Setting the RPC service MTU", ^{
            beforeEach(^{
                [testGlobals setDynamicMTUSize:dynamicMTUSize1 forServiceType:SDLServiceType_RPC];
            });

            it(@"should set the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(dynamicMTUSize1));
            });

            it(@"should have the video service fall back to the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_Video]).to(equal(dynamicMTUSize1));
            });
        });

        context(@"setting the video service MTU", ^{
            beforeEach(^{
                [testGlobals setDynamicMTUSize:dynamicMTUSize1 forServiceType:SDLServiceType_Video];
            });

            it(@"should not set the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(SDLV3MTUSize));
            });

            it(@"should have the video service fall back to the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_Video]).to(equal(dynamicMTUSize1));
            });
        });

        context(@"setting both the video service and RPC service MTU", ^{
            beforeEach(^{
                [testGlobals setDynamicMTUSize:dynamicMTUSize1 forServiceType:SDLServiceType_RPC];
                [testGlobals setDynamicMTUSize:dynamicMTUSize2 forServiceType:SDLServiceType_Video];
            });

            it(@"should set the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_RPC]).to(equal(dynamicMTUSize1));
            });

            it(@"should have the video service fall back to the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceType_Video]).to(equal(dynamicMTUSize2));
            });
        });
    });
});

QuickSpecEnd
