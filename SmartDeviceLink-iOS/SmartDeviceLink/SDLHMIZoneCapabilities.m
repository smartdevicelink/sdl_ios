//  SDLHmiZoneCapabilities.m
//


#import "SDLHmiZoneCapabilities.h"

SDLHmiZoneCapabilities* SDLHmiZoneCapabilities_FRONT = nil;
SDLHmiZoneCapabilities* SDLHmiZoneCapabilities_BACK = nil;

NSArray* SDLHmiZoneCapabilities_values = nil;

@implementation SDLHmiZoneCapabilities

+(SDLHmiZoneCapabilities*) valueOf:(NSString*) value {
    for (SDLHmiZoneCapabilities* item in SDLHmiZoneCapabilities.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSArray*) values {
    if (SDLHmiZoneCapabilities_values == nil) {
        SDLHmiZoneCapabilities_values = @[
                SDLHmiZoneCapabilities.FRONT,
                SDLHmiZoneCapabilities.BACK,
                ];
    }
    return SDLHmiZoneCapabilities_values;
}

+(SDLHmiZoneCapabilities*) FRONT {
    if (SDLHmiZoneCapabilities_FRONT == nil) {
        SDLHmiZoneCapabilities_FRONT = [[SDLHmiZoneCapabilities alloc] initWithValue:@"FRONT"];
    }
    return SDLHmiZoneCapabilities_FRONT;
}

+(SDLHmiZoneCapabilities*) BACK {
    if (SDLHmiZoneCapabilities_BACK == nil) {
        SDLHmiZoneCapabilities_BACK = [[SDLHmiZoneCapabilities alloc] initWithValue:@"BACK"];
    }
    return SDLHmiZoneCapabilities_BACK;
}

@end
