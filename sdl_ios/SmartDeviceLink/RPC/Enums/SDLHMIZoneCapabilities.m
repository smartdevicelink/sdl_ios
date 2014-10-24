//  SDLHmiZoneCapabilities.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLHmiZoneCapabilities.h>

SDLHmiZoneCapabilities* SDLHmiZoneCapabilities_FRONT = nil;
SDLHmiZoneCapabilities* SDLHmiZoneCapabilities_BACK = nil;

NSMutableArray* SDLHmiZoneCapabilities_values = nil;

@implementation SDLHmiZoneCapabilities

+(SDLHmiZoneCapabilities*) valueOf:(NSString*) value {
    for (SDLHmiZoneCapabilities* item in SDLHmiZoneCapabilities.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLHmiZoneCapabilities_values == nil) {
        SDLHmiZoneCapabilities_values = [[NSMutableArray alloc] initWithObjects:
                SDLHmiZoneCapabilities.FRONT,
                SDLHmiZoneCapabilities.BACK,
                nil];
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
