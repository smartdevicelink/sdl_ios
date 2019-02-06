//
//  SDLPublishAppService.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLPublishAppService.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLPublishAppService

- (instancetype)init {
    if (self = [super initWithName:SDLNamePublishAppService]) {
    }
    return self;
}

- (instancetype)initWithAppServiceManifest:(SDLAppServiceManifest *)appServiceManifest {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appServiceManifest = appServiceManifest;

    return self;
}

- (void)setAppServiceManifest:(SDLAppServiceManifest *)appServiceManifest {
    [parameters sdl_setObject:appServiceManifest forName:SDLNameAppServiceManifest];
}

- (SDLAppServiceManifest *)appServiceManifest {
    return [parameters sdl_objectForName:SDLNameAppServiceManifest ofClass:SDLAppServiceManifest.class];
}

@end

NS_ASSUME_NONNULL_END
