//
//  SDLLightNameSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLightName.h"

QuickSpecBegin(SDLLightNameSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLLightNameFrontLeftHighBeam).to(equal(@"FRONT_LEFT_HIGH_BEAM"));
        expect(SDLLightNameFrontRightHighBeam).to(equal(@"FRONT_RIGHT_HIGH_BEAM"));
        expect(SDLLightNameFrontLeftLowBeam).to(equal(@"FRONT_LEFT_LOW_BEAM"));
        expect(SDLLightNameFrontRightLowBeam).to(equal(@"FRONT_RIGHT_LOW_BEAM"));
        expect(SDLLightNameFrontLeftParkingLight).to(equal(@"FRONT_LEFT_PARKING_LIGHT"));
        expect(SDLLightNameFrontRightParkingLight).to(equal(@"FRONT_RIGHT_PARKING_LIGHT"));
        expect(SDLLightNameFrontLeftDaytimeRunningLight).to(equal(@"FRONT_LEFT_DAYTIME_RUNNING_LIGHT"));
        expect(SDLLightNameFrontRightDaytimeRunningLight).to(equal(@"FRONT_RIGHT_DAYTIME_RUNNING_LIGHT"));
        expect(SDLLightNameFrontLeftTurnLight).to(equal(@"FRONT_LEFT_TURN_LIGHT"));
        expect(SDLLightNameFrontRightTurnLight).to(equal(@"FRONT_RIGHT_TURN_LIGHT"));
        expect(SDLLightNameRearLeftFogLight).to(equal(@"REAR_LEFT_FOG_LIGHT"));
        expect(SDLLightNameRearRightFogLight).to(equal(@"REAR_RIGHT_FOG_LIGHT"));
        expect(SDLLightNameRearLeftTailLight).to(equal(@"REAR_LEFT_TAIL_LIGHT"));
        expect(SDLLightNameRearRightTailLight).to(equal(@"REAR_RIGHT_TAIL_LIGHT"));
        expect(SDLLightNameRearLeftBreakLight).to(equal(@"REAR_LEFT_BREAK_LIGHT"));
        expect(SDLLightNameRearRightBreakLight).to(equal(@"REAR_RIGHT_BREAK_LIGHT"));
        expect(SDLLightNameRearLeftTurnLight).to(equal(@"REAR_LEFT_TURN_LIGHT"));
        expect(SDLLightNameRearRightTurnLight).to(equal(@"REAR_RIGHT_TURN_LIGHT"));
        expect(SDLLightNameRearRegistrationPlateLight).to(equal(@"REAR_REGISTRATION_PLATE_LIGHT"));
        expect(SDLLightNameHighBeams).to(equal(@"HIGH_BEAMS"));
        expect(SDLLightNameLowBeams).to(equal(@"LOW_BEAMS"));
        expect(SDLLightNameFogLights).to(equal(@"FOG_LIGHTS"));
        expect(SDLLightNameRunningLights).to(equal(@"RUNNING_LIGHTS"));
        expect(SDLLightNameParkingLights).to(equal(@"PARKING_LIGHTS"));
        expect(SDLLightNameBrakeLights).to(equal(@"BRAKE_LIGHTS"));
        expect(SDLLightNameRearReversingLights).to(equal(@"REAR_REVERSING_LIGHTS"));
        expect(SDLLightNameSideMarkerLights).to(equal(@"SIDE_MARKER_LIGHTS"));
        expect(SDLLightNameLeftTurnLights).to(equal(@"LEFT_TURN_LIGHTS"));
        expect(SDLLightNameRightTurnLights).to(equal(@"RIGHT_TURN_LIGHTS"));
        expect(SDLLightNameHazardLights).to(equal(@"HAZARD_LIGHTS"));
        expect(SDLLightNameAmbientLights).to(equal(@"AMBIENT_LIGHTS"));
        expect(SDLLightNameOverHeadLights).to(equal(@"OVERHEAD_LIGHTS"));
        expect(SDLLightNameReadingLights).to(equal(@"READING_LIGHTS"));
        expect(SDLLightNameTrunkLights).to(equal(@"TRUNK_LIGHTS"));
        expect(SDLLightNameExteriorFrontLights).to(equal(@"EXTERIOR_FRONT_LIGHTS"));
        expect(SDLLightNameExteriorRearLights).to(equal(@"EXTERIOR_REAR_LIGHTS"));
        expect(SDLLightNameExteriorLeftLights).to(equal(@"EXTERIOR_LEFT_LIGHTS"));
        expect(SDLLightNameExteriorRightLights).to(equal(@"EXTERIOR_RIGHT_LIGHTS"));

    });
});

QuickSpecEnd

