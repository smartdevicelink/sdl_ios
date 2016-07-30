//  SDLVehicleDataResultCode.m
//


#import "SDLVehicleDataResultCode.h"

SDLVehicleDataResultCode *SDLVehicleDataResultCode_SUCCESS = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_TRUNCATED_DATA = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_DISALLOWED = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_USER_DISALLOWED = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_INVALID_ID = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_VEHICLE_DATA_NOT_AVAILABLE = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_DATA_ALREADY_SUBSCRIBED = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_DATA_NOT_SUBSCRIBED = nil;
SDLVehicleDataResultCode *SDLVehicleDataResultCode_IGNORED = nil;

NSArray *SDLVehicleDataResultCode_values = nil;

@implementation SDLVehicleDataResultCode

+ (SDLVehicleDataResultCode *)valueOf:(NSString *)value {
    for (SDLVehicleDataResultCode *item in SDLVehicleDataResultCode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLVehicleDataResultCode_values == nil) {
        SDLVehicleDataResultCode_values = @[
            SDLVehicleDataResultCode.SUCCESS,
            SDLVehicleDataResultCode.TRUNCATED_DATA,
            SDLVehicleDataResultCode.DISALLOWED,
            SDLVehicleDataResultCode.USER_DISALLOWED,
            SDLVehicleDataResultCode.INVALID_ID,
            SDLVehicleDataResultCode.VEHICLE_DATA_NOT_AVAILABLE,
            SDLVehicleDataResultCode.DATA_ALREADY_SUBSCRIBED,
            SDLVehicleDataResultCode.DATA_NOT_SUBSCRIBED,
            SDLVehicleDataResultCode.IGNORED,
        ];
    }
    return SDLVehicleDataResultCode_values;
}

+ (SDLVehicleDataResultCode *)SUCCESS {
    if (SDLVehicleDataResultCode_SUCCESS == nil) {
        SDLVehicleDataResultCode_SUCCESS = [[SDLVehicleDataResultCode alloc] initWithValue:@"SUCCESS"];
    }
    return SDLVehicleDataResultCode_SUCCESS;
}

+ (SDLVehicleDataResultCode *)TRUNCATED_DATA {
    if (SDLVehicleDataResultCode_TRUNCATED_DATA == nil) {
        SDLVehicleDataResultCode_TRUNCATED_DATA = [[SDLVehicleDataResultCode alloc] initWithValue:@"TRUNCATED_DATA"];
    }
    return SDLVehicleDataResultCode_TRUNCATED_DATA;
}

+ (SDLVehicleDataResultCode *)DISALLOWED {
    if (SDLVehicleDataResultCode_DISALLOWED == nil) {
        SDLVehicleDataResultCode_DISALLOWED = [[SDLVehicleDataResultCode alloc] initWithValue:@"DISALLOWED"];
    }
    return SDLVehicleDataResultCode_DISALLOWED;
}

+ (SDLVehicleDataResultCode *)USER_DISALLOWED {
    if (SDLVehicleDataResultCode_USER_DISALLOWED == nil) {
        SDLVehicleDataResultCode_USER_DISALLOWED = [[SDLVehicleDataResultCode alloc] initWithValue:@"USER_DISALLOWED"];
    }
    return SDLVehicleDataResultCode_USER_DISALLOWED;
}

+ (SDLVehicleDataResultCode *)INVALID_ID {
    if (SDLVehicleDataResultCode_INVALID_ID == nil) {
        SDLVehicleDataResultCode_INVALID_ID = [[SDLVehicleDataResultCode alloc] initWithValue:@"INVALID_ID"];
    }
    return SDLVehicleDataResultCode_INVALID_ID;
}

+ (SDLVehicleDataResultCode *)VEHICLE_DATA_NOT_AVAILABLE {
    if (SDLVehicleDataResultCode_VEHICLE_DATA_NOT_AVAILABLE == nil) {
        SDLVehicleDataResultCode_VEHICLE_DATA_NOT_AVAILABLE = [[SDLVehicleDataResultCode alloc] initWithValue:@"VEHICLE_DATA_NOT_AVAILABLE"];
    }
    return SDLVehicleDataResultCode_VEHICLE_DATA_NOT_AVAILABLE;
}

+ (SDLVehicleDataResultCode *)DATA_ALREADY_SUBSCRIBED {
    if (SDLVehicleDataResultCode_DATA_ALREADY_SUBSCRIBED == nil) {
        SDLVehicleDataResultCode_DATA_ALREADY_SUBSCRIBED = [[SDLVehicleDataResultCode alloc] initWithValue:@"DATA_ALREADY_SUBSCRIBED"];
    }
    return SDLVehicleDataResultCode_DATA_ALREADY_SUBSCRIBED;
}

+ (SDLVehicleDataResultCode *)DATA_NOT_SUBSCRIBED {
    if (SDLVehicleDataResultCode_DATA_NOT_SUBSCRIBED == nil) {
        SDLVehicleDataResultCode_DATA_NOT_SUBSCRIBED = [[SDLVehicleDataResultCode alloc] initWithValue:@"DATA_NOT_SUBSCRIBED"];
    }
    return SDLVehicleDataResultCode_DATA_NOT_SUBSCRIBED;
}

+ (SDLVehicleDataResultCode *)IGNORED {
    if (SDLVehicleDataResultCode_IGNORED == nil) {
        SDLVehicleDataResultCode_IGNORED = [[SDLVehicleDataResultCode alloc] initWithValue:@"IGNORED"];
    }
    return SDLVehicleDataResultCode_IGNORED;
}

@end
