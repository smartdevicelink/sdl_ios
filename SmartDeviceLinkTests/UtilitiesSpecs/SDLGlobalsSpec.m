#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGlobals.h"
#import "SDLVersion.h"

QuickSpecBegin(SDLGlobalsSpec)

describe(@"The SDLGlobals class", ^{
    __block SDLGlobals *testGlobals = nil;
    
    beforeEach(^{
        testGlobals = [[SDLGlobals alloc] init];
    });
    
    describe(@"when just initialized", ^{
        it(@"should properly set parameters", ^{
            expect(testGlobals.protocolVersion.stringVersion).to(equal(@"1.0.0"));
            expect(testGlobals.protocolVersion.major).to(equal(1));
            expect(testGlobals.maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
            expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(SDLV1MTUSize));
            expect(testGlobals.rpcVersion).to(equal([[SDLVersion alloc] initWithMajor:1 minor:0 patch:0]));
        });
    });
    
    describe(@"setting maxHeadUnitVersion should alter negotiated protocol version", ^{
        it(@"should use the max head unit version when lower than max proxy version", ^{
            SDLVersion *someVersionLowerThanMaxProxyVersion = [SDLVersion versionWithString:@"2.0.0"];
            testGlobals.maxHeadUnitProtocolVersion = someVersionLowerThanMaxProxyVersion;

            expect(testGlobals.protocolVersion).to(equal(someVersionLowerThanMaxProxyVersion));
            expect(testGlobals.maxHeadUnitProtocolVersion).to(equal(someVersionLowerThanMaxProxyVersion));
        });
        
        it(@"should use the max proxy version when lower than max head unit version", ^{
            SDLVersion *someVersionHigherThanMaxProxyVersion = [SDLVersion versionWithString:@"1000.0.0"];
            testGlobals.maxHeadUnitProtocolVersion = someVersionHigherThanMaxProxyVersion;

            expect([testGlobals.protocolVersion isGreaterThanVersion:someVersionHigherThanMaxProxyVersion]).to(beFalse());
            expect(testGlobals.maxHeadUnitProtocolVersion).to(equal(someVersionHigherThanMaxProxyVersion));
        });
    });

    describe(@"test values after calling sdl_resetProtocolVersion", ^{
        beforeEach(^{
            [testGlobals reset];
        });

        it(@"should return should properly set values", ^{
            expect(testGlobals.protocolVersion.stringVersion).to(equal(@"1.0.0"));
            expect(testGlobals.protocolVersion.major).to(equal(1));
            expect(testGlobals.maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
            expect(testGlobals.rpcVersion).to(equal([[SDLVersion alloc] initWithMajor:1 minor:0 patch:0]));
        });
    });
    
    describe(@"getting the max MTU version", ^{
        context(@"when protocol version is 1 - 2", ^{
            it(@"should return the correct value when protocol version is 1", ^{
                testGlobals.maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"1.0.0"];
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(SDLV1MTUSize));
            });
            
            it(@"should return the correct value when protocol version is 2", ^{
                testGlobals.maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"2.0.0"];
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(SDLV1MTUSize));
            });
        });
        
        context(@"when protocol version is 3 - 4", ^{
            it(@"should return the correct value when protocol version is 3", ^{
                testGlobals.maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"3.0.0"];
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(SDLV3MTUSize));
            });
            
            it(@"should return the correct value when protocol version is 4", ^{
                testGlobals.maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"4.0.0"];
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(SDLV3MTUSize));
            });
            
            describe(@"when the max proxy version is lower than max head unit version", ^{
                beforeEach(^{
                    SDLVersion *someVersionHigherThanMaxProxyVersion = [SDLVersion versionWithString:@"1000.0.0"];
                    testGlobals.maxHeadUnitProtocolVersion = someVersionHigherThanMaxProxyVersion;
                });
                
                it(@"should return the v1 - 2 value", ^{
                    expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(SDLV1MTUSize));
                });
            });
        });
    });

#pragma mark Dynamic MTU
    describe(@"when dynamically setting MTU on protocol version 5", ^{
        __block NSUInteger dynamicMTUSize1 = 12345;
        __block NSUInteger dynamicMTUSize2 = 54321;

        beforeEach(^{
            testGlobals.maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"5.0.0"];
        });

        context(@"Setting the RPC service MTU", ^{
            beforeEach(^{
                [testGlobals setDynamicMTUSize:dynamicMTUSize1 forServiceType:SDLServiceTypeRPC];
            });

            it(@"should set the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(dynamicMTUSize1));
            });

            it(@"should have the video service fall back to the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeVideo]).to(equal(dynamicMTUSize1));
            });
        });

        context(@"setting the video service MTU", ^{
            beforeEach(^{
                [testGlobals setDynamicMTUSize:dynamicMTUSize1 forServiceType:SDLServiceTypeVideo];
            });

            it(@"should not set the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(SDLV3MTUSize));
            });

            it(@"should have the video service fall back to the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeVideo]).to(equal(dynamicMTUSize1));
            });
        });

        context(@"setting both the video service and RPC service MTU", ^{
            beforeEach(^{
                [testGlobals setDynamicMTUSize:dynamicMTUSize1 forServiceType:SDLServiceTypeRPC];
                [testGlobals setDynamicMTUSize:dynamicMTUSize2 forServiceType:SDLServiceTypeVideo];
            });

            it(@"should set the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeRPC]).to(equal(dynamicMTUSize1));
            });

            it(@"should have the video service fall back to the RPC service MTU", ^{
                expect([testGlobals mtuSizeForServiceType:SDLServiceTypeVideo]).to(equal(dynamicMTUSize2));
            });
        });
    });
});

QuickSpecEnd
