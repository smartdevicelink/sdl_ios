//
//  SDLClimateControlCapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLClimateControlCapabilities.h"
#import "SDLDefrostZone.h"
#import "SDLRPCParameterNames.h"
#import "SDLVentilationMode.h"


QuickSpecBegin(SDLClimateControlCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    __block NSString *testModuleName = @"Name";
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
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] init];
        testStruct.moduleName = testModuleName;
        testStruct.moduleInfo = testModuleInfo;
        testStruct.fanSpeedAvailable = @YES;
        testStruct.desiredTemperatureAvailable = @NO;
        testStruct.acEnableAvailable = @NO;
        testStruct.acMaxEnableAvailable = @NO;
        testStruct.circulateAirEnableAvailable = @YES;
        testStruct.autoModeEnableAvailable = @NO;
        testStruct.dualModeEnableAvailable = @NO;
        testStruct.defrostZoneAvailable = @YES;
        testStruct.defrostZone = [@[SDLDefrostZoneFront] copy];
        testStruct.ventilationModeAvailable = @NO;
        testStruct.ventilationMode = [@[SDLVentilationModeUpper] copy];
        testStruct.heatedSteeringWheelAvailable = @(YES);
        testStruct.heatedWindshieldAvailable = @(NO);
        testStruct.heatedRearWindowAvailable = @(YES);
        testStruct.heatedMirrorsAvailable = @(NO);
        testStruct.climateEnableAvailable = @(NO);
        
        expect(testStruct.moduleName).to(equal(testModuleName));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.fanSpeedAvailable).to(equal(@YES));
        expect(testStruct.desiredTemperatureAvailable).to(equal(@NO));
        expect(testStruct.acEnableAvailable).to(equal(@NO));
        expect(testStruct.acMaxEnableAvailable).to(equal(@NO));
        expect(testStruct.circulateAirEnableAvailable).to(equal(@YES));
        expect(testStruct.autoModeEnableAvailable).to(equal(@NO));
        expect(testStruct.dualModeEnableAvailable).to(equal(@NO));
        expect(testStruct.defrostZoneAvailable).to(equal(@YES));
        expect(testStruct.defrostZone).to(equal([@[SDLDefrostZoneFront] copy]));
        expect(testStruct.ventilationModeAvailable).to(equal(@NO));
        expect(testStruct.ventilationMode).to(equal([@[SDLVentilationModeUpper] copy]));
        expect(testStruct.heatedSteeringWheelAvailable).to(equal(@YES));
        expect(testStruct.heatedWindshieldAvailable).to(equal(@NO));
        expect(testStruct.heatedRearWindowAvailable).to(equal(@YES));
        expect(testStruct.heatedMirrorsAvailable).to(equal(@NO));
        expect(testStruct.climateEnableAvailable).to(equal(@NO));

    });
    
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameModuleName:testModuleName,
                               SDLRPCParameterNameModuleInfo:testModuleInfo,
                               SDLRPCParameterNameFanSpeedAvailable:@YES,
                               SDLRPCParameterNameDesiredTemperatureAvailable:@NO,
                               SDLRPCParameterNameACEnableAvailable:@NO,
                               SDLRPCParameterNameACMaxEnableAvailable:@NO,
                               SDLRPCParameterNameCirculateAirEnableAvailable:@YES,
                               SDLRPCParameterNameAutoModeEnableAvailable:@NO,
                               SDLRPCParameterNameDualModeEnableAvailable:@NO,
                               SDLRPCParameterNameDefrostZoneAvailable:@YES,
                               SDLRPCParameterNameDefrostZone:[@[SDLDefrostZoneFront] copy],
                               SDLRPCParameterNameVentilationModeAvailable:@NO,
                               SDLRPCParameterNameVentilationMode:[@[SDLVentilationModeUpper] copy],
                               SDLRPCParameterNameHeatedSteeringWheelAvailable:@YES,
                               SDLRPCParameterNameHeatedWindshieldAvailable:@NO,
                               SDLRPCParameterNameHeatedRearWindowAvailable:@YES,
                               SDLRPCParameterNameHeatedMirrorsAvailable:@NO,
                               SDLRPCParameterNameClimateEnableAvailable:@NO,
        };
        SDLClimateControlCapabilities *testStruct = [[SDLClimateControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(testModuleName));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.fanSpeedAvailable).to(equal(@YES));
        expect(testStruct.desiredTemperatureAvailable).to(equal(@NO));
        expect(testStruct.acEnableAvailable).to(equal(@NO));
        expect(testStruct.acMaxEnableAvailable).to(equal(@NO));
        expect(testStruct.circulateAirEnableAvailable).to(equal(@YES));
        expect(testStruct.autoModeEnableAvailable).to(equal(@NO));
        expect(testStruct.dualModeEnableAvailable).to(equal(@NO));
        expect(testStruct.defrostZoneAvailable).to(equal(@YES));
        expect(testStruct.defrostZone).to(equal([@[SDLDefrostZoneFront] copy]));
        expect(testStruct.ventilationModeAvailable).to(equal(@NO));
        expect(testStruct.ventilationMode).to(equal([@[SDLVentilationModeUpper] copy]));
        expect(testStruct.heatedSteeringWheelAvailable).to(equal(@YES));
        expect(testStruct.heatedWindshieldAvailable).to(equal(@NO));
        expect(testStruct.heatedRearWindowAvailable).to(equal(@YES));
        expect(testStruct.heatedMirrorsAvailable).to(equal(@NO));
        expect(testStruct.climateEnableAvailable).to(equal(@NO));
    });

    it(@"Should get correctly when initialized with initWithModuleName:moduleInfo:fanSpeedAvailable:desiredTemperatureAvailable:acEnableAvailable:acMaxEnableAvailable:circulateAirAvailable:autoModeEnableAvailable:dualModeEnableAvailable:defrostZoneAvailable:ventilationModeAvailable:heatedSteeringWheelAvailable:heatedWindshieldAvailable:heatedRearWindowAvailable:heatedMirrorsAvailable:climateEnableAvailable:", ^ {
        SDLClimateControlCapabilities *testStruct = [[SDLClimateControlCapabilities alloc] initWithModuleName:testModuleName moduleInfo:testModuleInfo fanSpeedAvailable:YES desiredTemperatureAvailable:YES acEnableAvailable:YES acMaxEnableAvailable:YES circulateAirAvailable:YES autoModeEnableAvailable:YES dualModeEnableAvailable:YES defrostZoneAvailable:YES ventilationModeAvailable:YES heatedSteeringWheelAvailable:YES heatedWindshieldAvailable:YES heatedRearWindowAvailable:YES heatedMirrorsAvailable:YES climateEnableAvailable:YES];

        expect(testStruct.moduleName).to(equal(testModuleName));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.fanSpeedAvailable).to(equal(@YES));
        expect(testStruct.desiredTemperatureAvailable).to(equal(@YES));
        expect(testStruct.acEnableAvailable).to(equal(@YES));
        expect(testStruct.acMaxEnableAvailable).to(equal(@YES));
        expect(testStruct.circulateAirEnableAvailable).to(equal(@YES));
        expect(testStruct.autoModeEnableAvailable).to(equal(@YES));
        expect(testStruct.dualModeEnableAvailable).to(equal(@YES));
        expect(testStruct.defrostZoneAvailable).to(equal(@YES));
        expect(testStruct.ventilationModeAvailable).to(equal(@YES));
        expect(testStruct.heatedSteeringWheelAvailable).to(equal(@YES));
        expect(testStruct.heatedWindshieldAvailable).to(equal(@YES));
        expect(testStruct.heatedRearWindowAvailable).to(equal(@YES));
        expect(testStruct.heatedMirrorsAvailable).to(equal(@YES));
        expect(testStruct.climateEnableAvailable).to(equal(@YES));
        expect(testStruct.defrostZone).to(beNil());
        expect(testStruct.ventilationMode).to(beNil());
    });

    it(@"Should return nil if not set", ^ {
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] init];
        
        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.fanSpeedAvailable).to(beNil());
        expect(testStruct.desiredTemperatureAvailable).to(beNil());
        expect(testStruct.acEnableAvailable).to(beNil());
        expect(testStruct.acMaxEnableAvailable).to(beNil());
        expect(testStruct.circulateAirEnableAvailable).to(beNil());
        expect(testStruct.autoModeEnableAvailable).to(beNil());
        expect(testStruct.dualModeEnableAvailable).to(beNil());
        expect(testStruct.defrostZoneAvailable).to(beNil());
        expect(testStruct.defrostZone).to(beNil());
        expect(testStruct.ventilationModeAvailable).to(beNil());
        expect(testStruct.ventilationMode).to(beNil());
        expect(testStruct.heatedSteeringWheelAvailable).to(beNil());
        expect(testStruct.heatedWindshieldAvailable).to(beNil());
        expect(testStruct.heatedRearWindowAvailable).to(beNil());
        expect(testStruct.heatedMirrorsAvailable).to(beNil());
        expect(testStruct.climateEnableAvailable).to(beNil());
    });
});

QuickSpecEnd
