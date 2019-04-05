//
//  SDLGetCloudAppProperties.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetCloudAppProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetCloudAppProperties

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetCloudAppProperties]) {
    }
    return self;
}

- (instancetype)initWithAppID:(NSString *)appID {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appID = appID;

    return self;
}

- (void)setAppID:(NSString *)appID {
    [parameters sdl_setObject:appID forName:SDLRPCParameterNameAppId];
}

- (NSString *)appID {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameAppId ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
