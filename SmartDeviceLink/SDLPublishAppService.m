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

- (void)setAppServiceManifest:(SDLAppServiceManifest *)appServiceManifest {
    [store sdl_setObject:appServiceManifest forName:SDLNameAppServiceManifest];
}

- (SDLAppServiceManifest *)appServiceManifest {
    return [store sdl_objectForName:SDLNameAppServiceManifest ofClass:SDLAppServiceManifest.class];
}

@end

NS_ASSUME_NONNULL_END
