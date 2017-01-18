//  SDLSubscribeVehicleDataResponse.m
//


#import "SDLSubscribeVehicleDataResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLVehicleDataResult.h"

@implementation SDLSubscribeVehicleDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSubscribeVehicleData]) {
    }
    return self;
}

- (void)setGps:(SDLVehicleDataResult *)gps {
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (SDLVehicleDataResult *)gps {
    return [parameters sdl_objectForName:SDLNameGPS ofClass:SDLVehicleDataResult.class];
}

- (void)setSpeed:(SDLVehicleDataResult *)speed {
    [parameters sdl_setObject:speed forName:SDLNameSpeed];
}

- (SDLVehicleDataResult *)speed {
    return [parameters sdl_objectForName:SDLNameSpeed ofClass:SDLVehicleDataResult.class];
}

- (void)setRpm:(SDLVehicleDataResult *)rpm {
    [parameters sdl_setObject:rpm forName:SDLNameRPM];
}

- (SDLVehicleDataResult *)rpm {
    return [parameters sdl_objectForName:SDLNameRPM ofClass:SDLVehicleDataResult.class];
}

- (void)setFuelLevel:(SDLVehicleDataResult *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (SDLVehicleDataResult *)fuelLevel {
    return [parameters sdl_objectForName:SDLNameFuelLevel ofClass:SDLVehicleDataResult.class];
}

- (void)setFuelLevel_State:(SDLVehicleDataResult *)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (SDLVehicleDataResult *)fuelLevel_State {
    return [parameters sdl_objectForName:SDLNameFuelLevelState ofClass:SDLVehicleDataResult.class];
}

- (void)setInstantFuelConsumption:(SDLVehicleDataResult *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (SDLVehicleDataResult *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLNameInstantFuelConsumption ofClass:SDLVehicleDataResult.class];
}

- (void)setExternalTemperature:(SDLVehicleDataResult *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (SDLVehicleDataResult *)externalTemperature {
    return [parameters sdl_objectForName:SDLNameExternalTemperature ofClass:SDLVehicleDataResult.class];
}

- (void)setPrndl:(SDLVehicleDataResult *)prndl {
    [parameters sdl_setObject:prndl forName:SDLNamePRNDL];
}

- (SDLVehicleDataResult *)prndl {
    return [parameters sdl_objectForName:SDLNamePRNDL ofClass:SDLVehicleDataResult.class];
}

- (void)setTirePressure:(SDLVehicleDataResult *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (SDLVehicleDataResult *)tirePressure {
    return [parameters sdl_objectForName:SDLNameTirePressure ofClass:SDLVehicleDataResult.class];
}

- (void)setOdometer:(SDLVehicleDataResult *)odometer {
    [parameters sdl_setObject:odometer forName:SDLNameOdometer];
}

- (SDLVehicleDataResult *)odometer {
    return [parameters sdl_objectForName:SDLNameOdometer ofClass:SDLVehicleDataResult.class];
}

- (void)setBeltStatus:(SDLVehicleDataResult *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLNameBeltStatus];
}

- (SDLVehicleDataResult *)beltStatus {
    return [parameters sdl_objectForName:SDLNameBeltStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setBodyInformation:(SDLVehicleDataResult *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (SDLVehicleDataResult *)bodyInformation {
    return [parameters sdl_objectForName:SDLNameBodyInformation ofClass:SDLVehicleDataResult.class];
}

- (void)setDeviceStatus:(SDLVehicleDataResult *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (SDLVehicleDataResult *)deviceStatus {
    return [parameters sdl_objectForName:SDLNameDeviceStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setDriverBraking:(SDLVehicleDataResult *)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (SDLVehicleDataResult *)driverBraking {
    return [parameters sdl_objectForName:SDLNameDriverBraking ofClass:SDLVehicleDataResult.class];
}

- (void)setWiperStatus:(SDLVehicleDataResult *)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (SDLVehicleDataResult *)wiperStatus {
    return [parameters sdl_objectForName:SDLNameWiperStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setHeadLampStatus:(SDLVehicleDataResult *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (SDLVehicleDataResult *)headLampStatus {
    return [parameters sdl_objectForName:SDLNameHeadLampStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setEngineTorque:(SDLVehicleDataResult *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLNameEngineTorque];
}

- (SDLVehicleDataResult *)engineTorque {
    return [parameters sdl_objectForName:SDLNameEngineTorque ofClass:SDLVehicleDataResult.class];
}

- (void)setAccPedalPosition:(SDLVehicleDataResult *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (SDLVehicleDataResult *)accPedalPosition {
    return [parameters sdl_objectForName:SDLNameAccelerationPedalPosition ofClass:SDLVehicleDataResult.class];
}

- (void)setSteeringWheelAngle:(SDLVehicleDataResult *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (SDLVehicleDataResult *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLNameSteeringWheelAngle ofClass:SDLVehicleDataResult.class];
}

- (void)setECallInfo:(SDLVehicleDataResult *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLNameECallInfo];
}

- (SDLVehicleDataResult *)eCallInfo {
    return [parameters sdl_objectForName:SDLNameECallInfo ofClass:SDLVehicleDataResult.class];
}

- (void)setAirbagStatus:(SDLVehicleDataResult *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (SDLVehicleDataResult *)airbagStatus {
    return [parameters sdl_objectForName:SDLNameAirbagStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setEmergencyEvent:(SDLVehicleDataResult *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (SDLVehicleDataResult *)emergencyEvent {
    return [parameters sdl_objectForName:SDLNameEmergencyEvent ofClass:SDLVehicleDataResult.class];
}

- (void)setClusterModes:(SDLVehicleDataResult *)clusterModes {
    [parameters sdl_setObject:clusterModes forName:SDLNameClusterModes];
}

- (SDLVehicleDataResult *)clusterModes {
    return [parameters sdl_objectForName:SDLNameClusterModes ofClass:SDLVehicleDataResult.class];
}

- (void)setMyKey:(SDLVehicleDataResult *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (SDLVehicleDataResult *)myKey {
    return [parameters sdl_objectForName:SDLNameMyKey ofClass:SDLVehicleDataResult.class];
}

@end
