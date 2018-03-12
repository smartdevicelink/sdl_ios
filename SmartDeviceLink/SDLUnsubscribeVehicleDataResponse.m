//  SDLUnsubscribeVehicleDataResponse.m
//


#import "SDLUnsubscribeVehicleDataResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLVehicleDataResult.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeVehicleDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameUnsubscribeVehicleData]) {
    }
    return self;
}

- (void)setGps:(nullable SDLVehicleDataResult *)gps {
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (nullable SDLVehicleDataResult *)gps {
    return [parameters sdl_objectForName:SDLNameGPS ofClass:SDLVehicleDataResult.class];
}

- (void)setSpeed:(nullable SDLVehicleDataResult *)speed {
    [parameters sdl_setObject:speed forName:SDLNameSpeed];
}

- (nullable SDLVehicleDataResult *)speed {
    return [parameters sdl_objectForName:SDLNameSpeed ofClass:SDLVehicleDataResult.class];
}

- (void)setRpm:(nullable SDLVehicleDataResult *)rpm {
    [parameters sdl_setObject:rpm forName:SDLNameRPM];
}

- (nullable SDLVehicleDataResult *)rpm {
    return [parameters sdl_objectForName:SDLNameRPM ofClass:SDLVehicleDataResult.class];
}

- (void)setFuelLevel:(nullable SDLVehicleDataResult *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (nullable SDLVehicleDataResult *)fuelLevel {
    return [parameters sdl_objectForName:SDLNameFuelLevel ofClass:SDLVehicleDataResult.class];
}

- (void)setFuelLevel_State:(nullable SDLVehicleDataResult *)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (nullable SDLVehicleDataResult *)fuelLevel_State {
    return [parameters sdl_objectForName:SDLNameFuelLevelState ofClass:SDLVehicleDataResult.class];
}

- (void)setInstantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (nullable SDLVehicleDataResult *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLNameInstantFuelConsumption ofClass:SDLVehicleDataResult.class];
}

- (void)setExternalTemperature:(nullable SDLVehicleDataResult *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (nullable SDLVehicleDataResult *)externalTemperature {
    return [parameters sdl_objectForName:SDLNameExternalTemperature ofClass:SDLVehicleDataResult.class];
}

- (void)setPrndl:(nullable SDLVehicleDataResult *)prndl {
    [parameters sdl_setObject:prndl forName:SDLNamePRNDL];
}

- (nullable SDLVehicleDataResult *)prndl {
    return [parameters sdl_objectForName:SDLNamePRNDL ofClass:SDLVehicleDataResult.class];
}

- (void)setTirePressure:(nullable SDLVehicleDataResult *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (nullable SDLVehicleDataResult *)tirePressure {
    return [parameters sdl_objectForName:SDLNameTirePressure ofClass:SDLVehicleDataResult.class];
}

- (void)setOdometer:(nullable SDLVehicleDataResult *)odometer {
    [parameters sdl_setObject:odometer forName:SDLNameOdometer];
}

- (nullable SDLVehicleDataResult *)odometer {
    return [parameters sdl_objectForName:SDLNameOdometer ofClass:SDLVehicleDataResult.class];
}

- (void)setBeltStatus:(nullable SDLVehicleDataResult *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLNameBeltStatus];
}

- (nullable SDLVehicleDataResult *)beltStatus {
    return [parameters sdl_objectForName:SDLNameBeltStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setBodyInformation:(nullable SDLVehicleDataResult *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (nullable SDLVehicleDataResult *)bodyInformation {
    return [parameters sdl_objectForName:SDLNameBodyInformation ofClass:SDLVehicleDataResult.class];
}

- (void)setDeviceStatus:(nullable SDLVehicleDataResult *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (nullable SDLVehicleDataResult *)deviceStatus {
    return [parameters sdl_objectForName:SDLNameDeviceStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setDriverBraking:(nullable SDLVehicleDataResult *)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (nullable SDLVehicleDataResult *)driverBraking {
    return [parameters sdl_objectForName:SDLNameDriverBraking ofClass:SDLVehicleDataResult.class];
}

- (void)setWiperStatus:(nullable SDLVehicleDataResult *)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (nullable SDLVehicleDataResult *)wiperStatus {
    return [parameters sdl_objectForName:SDLNameWiperStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setHeadLampStatus:(nullable SDLVehicleDataResult *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (nullable SDLVehicleDataResult *)headLampStatus {
    return [parameters sdl_objectForName:SDLNameHeadLampStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setEngineTorque:(nullable SDLVehicleDataResult *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLNameEngineTorque];
}

- (nullable SDLVehicleDataResult *)engineTorque {
    return [parameters sdl_objectForName:SDLNameEngineTorque ofClass:SDLVehicleDataResult.class];
}

- (void)setAccPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (nullable SDLVehicleDataResult *)accPedalPosition {
    return [parameters sdl_objectForName:SDLNameAccelerationPedalPosition ofClass:SDLVehicleDataResult.class];
}

- (void)setSteeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (nullable SDLVehicleDataResult *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLNameSteeringWheelAngle ofClass:SDLVehicleDataResult.class];
}

- (void)setECallInfo:(nullable SDLVehicleDataResult *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLNameECallInfo];
}

- (nullable SDLVehicleDataResult *)eCallInfo {
    return [parameters sdl_objectForName:SDLNameECallInfo ofClass:SDLVehicleDataResult.class];
}

- (void)setAirbagStatus:(nullable SDLVehicleDataResult *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (nullable SDLVehicleDataResult *)airbagStatus {
    return [parameters sdl_objectForName:SDLNameAirbagStatus ofClass:SDLVehicleDataResult.class];
}

- (void)setEmergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (nullable SDLVehicleDataResult *)emergencyEvent {
    return [parameters sdl_objectForName:SDLNameEmergencyEvent ofClass:SDLVehicleDataResult.class];
}

- (void)setClusterModes:(nullable SDLVehicleDataResult *)clusterModes {
    [parameters sdl_setObject:clusterModes forName:SDLNameClusterModes];
}

- (nullable SDLVehicleDataResult *)clusterModes {
    return [parameters sdl_objectForName:SDLNameClusterModes ofClass:SDLVehicleDataResult.class];
}

- (void)setMyKey:(nullable SDLVehicleDataResult *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (nullable SDLVehicleDataResult *)myKey {
    return [parameters sdl_objectForName:SDLNameMyKey ofClass:SDLVehicleDataResult.class];
}

- (void)setFuelRange:(nullable SDLVehicleDataResult *)fuelRange {
    [parameters sdl_setObject:fuelRange forName:SDLNameFuelRange];
}

- (nullable SDLVehicleDataResult *)fuelRange {
    return [parameters sdl_objectForName:SDLNameFuelRange ofClass:SDLVehicleDataResult.class];
}


@end

NS_ASSUME_NONNULL_END
