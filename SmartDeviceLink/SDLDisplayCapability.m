//
//  SDLDisplayCapability.m
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 16.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLDisplayCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLWindowTypeCapabilities.h"
#import "SDLWindowCapability.m"



@implementation SDLDisplayCapability

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [self init];
    if (!self) {
        return nil;
    }
    return self;
}
#pragma clang diagnostic pop



- (void)setDisplayName:(NSString *)displayName {
    [self.store sdl_setObject:displayName forName:SDLRPCParameterNameTimezoneMinuteOffset];
}

- (NSString *)displayName {
    return [self.store sdl_objectForName:SDLRPCParameterNameTimezoneMinuteOffset ofClass:NSString.class error:nil];
}


- (void)setWindowTypeSupported:(nullable SDLWindowTypeCapabilities *)windowTypeSupported {
    [self.store sdl_setObject:windowTypeSupported forName:SDLRPCParameterNameWindowTypeSupported];
}

- (nullable SDLWindowTypeCapabilities *)windowTypeSupported {
    return [self.store sdl_objectForName:SDLRPCParameterNameWindowTypeSupported ofClass:SDLWindowTypeCapabilities.class error:nil];
}

- (void)setWindowCapabilities:(nullable SDLWindowCapability *)windowCapabilities {
    [self.store sdl_setObject:windowCapabilities forName:SDLRPCParameterNameWindowCapabilities];
}

- (nullable SDLWindowCapability *)windowCapabilities {
    return [self.store sdl_objectForName:SDLRPCParameterNameWindowCapabilities ofClass:SDLWindowCapability.class error:nil];
}


@end
