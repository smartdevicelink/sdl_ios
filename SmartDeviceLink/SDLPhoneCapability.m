//
//  SDLPhoneCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLPhoneCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPhoneCapability

- (instancetype)initWithDialNumber:(BOOL)dialNumberEnabled {
    self = [self init];
    if (!self) {
        return self;
    }

    self.dialNumberEnabled = @(dialNumberEnabled);

    return self;
}

- (void)setDialNumberEnabled:(nullable NSNumber *)dialNumberEnabled {
    [store sdl_setObject:dialNumberEnabled forName:SDLNameDialNumberEnabled];
}

- (nullable NSNumber *)dialNumberEnabled {
    return [store sdl_objectForName:SDLNameDialNumberEnabled];
}

@end

NS_ASSUME_NONNULL_END
