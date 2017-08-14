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
#import "SDLNames.h"


QuickSpecBegin(SDLClimateControlCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] init];
        testStruct.moduleName = @"Name";
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
        
        expect(testStruct.moduleName).to(equal(@"Name"));
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
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameModuleName:@"Name",
                                                           SDLNameFanSpeedAvailable:@YES,
                                                           SDLNameDesiredTemperatureAvailable:@NO,
                                                           SDLNameAcEnableAvailable:@NO,
                                                           SDLNameAcMaxEnableAvailable:@NO,
                                                           SDLNameCirculateAirEnableAvailable:@YES,
                                                           SDLNameAutoModeEnableAvailable:@NO,
                                                           SDLNameDualModeEnableAvailable:@NO,
                                                           SDLNameDefrostZoneAvailable:@YES,
                                                           SDLNameDefrostZone:[@[SDLDefrostZoneFront] copy],
                                                           SDLNameVentilationModeAvailable:@NO,
                                                       SDLNameVentilationMode:[@[SDLVentilationModeUpper] copy]} mutableCopy];
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.moduleName).to(equal(@"Name"));
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
    });
    
    it(@"Should return nil if not set", ^ {
        SDLClimateControlCapabilities* testStruct = [[SDLClimateControlCapabilities alloc] init];
        
        expect(testStruct.moduleName).to(beNil());
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

    });
});

QuickSpecEnd
