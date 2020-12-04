//
//  SDLOpenMenu.m
//  SmartDeviceLink
//
//  Created by Justin Gluck on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLShowAppMenu.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLShowAppMenu

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameShowAppMenu]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithMenuID:(UInt32)menuID {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuID = @(menuID);
    return self;
}

- (void)setMenuID:(nullable NSNumber<SDLInt> *)menuID {
    [self.parameters sdl_setObject:menuID forName:SDLRPCParameterNameMenuID];
}

- (nullable NSNumber<SDLInt> *)menuID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuID ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
