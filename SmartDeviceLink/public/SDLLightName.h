//  SDLLightName.h
//

#import "SDLEnum.h"

/**
 * The name that identifies the Light
 *
 */
typedef SDLEnum SDLLightName NS_TYPED_ENUM;

/**
 * @abstract Represents the Light with name FRONT_LEFT_HIGH_BEAM.
 */
extern SDLLightName const SDLLightNameFrontLeftHighBeam;

/**
 * @abstract Represents the Light with name FRONT_RIGHT_HIGH_BEAM.
 */
extern SDLLightName const SDLLightNameFrontRightHighBeam;

/**
 * @abstract Represents the Light with name FRONT_LEFT_LOW_BEAM.
 */
extern SDLLightName const SDLLightNameFrontLeftLowBeam;

/**
 * @abstract Represents the Light with name FRONT_RIGHT_LOW_BEAM.
 */
extern SDLLightName const SDLLightNameFrontRightLowBeam;

/**
 * @abstract Represents the Light with name FRONT_LEFT_PARKING_LIGHT
 */
extern SDLLightName const SDLLightNameFrontLeftParkingLight;

/**
 * @abstract Represents the Light with name FRONT_RIGHT_PARKING_LIGHT
 */
extern SDLLightName const SDLLightNameFrontRightParkingLight;

/**
 * @abstract Represents the Light with name FRONT_LEFT_FOG_LIGHT
 */
extern SDLLightName const SDLLightNameFrontLeftFogLight;

/**
 * @abstract Represents the Light with name FRONT_RIGHT_FOG_LIGHT
 */
extern SDLLightName const SDLLightNameFrontRightFogLight;

/**
 * @abstract Represents the Light with name FRONT_LEFT_DAYTIME_RUNNING_LIGHT
 */
extern SDLLightName const SDLLightNameFrontLeftDaytimeRunningLight;

/**
 * @abstract Represents the Light with name FRONT_RIGHT_DAYTIME_RUNNING_LIGHT
 */
extern SDLLightName const SDLLightNameFrontRightDaytimeRunningLight;

/**
 * @abstract Represents the Light with name FRONT_LEFT_TURN_LIGHT
 */
extern SDLLightName const SDLLightNameFrontLeftTurnLight;

/**
 * @abstract Represents the Light with name FRONT_Right_TURN_LIGHT
 */
extern SDLLightName const SDLLightNameFrontRightTurnLight;

/**
 * @abstract Represents the Light with name REAR_LEFT_FOG_LIGHT.
 */
extern SDLLightName const SDLLightNameRearLeftFogLight;

/**
 * @abstract Represents the Light with name REAR_RIGHT_FOG_LIGHT
 */
extern SDLLightName const SDLLightNameRearRightFogLight;

/**
 * @abstract Represents the Light with name REAR_LEFT_TAIL_LIGHT
 */
extern SDLLightName const SDLLightNameRearLeftTailLight;

/**
 * @abstract Represents the Light with name REAR_RIGHT_TAIL_LIGHT
 */
extern SDLLightName const SDLLightNameRearRightTailLight;

/**
 * @abstract Represents the Light with name REAR_LEFT_BRAKE_LIGHT
 */
extern SDLLightName const SDLLightNameRearLeftBrakeLight;

/**
 * @abstract Represents the Light with name REAR_RIGHT_BRAKE_LIGHT
 */
extern SDLLightName const SDLLightNameRearRightBrakeLight;

/**
 * @abstract Represents the Light with name REAR_LEFT_TURN_LIGHT
 */
extern SDLLightName const SDLLightNameRearLeftTurnLight;

/**
 * @abstract Represents the Light with name REAR_RIGHT_TURN_LIGHT
 */
extern SDLLightName const SDLLightNameRearRightTurnLight;

/**
 * @abstract Represents the Light with name REAR_REGISTRATION_PLATE_LIGHT
 */
extern SDLLightName const SDLLightNameRearRegistrationPlateLight;

#pragma mark - Exterior Lights by common function groups
/**
 * @abstract Include all high beam lights: front_left and front_right.
 */
extern SDLLightName const SDLLightNameHighBeams;

/**
 * @abstract Include all low beam lights: front_left and front_right.
 */
extern SDLLightName const SDLLightNameLowBeams;

/**
 * @abstract Include all fog lights: front_left, front_right, rear_left and rear_right.
 */
extern SDLLightName const SDLLightNameFogLights;

/**
 * @abstract Include all daytime running lights: front_left and front_right.
 */
extern SDLLightName const SDLLightNameRunningLights;

/**
 * @abstract Include all parking lights: front_left and front_right.
 */
extern SDLLightName const SDLLightNameParkingLights;

/**
 * @abstract Include all brake lights: rear_left and rear_right.
 */
extern SDLLightName const SDLLightNameBrakeLights;

/**
 * @abstract Represents the Light with name REAR_REVERSING_LIGHTS
 */
extern SDLLightName const SDLLightNameRearReversingLights;

/**
 * @abstract Represents the Light with name SIDE_MARKER_LIGHTS
 */
extern SDLLightName const SDLLightNameSideMarkerLights;

/**
 * @abstract Include all left turn signal lights: front_left, rear_left, left_side and mirror_mounted.
 */
extern SDLLightName const SDLLightNameLeftTurnLights;

/**
 * @abstract Include all right turn signal lights: front_right, rear_right, right_side and mirror_mounted.
 */
extern SDLLightName const SDLLightNameRightTurnLights;

/**
 * @abstract Include all hazard lights: front_left, front_right, rear_left and rear_right.
 */
extern SDLLightName const SDLLightNameHazardLights;

#pragma mark - Interior Lights by common function groups

/**
 * @abstract Represents the Light with name AMBIENT_LIGHTS
 */
extern SDLLightName const SDLLightNameAmbientLights;

/**
 * @abstract Represents the Light with name OVERHEAD_LIGHTS
 */
extern SDLLightName const SDLLightNameOverHeadLights;

/**
 * @abstract Represents the Light with name READING_LIGHTS
 */
extern SDLLightName const SDLLightNameReadingLights;

/**
 * @abstract Represents the Light with name TRUNK_LIGHTS
 */
extern SDLLightName const SDLLightNameTrunkLights;

#pragma mark - Lights by location

/**
 * @abstract Include exterior lights located in front of the vehicle. For example, fog lights and low beams.
 */
extern SDLLightName const SDLLightNameExteriorFrontLights;

/**
 * @abstract Include exterior lights located at the back of the vehicle.
 * For example, license plate lights, reverse lights, cargo lights, bed lights an trailer assist lights.
 */
extern SDLLightName const SDLLightNameExteriorRearLights;

/**
 * @abstract Include exterior lights located at the left side of the vehicle.
 * For example, left puddle lights and spot lights.
 */
extern SDLLightName const SDLLightNameExteriorLeftLights;

/**
 * @abstract Include exterior lights located at the right side of the vehicle.
 * For example, right puddle lights and spot lights.
 */
extern SDLLightName const SDLLightNameExteriorRightLights;

/**
 * @abstract Cargo lamps illuminate the cargo area.
 */
extern SDLLightName const SDLLightNameExteriorRearCargoLights;

/**
 * @abstract Truck bed lamps light up the bed of the truck.
 */
extern SDLLightName const SDLLightNameExteriorRearTruckBedLights;

/**
 * @abstract Trailer lights are lamps mounted on a trailer hitch.
 */
extern SDLLightName const SDLLightNameExteriorRearTrailerLights;

/**
 * @abstract It is the spotlights mounted on the left side of a vehicle.
 *
 */
extern SDLLightName const SDLLightNameExteriorLeftSpotLights;

/**
 * @abstract It is the spotlights mounted on the right side of a vehicle.
 */
extern SDLLightName const SDLLightNameExteriorRightSpotLights;

/**
 * @abstract Puddle lamps illuminate the ground beside the door as the customer is opening or approaching the door.
 */
extern SDLLightName const SDLLightNameExteriorLeftPuddleLights;

/**
 * @abstract Puddle lamps illuminate the ground beside the door as the customer is opening or approaching the door.
 */
extern SDLLightName const SDLLightNameExteriorRightPuddleLights;

/**
 * @abstract Include all exterior lights around the vehicle.
 */
extern SDLLightName const SDLLightNameExteriorAllLights;
