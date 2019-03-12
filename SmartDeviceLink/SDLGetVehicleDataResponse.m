//  SDLGetVehicleDataResponse.m
//


#import "SDLGetVehicleDataResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAirbagStatus.h"
#import "SDLBeltStatus.h"
#import "SDLBodyInformation.h"
#import "SDLClusterModeStatus.h"
#import "SDLDeviceStatus.h"
#import "SDLECallInfo.h"
#import "SDLEmergencyEvent.h"
#import "SDLFuelRange.h"
#import "SDLGPSData.h"
#import "SDLHeadLampStatus.h"
#import "SDLMyKey.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetVehicleDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetVehicleData]) {
    }
    return self;
}

- (void)setGps:(nullable SDLGPSData *)gps {
    [parameters sdl_setObject:gps forName:SDLRPCParameterNameGPS];
}

- (nullable SDLGPSData *)gps {
    return [parameters sdl_objectForName:SDLRPCParameterNameGPS ofClass:SDLGPSData.class];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [parameters sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [parameters sdl_objectForName:SDLRPCParameterNameSpeed];
}

- (void)setRpm:(nullable NSNumber<SDLInt> *)rpm {
    [parameters sdl_setObject:rpm forName:SDLRPCParameterNameRPM];
}

- (nullable NSNumber<SDLInt> *)rpm {
    return [parameters sdl_objectForName:SDLRPCParameterNameRPM];
}

- (void)setFuelLevel:(nullable NSNumber<SDLFloat> *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLRPCParameterNameFuelLevel];
}

- (nullable NSNumber<SDLFloat> *)fuelLevel {
    return [parameters sdl_objectForName:SDLRPCParameterNameFuelLevel];
}

- (void)setFuelLevel_State:(nullable SDLComponentVolumeStatus)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLRPCParameterNameFuelLevelState];
}

- (nullable SDLComponentVolumeStatus)fuelLevel_State {
    return [parameters sdl_objectForName:SDLRPCParameterNameFuelLevelState];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLRPCParameterNameInstantFuelConsumption];
}

- (void)setFuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange {
    [parameters sdl_setObject:fuelRange forName:SDLRPCParameterNameFuelRange];
}

- (nullable NSArray<SDLFuelRange *> *)fuelRange {
    return [parameters sdl_objectsForName:SDLRPCParameterNameFuelRange ofClass:SDLFuelRange.class];
}

- (nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLRPCParameterNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLFloat> *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
}

- (nullable NSNumber<SDLFloat> *)externalTemperature {
    return [parameters sdl_objectForName:SDLRPCParameterNameExternalTemperature];
}

- (void)setVin:(nullable NSString *)vin {
    [parameters sdl_setObject:vin forName:SDLRPCParameterNameVIN];
}

- (nullable NSString *)vin {
    return [parameters sdl_objectForName:SDLRPCParameterNameVIN];
}

- (void)setPrndl:(nullable SDLPRNDL)prndl {
    [parameters sdl_setObject:prndl forName:SDLRPCParameterNamePRNDL];
}

- (nullable SDLPRNDL)prndl {
    return [parameters sdl_objectForName:SDLRPCParameterNamePRNDL];
}

- (void)setTirePressure:(nullable SDLTireStatus *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLRPCParameterNameTirePressure];
}

- (nullable SDLTireStatus *)tirePressure {
    return [parameters sdl_objectForName:SDLRPCParameterNameTirePressure ofClass:SDLTireStatus.class];
}

- (void)setOdometer:(nullable NSNumber<SDLInt> *)odometer {
    [parameters sdl_setObject:odometer forName:SDLRPCParameterNameOdometer];
}

- (nullable NSNumber<SDLInt> *)odometer {
    return [parameters sdl_objectForName:SDLRPCParameterNameOdometer];
}

- (void)setBeltStatus:(nullable SDLBeltStatus *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLRPCParameterNameBeltStatus];
}

- (nullable SDLBeltStatus *)beltStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameBeltStatus ofClass:SDLBeltStatus.class];
}

- (void)setBodyInformation:(nullable SDLBodyInformation *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLRPCParameterNameBodyInformation];
}

- (nullable SDLBodyInformation *)bodyInformation {
    return [parameters sdl_objectForName:SDLRPCParameterNameBodyInformation ofClass:SDLBodyInformation.class];
}

- (void)setDeviceStatus:(nullable SDLDeviceStatus *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLRPCParameterNameDeviceStatus];
}

- (nullable SDLDeviceStatus *)deviceStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameDeviceStatus ofClass:SDLDeviceStatus.class];
}

- (void)setDriverBraking:(nullable SDLVehicleDataEventStatus)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLRPCParameterNameDriverBraking];
}

- (nullable SDLVehicleDataEventStatus)driverBraking {
    return [parameters sdl_objectForName:SDLRPCParameterNameDriverBraking];
}

- (void)setWiperStatus:(nullable SDLWiperStatus)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLRPCParameterNameWiperStatus];
}

- (nullable SDLWiperStatus)wiperStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameWiperStatus];
}

- (void)setHeadLampStatus:(nullable SDLHeadLampStatus *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLRPCParameterNameHeadLampStatus];
}

- (nullable SDLHeadLampStatus *)headLampStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameHeadLampStatus ofClass:SDLHeadLampStatus.class];
}

- (void)setEngineOilLife:(nullable NSNumber<SDLFloat> *)engineOilLife {
    [parameters sdl_setObject:engineOilLife forName:SDLRPCParameterNameEngineOilLife];
}

- (nullable NSNumber<SDLFloat> *)engineOilLife {
    return [parameters sdl_objectForName:SDLRPCParameterNameEngineOilLife];
}

- (void)setEngineTorque:(nullable NSNumber<SDLFloat> *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLRPCParameterNameEngineTorque];
}

- (nullable NSNumber<SDLFloat> *)engineTorque {
    return [parameters sdl_objectForName:SDLRPCParameterNameEngineTorque];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLFloat> *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLRPCParameterNameAccelerationPedalPosition];
}

- (nullable NSNumber<SDLFloat> *)accPedalPosition {
    return [parameters sdl_objectForName:SDLRPCParameterNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLRPCParameterNameSteeringWheelAngle];
}

- (nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLRPCParameterNameSteeringWheelAngle];
}

- (void)setECallInfo:(nullable SDLECallInfo *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLRPCParameterNameECallInfo];
}

- (nullable SDLECallInfo *)eCallInfo {
    return [parameters sdl_objectForName:SDLRPCParameterNameECallInfo ofClass:SDLECallInfo.class];
}

- (void)setAirbagStatus:(nullable SDLAirbagStatus *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLRPCParameterNameAirbagStatus];
}

- (nullable SDLAirbagStatus *)airbagStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameAirbagStatus ofClass:SDLAirbagStatus.class];
}

- (void)setEmergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLRPCParameterNameEmergencyEvent];
}

- (nullable SDLEmergencyEvent *)emergencyEvent {
    return [parameters sdl_objectForName:SDLRPCParameterNameEmergencyEvent ofClass:SDLEmergencyEvent.class];
}

- (void)setClusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus {
    [parameters sdl_setObject:clusterModeStatus forName:SDLRPCParameterNameClusterModeStatus];
}

- (nullable SDLClusterModeStatus *)clusterModeStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameClusterModeStatus ofClass:SDLClusterModeStatus.class];
}

- (void)setMyKey:(nullable SDLMyKey *)myKey {
    [parameters sdl_setObject:myKey forName:SDLRPCParameterNameMyKey];
}

- (nullable SDLMyKey *)myKey {
    return [parameters sdl_objectForName:SDLRPCParameterNameMyKey ofClass:SDLMyKey.class];
}

- (void)setElectronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    [parameters sdl_setObject:electronicParkBrakeStatus forName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (void)setTurnSignal:(nullable SDLTurnSignal)turnSignal {
    [parameters sdl_setObject:turnSignal forName:SDLRPCParameterNameTurnSignal];
}

- (nullable SDLTurnSignal)turnSignal {
    return [parameters sdl_objectForName:SDLRPCParameterNameTurnSignal];
}

- (void)setCloudAppVehicleID:(nullable NSString *)cloudAppVehicleID {
    [parameters sdl_setObject:cloudAppVehicleID forName:SDLRPCParameterNameCloudAppVehicleID];
}

- (nullable NSString *)cloudAppVehicleID {
    return [parameters sdl_objectForName:SDLRPCParameterNameCloudAppVehicleID];
}

@end

NS_ASSUME_NONNULL_END
