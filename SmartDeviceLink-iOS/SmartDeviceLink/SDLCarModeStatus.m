//  SDLCarModeStatus.m
//


#import "SDLCarModeStatus.h"

SDLCarModeStatus *SDLCarModeStatus_NORMAL = nil;
SDLCarModeStatus *SDLCarModeStatus_FACTORY = nil;
SDLCarModeStatus *SDLCarModeStatus_TRANSPORT = nil;
SDLCarModeStatus *SDLCarModeStatus_CRASH = nil;

NSArray *SDLCarModeStatus_values = nil;

@implementation SDLCarModeStatus

+ (SDLCarModeStatus *)valueOf:(NSString *)value {
    for (SDLCarModeStatus *item in SDLCarModeStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLCarModeStatus_values == nil) {
        SDLCarModeStatus_values = @[
            SDLCarModeStatus.NORMAL,
            SDLCarModeStatus.FACTORY,
            SDLCarModeStatus.TRANSPORT,
            SDLCarModeStatus.CRASH,
        ];
    }
    return SDLCarModeStatus_values;
}

+ (SDLCarModeStatus *)NORMAL {
    if (SDLCarModeStatus_NORMAL == nil) {
        SDLCarModeStatus_NORMAL = [[SDLCarModeStatus alloc] initWithValue:@"NORMAL"];
    }
    return SDLCarModeStatus_NORMAL;
}

+ (SDLCarModeStatus *)FACTORY {
    if (SDLCarModeStatus_FACTORY == nil) {
        SDLCarModeStatus_FACTORY = [[SDLCarModeStatus alloc] initWithValue:@"FACTORY"];
    }
    return SDLCarModeStatus_FACTORY;
}

+ (SDLCarModeStatus *)TRANSPORT {
    if (SDLCarModeStatus_TRANSPORT == nil) {
        SDLCarModeStatus_TRANSPORT = [[SDLCarModeStatus alloc] initWithValue:@"TRANSPORT"];
    }
    return SDLCarModeStatus_TRANSPORT;
}

+ (SDLCarModeStatus *)CRASH {
    if (SDLCarModeStatus_CRASH == nil) {
        SDLCarModeStatus_CRASH = [[SDLCarModeStatus alloc] initWithValue:@"CRASH"];
    }
    return SDLCarModeStatus_CRASH;
}

@end
