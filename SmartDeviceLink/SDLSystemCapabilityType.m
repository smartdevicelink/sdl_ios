//
//  SDLSystemCapabilityType.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapabilityType.h"

SDLSystemCapabilityType *SDLSystemCapabilityType_NAVIGATION = nil;
SDLSystemCapabilityType *SDLSystemCapabilityType_PHONE_CALL = nil;
SDLSystemCapabilityType *SDLSystemCapabilityType_VIDEO_STREAMING = nil;

NSArray *SDLSystemCapabilityType_values = nil;

@implementation SDLSystemCapabilityType

+ (SDLSystemCapabilityType *)valueOf:(NSString *)value {
    for (SDLSystemCapabilityType *item in SDLSystemCapabilityType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLSystemCapabilityType_values == nil) {
        SDLSystemCapabilityType_values = @[
                                    SDLSystemCapabilityType.NAVIGATION,
                                    SDLSystemCapabilityType.PHONE_CALL,
                                    SDLSystemCapabilityType.VIDEO_STREAMING
                                    ];
    }
    return SDLSystemCapabilityType_values;
}

+ (SDLSystemCapabilityType *)NAVIGATION {
    if (SDLSystemCapabilityType_NAVIGATION == nil) {
        SDLSystemCapabilityType_NAVIGATION = [[SDLSystemCapabilityType alloc] initWithValue:@"NAVIGATION"];
    }
    return SDLSystemCapabilityType_NAVIGATION;
}

+ (SDLSystemCapabilityType *)PHONE_CALL {
    if (SDLSystemCapabilityType_PHONE_CALL == nil) {
        SDLSystemCapabilityType_PHONE_CALL = [[SDLSystemCapabilityType alloc] initWithValue:@"PHONE_CALL"];
    }
    return SDLSystemCapabilityType_PHONE_CALL;
}

+ (SDLSystemCapabilityType *)VIDEO_STREAMING {
    if (SDLSystemCapabilityType_VIDEO_STREAMING == nil) {
        SDLSystemCapabilityType_VIDEO_STREAMING = [[SDLSystemCapabilityType alloc] initWithValue:@"VIDEO_STREAMING"];
    }
    return SDLSystemCapabilityType_VIDEO_STREAMING;
}

@end
