//
//  SDLRCButtonPressResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLButtonPressResponse.h"

#import "SDLNames.h"


@implementation SDLButtonPressResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_ButtonPress]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

@end
