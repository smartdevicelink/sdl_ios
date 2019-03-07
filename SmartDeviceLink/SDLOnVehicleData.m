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
#import "SDLNames.h"
#import "SDLTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnVehicleData]) {
    }
    return self;
}

- (void)setGps:(nullable SDLGPSData *)gps {
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (nullable SDLGPSData *)gps {
    return [parameters sdl_objectForName:SDLNameGPS ofClass:SDLGPSData.class];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [parameters sdl_setObject:speed forName:SDLNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [parameters sdl_objectForName:SDLNameSpeed ofClass:NSNumber.class];
}

- (void)setRpm:(nullable NSNumber<SDLInt> *)rpm {
    [parameters sdl_setObject:rpm forName:SDLNameRPM];
}

- (nullable NSNumber<SDLInt> *)rpm {
    return [parameters sdl_objectForName:SDLNameRPM ofClass:NSNumber.class];
}

- (void)setFuelLevel:(nullable NSNumber<SDLFloat> *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (nullable NSNumber<SDLFloat> *)fuelLevel {
    return [parameters sdl_objectForName:SDLNameFuelLevel ofClass:NSNumber.class];
}

- (void)setFuelLevel_State:(nullable SDLComponentVolumeStatus)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (nullable SDLComponentVolumeStatus)fuelLevel_State {
    return [parameters sdl_enumForName:SDLNameFuelLevelState];
}

- (void)setFuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange {
    [parameters sdl_setObject:fuelRange forName:SDLNameFuelRange];
}

- (nullable NSArray<SDLFuelRange *> *)fuelRange {
    return [parameters sdl_objectsForName:SDLNameFuelRange ofClass:SDLFuelRange.class];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLNameInstantFuelConsumption ofClass:NSNumber.class];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLFloat> *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (nullable NSNumber<SDLFloat> *)externalTemperature {
    return [parameters sdl_objectForName:SDLNameExternalTemperature ofClass:NSNumber.class];
}

- (void)setVin:(nullable NSString *)vin {
    [parameters sdl_setObject:vin forName:SDLNameVIN];
}

- (nullable NSString *)vin {
    return [parameters sdl_objectForName:SDLNameVIN ofClass:NSString.class];
}

- (void)setPrndl:(nullable SDLPRNDL)prndl {
    [parameters sdl_setObject:prndl forName:SDLNamePRNDL];
}

- (nullable SDLPRNDL)prndl {
    return [parameters sdl_enumForName:SDLNamePRNDL];
}

- (void)setTirePressure:(nullable SDLTireStatus *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (nullable SDLTireStatus *)tirePressure {
    return [parameters sdl_objectForName:SDLNameTirePressure ofClass:SDLTireStatus.class];
}

- (void)setOdometer:(nullable NSNumber<SDLInt> *)odometer {
    [parameters sdl_setObject:odometer forName:SDLNameOdometer];
}

- (nullable NSNumber<SDLInt> *)odometer {
    return [parameters sdl_objectForName:SDLNameOdometer ofClass:NSNumber.class];
}

- (void)setBeltStatus:(nullable SDLBeltStatus *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLNameBeltStatus];
}

- (nullable SDLBeltStatus *)beltStatus {
    return [parameters sdl_objectForName:SDLNameBeltStatus ofClass:SDLBeltStatus.class];
}

- (void)setBodyInformation:(nullable SDLBodyInformation *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (nullable SDLBodyInformation *)bodyInformation {
    return [parameters sdl_objectForName:SDLNameBodyInformation ofClass:SDLBodyInformation.class];
}

- (void)setDeviceStatus:(nullable SDLDeviceStatus *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (nullable SDLDeviceStatus *)deviceStatus {
    return [parameters sdl_objectForName:SDLNameDeviceStatus ofClass:SDLDeviceStatus.class];
}

- (void)setDriverBraking:(nullable SDLVehicleDataEventStatus)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (nullable SDLVehicleDataEventStatus)driverBraking {
    return [parameters sdl_enumForName:SDLNameDriverBraking];
}

- (void)setWiperStatus:(nullable SDLWiperStatus)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (nullable SDLWiperStatus)wiperStatus {
    return [parameters sdl_enumForName:SDLNameWiperStatus];
}

- (void)setHeadLampStatus:(nullable SDLHeadLampStatus *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (nullable SDLHeadLampStatus *)headLampStatus {
    return [parameters sdl_objectForName:SDLNameHeadLampStatus ofClass:SDLHeadLampStatus.class];
}

- (void)setEngineOilLife:(nullable NSNumber<SDLFloat> *)engineOilLife {
    [parameters sdl_setObject:engineOilLife forName:SDLNameEngineOilLife];
}

- (nullable NSNumber<SDLFloat> *)engineOilLife {
    return [parameters sdl_objectForName:SDLNameEngineOilLife ofClass:NSNumber.class];
}

- (void)setEngineTorque:(nullable NSNumber<SDLFloat> *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLNameEngineTorque];
}

- (nullable NSNumber<SDLFloat> *)engineTorque {
    return [parameters sdl_objectForName:SDLNameEngineTorque ofClass:NSNumber.class];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLFloat> *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (nullable NSNumber<SDLFloat> *)accPedalPosition {
    return [parameters sdl_objectForName:SDLNameAccelerationPedalPosition ofClass:NSNumber.class];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLNameSteeringWheelAngle ofClass:NSNumber.class];
}

- (void)setECallInfo:(nullable SDLECallInfo *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLNameECallInfo];
}

- (nullable SDLECallInfo *)eCallInfo {
    return [parameters sdl_objectForName:SDLNameECallInfo ofClass:SDLECallInfo.class];
}

- (void)setAirbagStatus:(nullable SDLAirbagStatus *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (nullable SDLAirbagStatus *)airbagStatus {
    return [parameters sdl_objectForName:SDLNameAirbagStatus ofClass:SDLAirbagStatus.class];
}

- (void)setEmergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (nullable SDLEmergencyEvent *)emergencyEvent {
    return [parameters sdl_objectForName:SDLNameEmergencyEvent ofClass:SDLEmergencyEvent.class];
}

- (void)setClusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus {
    [parameters sdl_setObject:clusterModeStatus forName:SDLNameClusterModeStatus];
}

- (nullable SDLClusterModeStatus *)clusterModeStatus {
    return [parameters sdl_objectForName:SDLNameClusterModeStatus ofClass:SDLClusterModeStatus.class];
}

- (void)setMyKey:(nullable SDLMyKey *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (nullable SDLMyKey *)myKey {
    return [parameters sdl_objectForName:SDLNameMyKey ofClass:SDLMyKey.class];
}

- (void)setElectronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    [parameters sdl_setObject:electronicParkBrakeStatus forName:SDLNameElectronicParkBrakeStatus];
}

- (nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    return [parameters sdl_enumForName:SDLNameElectronicParkBrakeStatus];
}

- (void)setTurnSignal:(nullable SDLTurnSignal)turnSignal {
    [parameters sdl_setObject:turnSignal forName:SDLNameTurnSignal];
}

- (nullable SDLTurnSignal)turnSignal {
    return [parameters sdl_enumForName:SDLNameTurnSignal];
}

@end

NS_ASSUME_NONNULL_END
