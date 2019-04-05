//
//  SDLOnAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLOnAppServiceData.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

#import "SDLAppServiceData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAppServiceData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnAppServiceData]) {
    }
    return self;
}

- (instancetype)initWithServiceData:(SDLAppServiceData *)serviceData {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceData = serviceData;

    return self;
}

- (void)setServiceData:(SDLAppServiceData *)serviceData {
    [parameters sdl_setObject:serviceData forName:SDLRPCParameterNameServiceData];
}

- (SDLAppServiceData *)serviceData {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameServiceData ofClass:SDLAppServiceData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
