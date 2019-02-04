//
//  SDLAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceData.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceData

- (void)setServiceType:(SDLAppServiceType)serviceType {
    [store sdl_setObject:serviceType forName:SDLNameServiceType];
}

- (SDLAppServiceType)serviceType {
    return [store sdl_objectForName:SDLNameServiceType];
}

- (void)setServiceId:(NSString *)serviceId {
    [store sdl_setObject:serviceId forName:SDLNameServiceId];
}

-(NSString *)serviceId {
    return [store sdl_objectForName:SDLNameServiceId];
}

@end

NS_ASSUME_NONNULL_END
