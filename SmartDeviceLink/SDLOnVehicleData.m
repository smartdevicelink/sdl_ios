//  SDLOnVehicleData.m
//

#import "SDLOnVehicleData.h"

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

@implementation SDLOnVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnVehicleData]) {
    }
    return self;
}

- (void)setGps:(nullable SDLGPSData *)gps {
    [parameters sdl_setObject:gps forName:SDLRPCParameterNameGPS];
}

- (nullable SDLGPSData *)gps {
    return [parameters sdl_objectForName:SDLRPCParameterNameGPS ofClass:SDLGPSData.class error:nil];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [parameters sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [parameters sdl_objectForName:SDLRPCParameterNameSpeed ofClass:NSNumber.class error:nil];
}

- (void)setRpm:(nullable NSNumber<SDLInt> *)rpm {
    [parameters sdl_setObject:rpm forName:SDLRPCParameterNameRPM];
}

- (nullable NSNumber<SDLInt> *)rpm {
    return [parameters sdl_objectForName:SDLRPCParameterNameRPM ofClass:NSNumber.class error:nil];
}

- (void)setFuelLevel:(nullable NSNumber<SDLFloat> *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLRPCParameterNameFuelLevel];
}

- (nullable NSNumber<SDLFloat> *)fuelLevel {
    return [parameters sdl_objectForName:SDLRPCParameterNameFuelLevel ofClass:NSNumber.class error:nil];
}

- (void)setFuelLevel_State:(nullable SDLComponentVolumeStatus)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLRPCParameterNameFuelLevelState];
}

- (nullable SDLComponentVolumeStatus)fuelLevel_State {
    return [parameters sdl_enumForName:SDLRPCParameterNameFuelLevelState error:nil];
}

- (void)setFuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange {
    [parameters sdl_setObject:fuelRange forName:SDLRPCParameterNameFuelRange];
}

- (nullable NSArray<SDLFuelRange *> *)fuelRange {
    return [parameters sdl_objectsForName:SDLRPCParameterNameFuelRange ofClass:SDLFuelRange.class error:nil];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLRPCParameterNameInstantFuelConsumption];
}

- (nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLRPCParameterNameInstantFuelConsumption ofClass:NSNumber.class error:nil];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLFloat> *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
}

- (nullable NSNumber<SDLFloat> *)externalTemperature {
    return [parameters sdl_objectForName:SDLRPCParameterNameExternalTemperature ofClass:NSNumber.class error:nil];
}

- (void)setVin:(nullable NSString *)vin {
    [parameters sdl_setObject:vin forName:SDLRPCParameterNameVIN];
}

- (nullable NSString *)vin {
    return [parameters sdl_objectForName:SDLRPCParameterNameVIN ofClass:NSString.class error:nil];
}

- (void)setPrndl:(nullable SDLPRNDL)prndl {
    [parameters sdl_setObject:prndl forName:SDLRPCParameterNamePRNDL];
}

- (nullable SDLPRNDL)prndl {
    return [parameters sdl_enumForName:SDLRPCParameterNamePRNDL error:nil];
}

- (void)setTirePressure:(nullable SDLTireStatus *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLRPCParameterNameTirePressure];
}

- (nullable SDLTireStatus *)tirePressure {
    return [parameters sdl_objectForName:SDLRPCParameterNameTirePressure ofClass:SDLTireStatus.class error:nil];
}

- (void)setOdometer:(nullable NSNumber<SDLInt> *)odometer {
    [parameters sdl_setObject:odometer forName:SDLRPCParameterNameOdometer];
}

- (nullable NSNumber<SDLInt> *)odometer {
    return [parameters sdl_objectForName:SDLRPCParameterNameOdometer ofClass:NSNumber.class error:nil];
}

- (void)setBeltStatus:(nullable SDLBeltStatus *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLRPCParameterNameBeltStatus];
}

- (nullable SDLBeltStatus *)beltStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameBeltStatus ofClass:SDLBeltStatus.class error:nil];
}

- (void)setBodyInformation:(nullable SDLBodyInformation *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLRPCParameterNameBodyInformation];
}

- (nullable SDLBodyInformation *)bodyInformation {
    return [parameters sdl_objectForName:SDLRPCParameterNameBodyInformation ofClass:SDLBodyInformation.class error:nil];
}

- (void)setDeviceStatus:(nullable SDLDeviceStatus *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLRPCParameterNameDeviceStatus];
}

- (nullable SDLDeviceStatus *)deviceStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameDeviceStatus ofClass:SDLDeviceStatus.class error:nil];
}

- (void)setDriverBraking:(nullable SDLVehicleDataEventStatus)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLRPCParameterNameDriverBraking];
}

- (nullable SDLVehicleDataEventStatus)driverBraking {
    return [parameters sdl_enumForName:SDLRPCParameterNameDriverBraking error:nil];
}

- (void)setWiperStatus:(nullable SDLWiperStatus)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLRPCParameterNameWiperStatus];
}

- (nullable SDLWiperStatus)wiperStatus {
    return [parameters sdl_enumForName:SDLRPCParameterNameWiperStatus error:nil];
}

- (void)setHeadLampStatus:(nullable SDLHeadLampStatus *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLRPCParameterNameHeadLampStatus];
}

- (nullable SDLHeadLampStatus *)headLampStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameHeadLampStatus ofClass:SDLHeadLampStatus.class error:nil];
}

- (void)setEngineOilLife:(nullable NSNumber<SDLFloat> *)engineOilLife {
    [parameters sdl_setObject:engineOilLife forName:SDLRPCParameterNameEngineOilLife];
}

- (nullable NSNumber<SDLFloat> *)engineOilLife {
    return [parameters sdl_objectForName:SDLRPCParameterNameEngineOilLife ofClass:NSNumber.class error:nil];
}

- (void)setEngineTorque:(nullable NSNumber<SDLFloat> *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLRPCParameterNameEngineTorque];
}

- (nullable NSNumber<SDLFloat> *)engineTorque {
    return [parameters sdl_objectForName:SDLRPCParameterNameEngineTorque ofClass:NSNumber.class error:nil];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLFloat> *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLRPCParameterNameAccelerationPedalPosition];
}

- (nullable NSNumber<SDLFloat> *)accPedalPosition {
    return [parameters sdl_objectForName:SDLRPCParameterNameAccelerationPedalPosition ofClass:NSNumber.class error:nil];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLRPCParameterNameSteeringWheelAngle];
}

- (nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLRPCParameterNameSteeringWheelAngle ofClass:NSNumber.class error:nil];
}

- (void)setECallInfo:(nullable SDLECallInfo *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLRPCParameterNameECallInfo];
}

- (nullable SDLECallInfo *)eCallInfo {
    return [parameters sdl_objectForName:SDLRPCParameterNameECallInfo ofClass:SDLECallInfo.class error:nil];
}

- (void)setAirbagStatus:(nullable SDLAirbagStatus *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLRPCParameterNameAirbagStatus];
}

- (nullable SDLAirbagStatus *)airbagStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameAirbagStatus ofClass:SDLAirbagStatus.class error:nil];
}

- (void)setEmergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLRPCParameterNameEmergencyEvent];
}

- (nullable SDLEmergencyEvent *)emergencyEvent {
    return [parameters sdl_objectForName:SDLRPCParameterNameEmergencyEvent ofClass:SDLEmergencyEvent.class error:nil];
}

- (void)setClusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus {
    [parameters sdl_setObject:clusterModeStatus forName:SDLRPCParameterNameClusterModeStatus];
}

- (nullable SDLClusterModeStatus *)clusterModeStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameClusterModeStatus ofClass:SDLClusterModeStatus.class error:nil];
}

- (void)setMyKey:(nullable SDLMyKey *)myKey {
    [parameters sdl_setObject:myKey forName:SDLRPCParameterNameMyKey];
}

- (nullable SDLMyKey *)myKey {
    return [parameters sdl_objectForName:SDLRPCParameterNameMyKey ofClass:SDLMyKey.class error:nil];
}

- (void)setElectronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    [parameters sdl_setObject:electronicParkBrakeStatus forName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    return [parameters sdl_enumForName:SDLRPCParameterNameElectronicParkBrakeStatus error:nil];
}

- (void)setTurnSignal:(nullable SDLTurnSignal)turnSignal {
    [parameters sdl_setObject:turnSignal forName:SDLRPCParameterNameTurnSignal];
}

- (nullable SDLTurnSignal)turnSignal {
    return [parameters sdl_enumForName:SDLRPCParameterNameTurnSignal error:nil];
}

- (void)setCloudAppVehicleID:(nullable NSString *)cloudAppVehicleID {
    [parameters sdl_setObject:cloudAppVehicleID forName:SDLRPCParameterNameCloudAppVehicleID];
}

- (nullable NSString *)cloudAppVehicleID {
    return [parameters sdl_objectForName:SDLRPCParameterNameCloudAppVehicleID ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
