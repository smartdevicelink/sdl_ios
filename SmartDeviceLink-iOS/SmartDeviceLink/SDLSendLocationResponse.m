//
//  SDLSendLocationResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 4/2/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLSendLocationResponse.h"

#import "SDLNames.h"


@implementation SDLSendLocationResponse

- (instancetype)init {
    self = [super initWithName:NAMES_SendLocation];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }
    
    return self;
}

@end
