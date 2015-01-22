//  SDLVehicleDataResult.m
//
//  

#import <SmartDeviceLink/SDLVehicleDataResult.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLVehicleDataResult

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setDataType:(SDLVehicleDataType*) dataType {
    if (dataType != nil) {
        [store setObject:dataType forKey:NAMES_dataType];
    } else {
        [store removeObjectForKey:NAMES_dataType];
    }
}

-(SDLVehicleDataType*) dataType {
    NSObject* obj = [store objectForKey:NAMES_dataType];
    if ([obj isKindOfClass:SDLVehicleDataType.class]) {
        return (SDLVehicleDataType*)obj;
    } else {
        return [SDLVehicleDataType valueOf:(NSString*)obj];
    }
}

-(void) setResultCode:(SDLVehicleDataResultCode*) resultCode {
    if (resultCode != nil) {
        [store setObject:resultCode forKey:NAMES_resultCode];
    } else {
        [store removeObjectForKey:NAMES_resultCode];
    }
}

-(SDLVehicleDataResultCode*) resultCode {
    NSObject* obj = [store objectForKey:NAMES_resultCode];
    if ([obj isKindOfClass:SDLVehicleDataResultCode.class]) {
        return (SDLVehicleDataResultCode*)obj;
    } else {
        return [SDLVehicleDataResultCode valueOf:(NSString*)obj];
    }
}

@end
