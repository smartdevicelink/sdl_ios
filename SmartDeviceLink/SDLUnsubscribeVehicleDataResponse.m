//  SDLUnsubscribeVehicleDataResponse.m
//


#import "SDLUnsubscribeVehicleDataResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLVehicleDataResult.h"

@implementation SDLUnsubscribeVehicleDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameUnsubscribeVehicleData]) {
    }
    return self;
}

- (void)setGps:(SDLVehicleDataResult *)gps {
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (SDLVehicleDataResult *)gps {
    NSObject *obj = [parameters objectForKey:SDLNameGPS];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSpeed:(SDLVehicleDataResult *)speed {
    [parameters sdl_setObject:speed forName:SDLNameSpeed];
}

- (SDLVehicleDataResult *)speed {
    NSObject *obj = [parameters objectForKey:SDLNameSpeed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setRpm:(SDLVehicleDataResult *)rpm {
    [parameters sdl_setObject:rpm forName:SDLNameRPM];
}

- (SDLVehicleDataResult *)rpm {
    NSObject *obj = [parameters objectForKey:SDLNameRPM];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setFuelLevel:(SDLVehicleDataResult *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (SDLVehicleDataResult *)fuelLevel {
    NSObject *obj = [parameters objectForKey:SDLNameFuelLevel];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setFuelLevel_State:(SDLVehicleDataResult *)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (SDLVehicleDataResult *)fuelLevel_State {
    NSObject *obj = [parameters objectForKey:SDLNameFuelLevelState];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setInstantFuelConsumption:(SDLVehicleDataResult *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (SDLVehicleDataResult *)instantFuelConsumption {
    NSObject *obj = [parameters objectForKey:SDLNameInstantFuelConsumption];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setExternalTemperature:(SDLVehicleDataResult *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (SDLVehicleDataResult *)externalTemperature {
    NSObject *obj = [parameters objectForKey:SDLNameExternalTemperature];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setPrndl:(SDLVehicleDataResult *)prndl {
    [parameters sdl_setObject:prndl forName:SDLNamePRNDL];
}

- (SDLVehicleDataResult *)prndl {
    NSObject *obj = [parameters objectForKey:SDLNamePRNDL];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setTirePressure:(SDLVehicleDataResult *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (SDLVehicleDataResult *)tirePressure {
    NSObject *obj = [parameters objectForKey:SDLNameTirePressure];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setOdometer:(SDLVehicleDataResult *)odometer {
    [parameters sdl_setObject:odometer forName:SDLNameOdometer];
}

- (SDLVehicleDataResult *)odometer {
    NSObject *obj = [parameters objectForKey:SDLNameOdometer];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setBeltStatus:(SDLVehicleDataResult *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLNameBeltStatus];
}

- (SDLVehicleDataResult *)beltStatus {
    NSObject *obj = [parameters objectForKey:SDLNameBeltStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setBodyInformation:(SDLVehicleDataResult *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (SDLVehicleDataResult *)bodyInformation {
    NSObject *obj = [parameters objectForKey:SDLNameBodyInformation];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDeviceStatus:(SDLVehicleDataResult *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (SDLVehicleDataResult *)deviceStatus {
    NSObject *obj = [parameters objectForKey:SDLNameDeviceStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDriverBraking:(SDLVehicleDataResult *)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (SDLVehicleDataResult *)driverBraking {
    NSObject *obj = [parameters objectForKey:SDLNameDriverBraking];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setWiperStatus:(SDLVehicleDataResult *)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (SDLVehicleDataResult *)wiperStatus {
    NSObject *obj = [parameters objectForKey:SDLNameWiperStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setHeadLampStatus:(SDLVehicleDataResult *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (SDLVehicleDataResult *)headLampStatus {
    NSObject *obj = [parameters objectForKey:SDLNameHeadLampStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setEngineTorque:(SDLVehicleDataResult *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLNameEngineTorque];
}

- (SDLVehicleDataResult *)engineTorque {
    NSObject *obj = [parameters objectForKey:SDLNameEngineTorque];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setAccPedalPosition:(SDLVehicleDataResult *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (SDLVehicleDataResult *)accPedalPosition {
    NSObject *obj = [parameters objectForKey:SDLNameAccelerationPedalPosition];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSteeringWheelAngle:(SDLVehicleDataResult *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (SDLVehicleDataResult *)steeringWheelAngle {
    NSObject *obj = [parameters objectForKey:SDLNameSteeringWheelAngle];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setECallInfo:(SDLVehicleDataResult *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLNameECallInfo];
}

- (SDLVehicleDataResult *)eCallInfo {
    NSObject *obj = [parameters objectForKey:SDLNameECallInfo];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setAirbagStatus:(SDLVehicleDataResult *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (SDLVehicleDataResult *)airbagStatus {
    NSObject *obj = [parameters objectForKey:SDLNameAirbagStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setEmergencyEvent:(SDLVehicleDataResult *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (SDLVehicleDataResult *)emergencyEvent {
    NSObject *obj = [parameters objectForKey:SDLNameEmergencyEvent];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setClusterModes:(SDLVehicleDataResult *)clusterModes {
    [parameters sdl_setObject:clusterModes forName:SDLNameClusterModes];
}

- (SDLVehicleDataResult *)clusterModes {
    NSObject *obj = [parameters objectForKey:SDLNameClusterModes];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setMyKey:(SDLVehicleDataResult *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (SDLVehicleDataResult *)myKey {
    NSObject *obj = [parameters objectForKey:SDLNameMyKey];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult *)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
