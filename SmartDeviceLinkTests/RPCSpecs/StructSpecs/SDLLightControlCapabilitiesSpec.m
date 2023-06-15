//
//  SDLLightControlCapabilitiesSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLLightControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "SDLLightCapabilities.h"

QuickSpecBegin( SDLLightControlCapabilitiesSpec)

SDLLightCapabilities* somelightCapabilities = [[SDLLightCapabilities alloc] init];

describe(@"Getter/Setter Tests", ^ {
    __block SDLModuleInfo *testModuleInfo = nil;
    __block SDLGrid *testGird = nil;
    
    beforeEach(^{
        testGird.col = @0;
        testGird.row = @0;
        testGird.level = @0;
        testGird.rowspan = @2;
        testGird.colspan = @3;
        testGird.levelspan = @1;
        testModuleInfo = [[SDLModuleInfo alloc] init];
        testModuleInfo.moduleId = @"123";
        testModuleInfo.allowMultipleAccess = @YES;
        testModuleInfo.serviceArea = testGird;
        testModuleInfo.location = testGird;
    });

    it(@"Should set and get correctly", ^ {
        SDLLightControlCapabilities* testStruct = [[SDLLightControlCapabilities alloc] init];

        testStruct.moduleName = @"moduleName";
        testStruct.moduleInfo = testModuleInfo;
        testStruct.supportedLights = [@[somelightCapabilities] copy];

        expect(testStruct.moduleName).to(equal(@"moduleName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.supportedLights).to(equal([@[somelightCapabilities] copy]));

    });

    it(@"Should set and get correctly", ^ {
        SDLLightControlCapabilities* testStruct = [[SDLLightControlCapabilities alloc] initWithModuleName:@"moduleName" moduleInfo:testModuleInfo supportedLights:[@[somelightCapabilities] copy]];
        
        expect(testStruct.moduleName).to(equal(@"moduleName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.supportedLights).to(equal([@[somelightCapabilities] copy]));
        
    });

    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameModuleName:@"moduleName",
                                       SDLRPCParameterNameModuleInfo:testModuleInfo,
                                       SDLRPCParameterNameSupportedLights:[@[somelightCapabilities] copy]
                                       };
        SDLLightControlCapabilities *testStruct = [[SDLLightControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(@"moduleName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.supportedLights).to(equal([@[somelightCapabilities] copy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLLightControlCapabilities* testStruct = [[SDLLightControlCapabilities alloc] init];

        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.supportedLights).to(beNil());
    });
});

QuickSpecEnd
