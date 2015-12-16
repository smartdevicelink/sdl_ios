//
//  SDLModuleType.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLModuleType.h"


SDLModuleType *SDLModuleType_CLIMATE = nil;
SDLModuleType *SDLModuleType_RADIO = nil;

NSArray *SDLModuleType_values = nil;


@implementation SDLModuleType

+ (SDLModuleType *)valueOf:(NSString *)value {
    for (SDLModuleType *item in SDLModuleType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLModuleType_values == nil) {
        SDLModuleType_values = @[SDLModuleType.RADIO,
                                 SDLModuleType.CLIMATE];
    }
    return SDLModuleType_values;
}

+ (SDLModuleType *)CLIMATE {
    if (SDLModuleType_CLIMATE == nil) {
        SDLModuleType_CLIMATE = [[SDLModuleType alloc] initWithValue:@"CLIMATE"];
    }
    
    return SDLModuleType_CLIMATE;
}

+ (SDLModuleType *)RADIO {
    if (SDLModuleType_RADIO == nil) {
        SDLModuleType_RADIO = [[SDLModuleType alloc] initWithValue:@"RADIO"];
    }
    
    return SDLModuleType_RADIO;
}

@end
