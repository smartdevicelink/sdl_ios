//
//  SDLPhoneCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLPhoneCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

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
    [self.store sdl_setObject:dialNumberEnabled forName:SDLRPCParameterNameDialNumberEnabled];
}

- (nullable NSNumber *)dialNumberEnabled {
    return [self.store sdl_objectForName:SDLRPCParameterNameDialNumberEnabled ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
