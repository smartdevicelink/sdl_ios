//
//  SDLClimateControlCapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLClimateControlCapabilities.h"
#import "SDLDefrostZone.h"
#import "SDLVentilationMode.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLClimateControlCapabilitiesSpec)

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

        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] init];
        testStruct.moduleName = @"Name";
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
        
        expect(testStruct.moduleName).to(equal(@"Name"));
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
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameModuleName:@"Name",
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
                                                       } mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.moduleName).to(equal(@"Name"));
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

    it(@"Should get correctly when initialized with module data and other climate control capabilities parameters", ^ {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] initWithModuleName:@"Name" fanSpeedAvailable:YES desiredTemperatureAvailable:NO acEnableAvailable:NO acMaxEnableAvailable:YES circulateAirAvailable:NO autoModeEnableAvailable:NO dualModeEnableAvailable:NO defrostZoneAvailable:YES ventilationModeAvailable:YES];

        expect(testStruct.moduleName).to(equal(@"Name"));
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.fanSpeedAvailable).to(equal(@YES));
        expect(testStruct.desiredTemperatureAvailable).to(equal(@NO));
        expect(testStruct.acEnableAvailable).to(equal(@NO));
        expect(testStruct.acMaxEnableAvailable).to(equal(@YES));
        expect(testStruct.circulateAirEnableAvailable).to(equal(@NO));
        expect(testStruct.autoModeEnableAvailable).to(equal(@NO));
        expect(testStruct.dualModeEnableAvailable).to(equal(@NO));
        expect(testStruct.defrostZoneAvailable).to(equal(@YES));
        expect(testStruct.ventilationModeAvailable).to(equal(@YES));
        expect(testStruct.heatedSteeringWheelAvailable).to(equal(@NO));
        expect(testStruct.heatedWindshieldAvailable).to(equal(@NO));
        expect(testStruct.heatedRearWindowAvailable).to(equal(@NO));
        expect(testStruct.heatedMirrorsAvailable).to(equal(@NO));
        expect(testStruct.climateEnableAvailable).to(equal(@NO));
        #pragma clang diagnostic pop
    });

    it(@"Should get correctly when initialized with module data and other climate control capabilities parameters", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] initWithModuleName:@"Name" fanSpeedAvailable:YES desiredTemperatureAvailable:NO acEnableAvailable:NO acMaxEnableAvailable:YES circulateAirAvailable:NO autoModeEnableAvailable:NO dualModeEnableAvailable:NO defrostZoneAvailable:YES ventilationModeAvailable:YES heatedSteeringWheelAvailable:YES heatedWindshieldAvailable:NO heatedRearWindowAvailable:YES heatedMirrorsAvailable:NO];
#pragma clang diagnostic pop

        expect(testStruct.moduleName).to(equal(@"Name"));
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.fanSpeedAvailable).to(equal(@YES));
        expect(testStruct.desiredTemperatureAvailable).to(equal(@NO));
        expect(testStruct.acEnableAvailable).to(equal(@NO));
        expect(testStruct.acMaxEnableAvailable).to(equal(@YES));
        expect(testStruct.circulateAirEnableAvailable).to(equal(@NO));
        expect(testStruct.autoModeEnableAvailable).to(equal(@NO));
        expect(testStruct.dualModeEnableAvailable).to(equal(@NO));
        expect(testStruct.defrostZoneAvailable).to(equal(@YES));
        expect(testStruct.ventilationModeAvailable).to(equal(@YES));
        expect(testStruct.heatedSteeringWheelAvailable).to(equal(@YES));
        expect(testStruct.heatedWindshieldAvailable).to(equal(@NO));
        expect(testStruct.heatedRearWindowAvailable).to(equal(@YES));
        expect(testStruct.heatedMirrorsAvailable).to(equal(@NO));
#pragma clang diagnostic pop
    });
    
    it(@"Should get correctly when initialized with module data and other climate control capabilities parameters", ^ {
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] initWithModuleName:@"Name" fanSpeedAvailable:YES desiredTemperatureAvailable:NO acEnableAvailable:NO acMaxEnableAvailable:YES circulateAirAvailable:NO autoModeEnableAvailable:NO dualModeEnableAvailable:NO defrostZoneAvailable:YES ventilationModeAvailable:YES heatedSteeringWheelAvailable:YES heatedWindshieldAvailable:NO heatedRearWindowAvailable:YES heatedMirrorsAvailable:NO climateEnableAvailable:NO];

        expect(testStruct.moduleName).to(equal(@"Name"));
        expect(testStruct.fanSpeedAvailable).to(equal(@YES));
        expect(testStruct.desiredTemperatureAvailable).to(equal(@NO));
        expect(testStruct.acEnableAvailable).to(equal(@NO));
        expect(testStruct.acMaxEnableAvailable).to(equal(@YES));
        expect(testStruct.circulateAirEnableAvailable).to(equal(@NO));
        expect(testStruct.autoModeEnableAvailable).to(equal(@NO));
        expect(testStruct.dualModeEnableAvailable).to(equal(@NO));
        expect(testStruct.defrostZoneAvailable).to(equal(@YES));
        expect(testStruct.ventilationModeAvailable).to(equal(@YES));
        expect(testStruct.heatedSteeringWheelAvailable).to(equal(@YES));
        expect(testStruct.heatedWindshieldAvailable).to(equal(@NO));
        expect(testStruct.heatedRearWindowAvailable).to(equal(@YES));
        expect(testStruct.heatedMirrorsAvailable).to(equal(@NO));
        expect(testStruct.climateEnableAvailable).to(equal(@NO));
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
