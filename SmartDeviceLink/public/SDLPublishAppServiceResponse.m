//
//  SDLPublishAppServiceResponse.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLPublishAppServiceResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAppServiceRecord.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPublishAppServiceResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePublishAppService]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithAppServiceRecord:(SDLAppServiceRecord *)appServiceRecord {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appServiceRecord = appServiceRecord;

    return self;
}

- (void)setAppServiceRecord:(nullable SDLAppServiceRecord *)appServiceRecord {
    [self.parameters sdl_setObject:appServiceRecord forName:SDLRPCParameterNameAppServiceRecord];
}

- (nullable SDLAppServiceRecord *)appServiceRecord {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppServiceRecord ofClass:SDLAppServiceRecord.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
