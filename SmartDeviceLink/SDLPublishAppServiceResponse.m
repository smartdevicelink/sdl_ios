//
//  SDLPublishAppServiceResponse.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLPublishAppServiceResponse.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPublishAppServiceResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNamePublishAppService]) {
    }
    return self;
}

- (void)setAppServiceRecord:(nullable SDLAppServiceRecord *)appServiceRecord {
    [parameters sdl_setObject:appServiceRecord forName:SDLNameAppServiceRecord];
}

- (nullable SDLAppServiceRecord *)appServiceRecord {
    return [parameters sdl_objectForName:SDLNameAppServiceRecord ofClass:SDLAppServiceRecord.class];
}

@end

NS_ASSUME_NONNULL_END
