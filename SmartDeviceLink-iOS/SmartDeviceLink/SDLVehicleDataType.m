//  SDLVehicleDataType.m
//


#import "SDLVehicleDataType.h"

SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_GPS = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_SPEED = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_RPM = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_FUELLEVEL = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_FUELLEVEL_STATE = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_FUELCONSUMPTION = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_EXTERNTEMP = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_VIN = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_PRNDL = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_TIREPRESSURE = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_ODOMETER = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_BELTSTATUS = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_BODYINFO = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_DEVICESTATUS = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_ECALLINFO = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_AIRBAGSTATUS = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_EMERGENCYEVENT = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_CLUSTERMODESTATUS = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_MYKEY = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_BRAKING = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_WIPERSTATUS = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_HEADLAMPSTATUS = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_BATTVOLTAGE = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_ENGINETORQUE = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_ACCPEDAL = nil;
SDLVehicleDataType *SDLVehicleDataType_VEHICLEDATA_STEERINGWHEEL = nil;

NSArray *SDLVehicleDataType_values = nil;

@implementation SDLVehicleDataType

+ (SDLVehicleDataType *)valueOf:(NSString *)value {
    for (SDLVehicleDataType *item in SDLVehicleDataType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVehicleDataType_values == nil) {
        SDLVehicleDataType_values = @[
            SDLVehicleDataType.VEHICLEDATA_GPS,
            SDLVehicleDataType.VEHICLEDATA_SPEED,
            SDLVehicleDataType.VEHICLEDATA_RPM,
            SDLVehicleDataType.VEHICLEDATA_FUELLEVEL,
            SDLVehicleDataType.VEHICLEDATA_FUELLEVEL_STATE,
            SDLVehicleDataType.VEHICLEDATA_FUELCONSUMPTION,
            SDLVehicleDataType.VEHICLEDATA_EXTERNTEMP,
            SDLVehicleDataType.VEHICLEDATA_VIN,
            SDLVehicleDataType.VEHICLEDATA_PRNDL,
            SDLVehicleDataType.VEHICLEDATA_TIREPRESSURE,
            SDLVehicleDataType.VEHICLEDATA_ODOMETER,
            SDLVehicleDataType.VEHICLEDATA_BELTSTATUS,
            SDLVehicleDataType.VEHICLEDATA_BODYINFO,
            SDLVehicleDataType.VEHICLEDATA_DEVICESTATUS,
            SDLVehicleDataType.VEHICLEDATA_ECALLINFO,
            SDLVehicleDataType.VEHICLEDATA_AIRBAGSTATUS,
            SDLVehicleDataType.VEHICLEDATA_EMERGENCYEVENT,
            SDLVehicleDataType.VEHICLEDATA_CLUSTERMODESTATUS,
            SDLVehicleDataType.VEHICLEDATA_MYKEY,
            SDLVehicleDataType.VEHICLEDATA_BRAKING,
            SDLVehicleDataType.VEHICLEDATA_WIPERSTATUS,
            SDLVehicleDataType.VEHICLEDATA_HEADLAMPSTATUS,
            SDLVehicleDataType.VEHICLEDATA_BATTVOLTAGE,
            SDLVehicleDataType.VEHICLEDATA_ENGINETORQUE,
            SDLVehicleDataType.VEHICLEDATA_ACCPEDAL,
            SDLVehicleDataType.VEHICLEDATA_STEERINGWHEEL,
        ];
    }
    return SDLVehicleDataType_values;
}

+ (SDLVehicleDataType *)VEHICLEDATA_GPS {
    if (SDLVehicleDataType_VEHICLEDATA_GPS == nil) {
        SDLVehicleDataType_VEHICLEDATA_GPS = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_GPS"];
    }
    return SDLVehicleDataType_VEHICLEDATA_GPS;
}

+ (SDLVehicleDataType *)VEHICLEDATA_SPEED {
    if (SDLVehicleDataType_VEHICLEDATA_SPEED == nil) {
        SDLVehicleDataType_VEHICLEDATA_SPEED = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_SPEED"];
    }
    return SDLVehicleDataType_VEHICLEDATA_SPEED;
}

+ (SDLVehicleDataType *)VEHICLEDATA_RPM {
    if (SDLVehicleDataType_VEHICLEDATA_RPM == nil) {
        SDLVehicleDataType_VEHICLEDATA_RPM = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_RPM"];
    }
    return SDLVehicleDataType_VEHICLEDATA_RPM;
}

+ (SDLVehicleDataType *)VEHICLEDATA_FUELLEVEL {
    if (SDLVehicleDataType_VEHICLEDATA_FUELLEVEL == nil) {
        SDLVehicleDataType_VEHICLEDATA_FUELLEVEL = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_FUELLEVEL"];
    }
    return SDLVehicleDataType_VEHICLEDATA_FUELLEVEL;
}

+ (SDLVehicleDataType *)VEHICLEDATA_FUELLEVEL_STATE {
    if (SDLVehicleDataType_VEHICLEDATA_FUELLEVEL_STATE == nil) {
        SDLVehicleDataType_VEHICLEDATA_FUELLEVEL_STATE = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_FUELLEVEL_STATE"];
    }
    return SDLVehicleDataType_VEHICLEDATA_FUELLEVEL_STATE;
}

+ (SDLVehicleDataType *)VEHICLEDATA_FUELCONSUMPTION {
    if (SDLVehicleDataType_VEHICLEDATA_FUELCONSUMPTION == nil) {
        SDLVehicleDataType_VEHICLEDATA_FUELCONSUMPTION = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_FUELCONSUMPTION"];
    }
    return SDLVehicleDataType_VEHICLEDATA_FUELCONSUMPTION;
}

+ (SDLVehicleDataType *)VEHICLEDATA_EXTERNTEMP {
    if (SDLVehicleDataType_VEHICLEDATA_EXTERNTEMP == nil) {
        SDLVehicleDataType_VEHICLEDATA_EXTERNTEMP = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_EXTERNTEMP"];
    }
    return SDLVehicleDataType_VEHICLEDATA_EXTERNTEMP;
}

+ (SDLVehicleDataType *)VEHICLEDATA_VIN {
    if (SDLVehicleDataType_VEHICLEDATA_VIN == nil) {
        SDLVehicleDataType_VEHICLEDATA_VIN = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_VIN"];
    }
    return SDLVehicleDataType_VEHICLEDATA_VIN;
}

+ (SDLVehicleDataType *)VEHICLEDATA_PRNDL {
    if (SDLVehicleDataType_VEHICLEDATA_PRNDL == nil) {
        SDLVehicleDataType_VEHICLEDATA_PRNDL = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_PRNDL"];
    }
    return SDLVehicleDataType_VEHICLEDATA_PRNDL;
}

+ (SDLVehicleDataType *)VEHICLEDATA_TIREPRESSURE {
    if (SDLVehicleDataType_VEHICLEDATA_TIREPRESSURE == nil) {
        SDLVehicleDataType_VEHICLEDATA_TIREPRESSURE = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_TIREPRESSURE"];
    }
    return SDLVehicleDataType_VEHICLEDATA_TIREPRESSURE;
}

+ (SDLVehicleDataType *)VEHICLEDATA_ODOMETER {
    if (SDLVehicleDataType_VEHICLEDATA_ODOMETER == nil) {
        SDLVehicleDataType_VEHICLEDATA_ODOMETER = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_ODOMETER"];
    }
    return SDLVehicleDataType_VEHICLEDATA_ODOMETER;
}

+ (SDLVehicleDataType *)VEHICLEDATA_BELTSTATUS {
    if (SDLVehicleDataType_VEHICLEDATA_BELTSTATUS == nil) {
        SDLVehicleDataType_VEHICLEDATA_BELTSTATUS = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_BELTSTATUS"];
    }
    return SDLVehicleDataType_VEHICLEDATA_BELTSTATUS;
}

+ (SDLVehicleDataType *)VEHICLEDATA_BODYINFO {
    if (SDLVehicleDataType_VEHICLEDATA_BODYINFO == nil) {
        SDLVehicleDataType_VEHICLEDATA_BODYINFO = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_BODYINFO"];
    }
    return SDLVehicleDataType_VEHICLEDATA_BODYINFO;
}

+ (SDLVehicleDataType *)VEHICLEDATA_DEVICESTATUS {
    if (SDLVehicleDataType_VEHICLEDATA_DEVICESTATUS == nil) {
        SDLVehicleDataType_VEHICLEDATA_DEVICESTATUS = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_DEVICESTATUS"];
    }
    return SDLVehicleDataType_VEHICLEDATA_DEVICESTATUS;
}

+ (SDLVehicleDataType *)VEHICLEDATA_ECALLINFO {
    if (SDLVehicleDataType_VEHICLEDATA_ECALLINFO == nil) {
        SDLVehicleDataType_VEHICLEDATA_ECALLINFO = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_ECALLINFO"];
    }
    return SDLVehicleDataType_VEHICLEDATA_ECALLINFO;
}

+ (SDLVehicleDataType *)VEHICLEDATA_AIRBAGSTATUS {
    if (SDLVehicleDataType_VEHICLEDATA_AIRBAGSTATUS == nil) {
        SDLVehicleDataType_VEHICLEDATA_AIRBAGSTATUS = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_AIRBAGSTATUS"];
    }
    return SDLVehicleDataType_VEHICLEDATA_AIRBAGSTATUS;
}

+ (SDLVehicleDataType *)VEHICLEDATA_EMERGENCYEVENT {
    if (SDLVehicleDataType_VEHICLEDATA_EMERGENCYEVENT == nil) {
        SDLVehicleDataType_VEHICLEDATA_EMERGENCYEVENT = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_EMERGENCYEVENT"];
    }
    return SDLVehicleDataType_VEHICLEDATA_EMERGENCYEVENT;
}

+ (SDLVehicleDataType *)VEHICLEDATA_CLUSTERMODESTATUS {
    if (SDLVehicleDataType_VEHICLEDATA_CLUSTERMODESTATUS == nil) {
        SDLVehicleDataType_VEHICLEDATA_CLUSTERMODESTATUS = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_CLUSTERMODESTATUS"];
    }
    return SDLVehicleDataType_VEHICLEDATA_CLUSTERMODESTATUS;
}

+ (SDLVehicleDataType *)VEHICLEDATA_MYKEY {
    if (SDLVehicleDataType_VEHICLEDATA_MYKEY == nil) {
        SDLVehicleDataType_VEHICLEDATA_MYKEY = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_MYKEY"];
    }
    return SDLVehicleDataType_VEHICLEDATA_MYKEY;
}

+ (SDLVehicleDataType *)VEHICLEDATA_BRAKING {
    if (SDLVehicleDataType_VEHICLEDATA_BRAKING == nil) {
        SDLVehicleDataType_VEHICLEDATA_BRAKING = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_BRAKING"];
    }
    return SDLVehicleDataType_VEHICLEDATA_BRAKING;
}

+ (SDLVehicleDataType *)VEHICLEDATA_WIPERSTATUS {
    if (SDLVehicleDataType_VEHICLEDATA_WIPERSTATUS == nil) {
        SDLVehicleDataType_VEHICLEDATA_WIPERSTATUS = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_WIPERSTATUS"];
    }
    return SDLVehicleDataType_VEHICLEDATA_WIPERSTATUS;
}

+ (SDLVehicleDataType *)VEHICLEDATA_HEADLAMPSTATUS {
    if (SDLVehicleDataType_VEHICLEDATA_HEADLAMPSTATUS == nil) {
        SDLVehicleDataType_VEHICLEDATA_HEADLAMPSTATUS = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_HEADLAMPSTATUS"];
    }
    return SDLVehicleDataType_VEHICLEDATA_HEADLAMPSTATUS;
}

+ (SDLVehicleDataType *)VEHICLEDATA_BATTVOLTAGE {
    if (SDLVehicleDataType_VEHICLEDATA_BATTVOLTAGE == nil) {
        SDLVehicleDataType_VEHICLEDATA_BATTVOLTAGE = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_BATTVOLTAGE"];
    }
    return SDLVehicleDataType_VEHICLEDATA_BATTVOLTAGE;
}

+ (SDLVehicleDataType *)VEHICLEDATA_ENGINETORQUE {
    if (SDLVehicleDataType_VEHICLEDATA_ENGINETORQUE == nil) {
        SDLVehicleDataType_VEHICLEDATA_ENGINETORQUE = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_ENGINETORQUE"];
    }
    return SDLVehicleDataType_VEHICLEDATA_ENGINETORQUE;
}

+ (SDLVehicleDataType *)VEHICLEDATA_ACCPEDAL {
    if (SDLVehicleDataType_VEHICLEDATA_ACCPEDAL == nil) {
        SDLVehicleDataType_VEHICLEDATA_ACCPEDAL = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_ACCPEDAL"];
    }
    return SDLVehicleDataType_VEHICLEDATA_ACCPEDAL;
}

+ (SDLVehicleDataType *)VEHICLEDATA_STEERINGWHEEL {
    if (SDLVehicleDataType_VEHICLEDATA_STEERINGWHEEL == nil) {
        SDLVehicleDataType_VEHICLEDATA_STEERINGWHEEL = [[SDLVehicleDataType alloc] initWithValue:@"VEHICLEDATA_STEERINGWHEEL"];
    }
    return SDLVehicleDataType_VEHICLEDATA_STEERINGWHEEL;
}

@end
