//
//  SDLAppServiceCapability.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceCapability.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceCapability

- (instancetype)initWithUpdateReason:(nullable SDLServiceUpdateReason)updateReason updatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord {
    self = [self init];
    if (!self) {
        return self;
    }

    self.updateReason = updateReason;
    self.updatedAppServiceRecord = updatedAppServiceRecord;

    return self;
}

- (void)setUpdateReason:(nullable SDLServiceUpdateReason)updateReason {
    [store sdl_setObject:updateReason forName:SDLNameUpdateReason];
}

- (nullable SDLServiceUpdateReason)updateReason {
    return [store sdl_objectForName:SDLNameUpdateReason];
}

- (void)setUpdatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord {
    [store sdl_setObject:updatedAppServiceRecord forName:SDLNameUpdatedAppServiceRecord];
}

- (SDLAppServiceRecord *)updatedAppServiceRecord {
    return [store sdl_objectForName:SDLNameUpdatedAppServiceRecord ofClass:SDLAppServiceRecord.class];
}

@end

NS_ASSUME_NONNULL_END
