//  SDLHMIZoneCapabilities.m
//


#import "SDLHMIZoneCapabilities.h"

SDLHMIZoneCapabilities* SDLHMIZoneCapabilities_FRONT = nil;
SDLHMIZoneCapabilities* SDLHMIZoneCapabilities_BACK = nil;

NSMutableArray* SDLHMIZoneCapabilities_values = nil;

@implementation SDLHMIZoneCapabilities

+(SDLHMIZoneCapabilities*) valueOf:(NSString*) value {
    for (SDLHMIZoneCapabilities* item in SDLHMIZoneCapabilities.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLHMIZoneCapabilities_values == nil) {
        SDLHMIZoneCapabilities_values = [[NSMutableArray alloc] initWithObjects:
                SDLHMIZoneCapabilities.FRONT,
                SDLHMIZoneCapabilities.BACK,
                nil];
    }
    return SDLHMIZoneCapabilities_values;
}

+(SDLHMIZoneCapabilities*) FRONT {
    if (SDLHMIZoneCapabilities_FRONT == nil) {
        SDLHMIZoneCapabilities_FRONT = [[SDLHMIZoneCapabilities alloc] initWithValue:@"FRONT"];
    }
    return SDLHMIZoneCapabilities_FRONT;
}

+(SDLHMIZoneCapabilities*) BACK {
    if (SDLHMIZoneCapabilities_BACK == nil) {
        SDLHMIZoneCapabilities_BACK = [[SDLHMIZoneCapabilities alloc] initWithValue:@"BACK"];
    }
    return SDLHMIZoneCapabilities_BACK;
}

@end
