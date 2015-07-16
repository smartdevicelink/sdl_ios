//
//  SDLConnectionState.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLConnectionState.h"

SDLConnectionState* SDLConnectionState_CONNECTED = nil;
SDLConnectionState* SDLConnectionState_DISCONNECTED = nil;

NSMutableArray* SDLConnectionState_values = nil;

@implementation SDLConnectionState

+(SDLConnectionState*) valueOf:(NSString*) value {
    for (SDLConnectionState* item in SDLConnectionState.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLConnectionState_values == nil) {
        SDLConnectionState_values = [[NSMutableArray alloc] initWithObjects:
                                         SDLConnectionState.CONNECTED,
                                         SDLConnectionState.DISCONNECTED,
                                         nil];
    }
    return SDLConnectionState_values;
}

+(SDLConnectionState*) CONNECTED {
    if (SDLConnectionState_CONNECTED == nil) {
        SDLConnectionState_CONNECTED = [[SDLConnectionState alloc] initWithValue:@"CONNECTED"];
    }
    return SDLConnectionState_CONNECTED;
}

+(SDLConnectionState*) DISCONNECTED {
    if (SDLConnectionState_DISCONNECTED == nil) {
        SDLConnectionState_DISCONNECTED = [[SDLConnectionState alloc] initWithValue:@"DISCONNECTED"];
    }
    return SDLConnectionState_DISCONNECTED;
}

@end
