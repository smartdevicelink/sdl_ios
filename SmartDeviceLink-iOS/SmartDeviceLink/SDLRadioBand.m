//
//  SDLRadioBand.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRadioBand.h"


SDLRadioBand *SDLRadioBand_AM = nil;
SDLRadioBand *SDLRadioBand_FM = nil;
SDLRadioBand *SDLRadioBand_XM = nil;

NSArray *SDLRadioBand_values = nil;


@implementation SDLRadioBand

+ (SDLRadioBand *)valueOf:(NSString *)value {
    for (SDLRadioBand *item in SDLRadioBand.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLRadioBand_values == nil) {
        SDLRadioBand_values = @[[SDLRadioBand AM],
                                [SDLRadioBand FM],
                                [SDLRadioBand XM]];
    }
    
    return SDLRadioBand_values;
}

+ (SDLRadioBand *)AM {
    if (SDLRadioBand_AM == nil) {
        SDLRadioBand_AM = [[SDLRadioBand alloc] initWithValue:@"AM"];
    }
    
    return SDLRadioBand_AM;
}

+ (SDLRadioBand *)FM {
    if (SDLRadioBand_FM == nil) {
        SDLRadioBand_FM = [[SDLRadioBand alloc] initWithValue:@"FM"];
    }
    
    return SDLRadioBand_FM;
}

+ (SDLRadioBand *)XM {
    if (SDLRadioBand_XM == nil) {
        SDLRadioBand_XM = [[SDLRadioBand alloc] initWithValue:@"XM"];
    }
    
    return SDLRadioBand_XM;
}

@end
