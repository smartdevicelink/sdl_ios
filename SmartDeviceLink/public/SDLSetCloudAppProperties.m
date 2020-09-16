//
//  SDLSetCloudAppProperties.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLSetCloudAppProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLCloudAppProperties.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetCloudAppProperties

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetCloudAppProperties]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithProperties:(SDLCloudAppProperties *)properties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.properties = properties;

    return self;
}

- (void)setProperties:(SDLCloudAppProperties *)properties {
    [self.parameters sdl_setObject:properties forName:SDLRPCParameterNameProperties];
}

- (SDLCloudAppProperties *)properties {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameProperties ofClass:SDLCloudAppProperties.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
