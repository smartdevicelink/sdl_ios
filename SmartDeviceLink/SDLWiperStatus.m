//  SDLWiperStatus.m
//


#import "SDLWiperStatus.h"

SDLWiperStatus *SDLWiperStatus_OFF = nil;
SDLWiperStatus *SDLWiperStatus_AUTO_OFF = nil;
SDLWiperStatus *SDLWiperStatus_OFF_MOVING = nil;
SDLWiperStatus *SDLWiperStatus_MAN_INT_OFF = nil;
SDLWiperStatus *SDLWiperStatus_MAN_INT_ON = nil;
SDLWiperStatus *SDLWiperStatus_MAN_LOW = nil;
SDLWiperStatus *SDLWiperStatus_MAN_HIGH = nil;
SDLWiperStatus *SDLWiperStatus_MAN_FLICK = nil;
SDLWiperStatus *SDLWiperStatus_WASH = nil;
SDLWiperStatus *SDLWiperStatus_AUTO_LOW = nil;
SDLWiperStatus *SDLWiperStatus_AUTO_HIGH = nil;
SDLWiperStatus *SDLWiperStatus_COURTESYWIPE = nil;
SDLWiperStatus *SDLWiperStatus_AUTO_ADJUST = nil;
SDLWiperStatus *SDLWiperStatus_STALLED = nil;
SDLWiperStatus *SDLWiperStatus_NO_DATA_EXISTS = nil;

NSArray *SDLWiperStatus_values = nil;

@implementation SDLWiperStatus

+ (SDLWiperStatus *)valueOf:(NSString *)value {
    for (SDLWiperStatus *item in SDLWiperStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLWiperStatus_values == nil) {
        SDLWiperStatus_values = @[
            SDLWiperStatus.OFF,
            SDLWiperStatus.AUTO_OFF,
            SDLWiperStatus.OFF_MOVING,
            SDLWiperStatus.MAN_INT_OFF,
            SDLWiperStatus.MAN_INT_ON,
            SDLWiperStatus.MAN_LOW,
            SDLWiperStatus.MAN_HIGH,
            SDLWiperStatus.MAN_FLICK,
            SDLWiperStatus.WASH,
            SDLWiperStatus.AUTO_LOW,
            SDLWiperStatus.AUTO_HIGH,
            SDLWiperStatus.COURTESYWIPE,
            SDLWiperStatus.AUTO_ADJUST,
            SDLWiperStatus.STALLED,
            SDLWiperStatus.NO_DATA_EXISTS,
        ];
    }
    return SDLWiperStatus_values;
}

+ (SDLWiperStatus *)OFF {
    if (SDLWiperStatus_OFF == nil) {
        SDLWiperStatus_OFF = [[SDLWiperStatus alloc] initWithValue:@"OFF"];
    }
    return SDLWiperStatus_OFF;
}

+ (SDLWiperStatus *)AUTO_OFF {
    if (SDLWiperStatus_AUTO_OFF == nil) {
        SDLWiperStatus_AUTO_OFF = [[SDLWiperStatus alloc] initWithValue:@"AUTO_OFF"];
    }
    return SDLWiperStatus_AUTO_OFF;
}

+ (SDLWiperStatus *)OFF_MOVING {
    if (SDLWiperStatus_OFF_MOVING == nil) {
        SDLWiperStatus_OFF_MOVING = [[SDLWiperStatus alloc] initWithValue:@"OFF_MOVING"];
    }
    return SDLWiperStatus_OFF_MOVING;
}

+ (SDLWiperStatus *)MAN_INT_OFF {
    if (SDLWiperStatus_MAN_INT_OFF == nil) {
        SDLWiperStatus_MAN_INT_OFF = [[SDLWiperStatus alloc] initWithValue:@"MAN_INT_OFF"];
    }
    return SDLWiperStatus_MAN_INT_OFF;
}

+ (SDLWiperStatus *)MAN_INT_ON {
    if (SDLWiperStatus_MAN_INT_ON == nil) {
        SDLWiperStatus_MAN_INT_ON = [[SDLWiperStatus alloc] initWithValue:@"MAN_INT_ON"];
    }
    return SDLWiperStatus_MAN_INT_ON;
}

+ (SDLWiperStatus *)MAN_LOW {
    if (SDLWiperStatus_MAN_LOW == nil) {
        SDLWiperStatus_MAN_LOW = [[SDLWiperStatus alloc] initWithValue:@"MAN_LOW"];
    }
    return SDLWiperStatus_MAN_LOW;
}

+ (SDLWiperStatus *)MAN_HIGH {
    if (SDLWiperStatus_MAN_HIGH == nil) {
        SDLWiperStatus_MAN_HIGH = [[SDLWiperStatus alloc] initWithValue:@"MAN_HIGH"];
    }
    return SDLWiperStatus_MAN_HIGH;
}

+ (SDLWiperStatus *)MAN_FLICK {
    if (SDLWiperStatus_MAN_FLICK == nil) {
        SDLWiperStatus_MAN_FLICK = [[SDLWiperStatus alloc] initWithValue:@"MAN_FLICK"];
    }
    return SDLWiperStatus_MAN_FLICK;
}

+ (SDLWiperStatus *)WASH {
    if (SDLWiperStatus_WASH == nil) {
        SDLWiperStatus_WASH = [[SDLWiperStatus alloc] initWithValue:@"WASH"];
    }
    return SDLWiperStatus_WASH;
}

+ (SDLWiperStatus *)AUTO_LOW {
    if (SDLWiperStatus_AUTO_LOW == nil) {
        SDLWiperStatus_AUTO_LOW = [[SDLWiperStatus alloc] initWithValue:@"AUTO_LOW"];
    }
    return SDLWiperStatus_AUTO_LOW;
}

+ (SDLWiperStatus *)AUTO_HIGH {
    if (SDLWiperStatus_AUTO_HIGH == nil) {
        SDLWiperStatus_AUTO_HIGH = [[SDLWiperStatus alloc] initWithValue:@"AUTO_HIGH"];
    }
    return SDLWiperStatus_AUTO_HIGH;
}

+ (SDLWiperStatus *)COURTESYWIPE {
    if (SDLWiperStatus_COURTESYWIPE == nil) {
        SDLWiperStatus_COURTESYWIPE = [[SDLWiperStatus alloc] initWithValue:@"COURTESYWIPE"];
    }
    return SDLWiperStatus_COURTESYWIPE;
}

+ (SDLWiperStatus *)AUTO_ADJUST {
    if (SDLWiperStatus_AUTO_ADJUST == nil) {
        SDLWiperStatus_AUTO_ADJUST = [[SDLWiperStatus alloc] initWithValue:@"AUTO_ADJUST"];
    }
    return SDLWiperStatus_AUTO_ADJUST;
}

+ (SDLWiperStatus *)STALLED {
    if (SDLWiperStatus_STALLED == nil) {
        SDLWiperStatus_STALLED = [[SDLWiperStatus alloc] initWithValue:@"STALLED"];
    }
    return SDLWiperStatus_STALLED;
}

+ (SDLWiperStatus *)NO_DATA_EXISTS {
    if (SDLWiperStatus_NO_DATA_EXISTS == nil) {
        SDLWiperStatus_NO_DATA_EXISTS = [[SDLWiperStatus alloc] initWithValue:@"NO_DATA_EXISTS"];
    }
    return SDLWiperStatus_NO_DATA_EXISTS;
}

@end
