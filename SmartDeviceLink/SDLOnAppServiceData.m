//
//  SDLOnAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLOnAppServiceData.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAppServiceData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnAppServiceData]) {
    }
    return self;
}

- (void)setServiceData:(SDLAppServiceData *)serviceData {
    [parameters sdl_setObject:serviceData forName:SDLNameServiceData];
}

- (SDLAppServiceData *)serviceData {
    return [parameters sdl_objectForName:SDLNameServiceData ofClass:SDLAppServiceData.class];
}

@end

NS_ASSUME_NONNULL_END
