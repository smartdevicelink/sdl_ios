//  SDLEmergencyEventType.m
//


#import "SDLEmergencyEventType.h"

SDLEmergencyEventType *SDLEmergencyEventType_NO_EVENT = nil;
SDLEmergencyEventType *SDLEmergencyEventType_FRONTAL = nil;
SDLEmergencyEventType *SDLEmergencyEventType_SIDE = nil;
SDLEmergencyEventType *SDLEmergencyEventType_REAR = nil;
SDLEmergencyEventType *SDLEmergencyEventType_ROLLOVER = nil;
SDLEmergencyEventType *SDLEmergencyEventType_NOT_SUPPORTED = nil;
SDLEmergencyEventType *SDLEmergencyEventType_FAULT = nil;

NSArray *SDLEmergencyEventType_values = nil;

@implementation SDLEmergencyEventType

+ (SDLEmergencyEventType *)valueOf:(NSString *)value {
    for (SDLEmergencyEventType *item in SDLEmergencyEventType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLEmergencyEventType_values == nil) {
        SDLEmergencyEventType_values = @[
            SDLEmergencyEventType.NO_EVENT,
            SDLEmergencyEventType.FRONTAL,
            SDLEmergencyEventType.SIDE,
            SDLEmergencyEventType.REAR,
            SDLEmergencyEventType.ROLLOVER,
            SDLEmergencyEventType.NOT_SUPPORTED,
            SDLEmergencyEventType.FAULT,
        ];
    }
    return SDLEmergencyEventType_values;
}

+ (SDLEmergencyEventType *)NO_EVENT {
    if (SDLEmergencyEventType_NO_EVENT == nil) {
        SDLEmergencyEventType_NO_EVENT = [[SDLEmergencyEventType alloc] initWithValue:@"NO_EVENT"];
    }
    return SDLEmergencyEventType_NO_EVENT;
}

+ (SDLEmergencyEventType *)FRONTAL {
    if (SDLEmergencyEventType_FRONTAL == nil) {
        SDLEmergencyEventType_FRONTAL = [[SDLEmergencyEventType alloc] initWithValue:@"FRONTAL"];
    }
    return SDLEmergencyEventType_FRONTAL;
}

+ (SDLEmergencyEventType *)SIDE {
    if (SDLEmergencyEventType_SIDE == nil) {
        SDLEmergencyEventType_SIDE = [[SDLEmergencyEventType alloc] initWithValue:@"SIDE"];
    }
    return SDLEmergencyEventType_SIDE;
}

+ (SDLEmergencyEventType *)REAR {
    if (SDLEmergencyEventType_REAR == nil) {
        SDLEmergencyEventType_REAR = [[SDLEmergencyEventType alloc] initWithValue:@"REAR"];
    }
    return SDLEmergencyEventType_REAR;
}

+ (SDLEmergencyEventType *)ROLLOVER {
    if (SDLEmergencyEventType_ROLLOVER == nil) {
        SDLEmergencyEventType_ROLLOVER = [[SDLEmergencyEventType alloc] initWithValue:@"ROLLOVER"];
    }
    return SDLEmergencyEventType_ROLLOVER;
}

+ (SDLEmergencyEventType *)NOT_SUPPORTED {
    if (SDLEmergencyEventType_NOT_SUPPORTED == nil) {
        SDLEmergencyEventType_NOT_SUPPORTED = [[SDLEmergencyEventType alloc] initWithValue:@"NOT_SUPPORTED"];
    }
    return SDLEmergencyEventType_NOT_SUPPORTED;
}

+ (SDLEmergencyEventType *)FAULT {
    if (SDLEmergencyEventType_FAULT == nil) {
        SDLEmergencyEventType_FAULT = [[SDLEmergencyEventType alloc] initWithValue:@"FAULT"];
    }
    return SDLEmergencyEventType_FAULT;
}

@end
