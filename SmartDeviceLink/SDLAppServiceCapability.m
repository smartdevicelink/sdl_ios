//
//  SDLAppServiceCapability.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAppServiceRecord.h"
#import "SDLRPCParameterNames.h"
#import "SDLServiceUpdateReason.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceCapability

- (instancetype)initWithUpdatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord {
    self = [super init];
    if (!self) {
        return self;
    }

    self.updatedAppServiceRecord = updatedAppServiceRecord;

    return self;
}

- (instancetype)initWithUpdateReason:(nullable SDLServiceUpdateReason)updateReason updatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord {
    self = [self initWithUpdatedAppServiceRecord:updatedAppServiceRecord];
    if (!self) {
        return self;
    }

    self.updateReason = updateReason;

    return self;
}

- (void)setUpdateReason:(nullable SDLServiceUpdateReason)updateReason {
    [self.store sdl_setObject:updateReason forName:SDLRPCParameterNameUpdateReason];
}

- (nullable SDLServiceUpdateReason)updateReason {
    return [self.store sdl_enumForName:SDLRPCParameterNameUpdateReason error:nil];
}

- (void)setUpdatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord {
    [self.store sdl_setObject:updatedAppServiceRecord forName:SDLRPCParameterNameUpdatedAppServiceRecord];
}

- (SDLAppServiceRecord *)updatedAppServiceRecord {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameUpdatedAppServiceRecord ofClass:SDLAppServiceRecord.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
