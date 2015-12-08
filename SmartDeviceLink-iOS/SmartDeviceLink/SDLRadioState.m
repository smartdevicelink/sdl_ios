//
//  SDLRadioState.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRadioState.h"


SDLRadioState *SDLRadioState_ACQUIRING = nil;
SDLRadioState *SDLRadioState_ACQUIRED = nil;
SDLRadioState *SDLRadioState_MULTICAST = nil;
SDLRadioState *SDLRadioState_NOT_FOUND = nil;

NSArray *SDLRadioState_values = nil;


@implementation SDLRadioState

+ (SDLRadioState *)valueOf:(NSString *)value {
    for (SDLRadioState *item in SDLRadioState.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLRadioState_values == nil) {
        SDLRadioState_values = @[[SDLRadioState ACQUIRING],
                                 [SDLRadioState ACQUIRED],
                                 [SDLRadioState MULTICAST],
                                 [SDLRadioState NOT_FOUND]];
    }
    return SDLRadioState_values;
}

+ (SDLRadioState *)ACQUIRING {
    if (SDLRadioState_ACQUIRING == nil) {
        SDLRadioState_ACQUIRING = [[SDLRadioState alloc] initWithValue:@"ACQUIRING"];
    }
    
    return SDLRadioState_ACQUIRING;
}

+ (SDLRadioState *)ACQUIRED {
    if (SDLRadioState_ACQUIRED == nil) {
        SDLRadioState_ACQUIRED = [[SDLRadioState alloc] initWithValue:@"ACQUIRED"];
    }
    
    return SDLRadioState_ACQUIRED;
}

+ (SDLRadioState *)MULTICAST {
    if (SDLRadioState_MULTICAST == nil) {
        SDLRadioState_MULTICAST = [[SDLRadioState alloc] initWithValue:@"MULTICAST"];
    }
    
    return SDLRadioState_MULTICAST;
}

+ (SDLRadioState *)NOT_FOUND {
    if (SDLRadioState_NOT_FOUND == nil) {
        SDLRadioState_NOT_FOUND = [[SDLRadioState alloc] initWithValue:@"NOT_FOUND"];
    }
    
    return SDLRadioState_NOT_FOUND;
}

@end
