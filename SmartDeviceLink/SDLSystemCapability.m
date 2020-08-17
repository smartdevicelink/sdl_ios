/*
* Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* Redistributions of source code must retain the above copyright notice, this
* list of conditions and the following disclaimer.
*
* Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following
* disclaimer in the documentation and/or other materials provided with the
* distribution.
*
* Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
* its contributors may be used to endorse or promote products derived
* from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

#import "SDLSystemCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAppServicesCapabilities.h"
#import "SDLDisplayCapability.h"
#import "SDLDriverDistractionCapability.h"
#import "SDLNavigationCapability.h"
#import "SDLPhoneCapability.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "SDLSeatLocationCapability.h"
#import "SDLSystemCapabilityType.h"
#import "SDLVideoStreamingCapability.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemCapability

- (instancetype)initWithAppServicesCapabilities:(SDLAppServicesCapabilities *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeAppServices;
    self.appServicesCapabilities = capability;

    return self;
}

- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypePhoneCall;
    self.phoneCapability = capability;

    return self;
}

- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeNavigation;
    self.navigationCapability = capability;

    return self;
}

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeVideoStreaming;
    self.videoStreamingCapability = capability;

    return self;
}

- (instancetype)initWithRemoteControlCapability:(SDLRemoteControlCapabilities *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeRemoteControl;
    self.remoteControlCapability = capability;

    return self;
}

- (instancetype)initWithDisplayCapabilities:(NSArray<SDLDisplayCapability *> *)capabilities {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.systemCapabilityType = SDLSystemCapabilityTypeDisplays;
    self.displayCapabilities = [capabilities copy];
    
    return self;
}
    
- (instancetype)initWithSeatLocationCapability:(SDLSeatLocationCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.systemCapabilityType = SDLSystemCapabilityTypeSeatLocation;
    self.seatLocationCapability = capability;
    
    return self;
}

- (instancetype)initWithDriverDistractionCapability:(SDLDriverDistractionCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeDriverDistraction;
    self.driverDistractionCapability = capability;

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameSystemCapabilityType];
}

- (SDLSystemCapabilityType)systemCapabilityType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameSystemCapabilityType error:&error];
}

- (void)setAppServicesCapabilities:(nullable SDLAppServicesCapabilities *)appServicesCapabilities {
    [self.store sdl_setObject:appServicesCapabilities forName:SDLRPCParameterNameAppServicesCapabilities];
}

- (nullable SDLAppServicesCapabilities *)appServicesCapabilities {
    return [self.store sdl_objectForName:SDLRPCParameterNameAppServicesCapabilities ofClass:SDLAppServicesCapabilities.class error:nil];
}

- (void)setNavigationCapability:(nullable SDLNavigationCapability *)navigationCapability {
    [self.store sdl_setObject:navigationCapability forName:SDLRPCParameterNameNavigationCapability];
}

- (nullable SDLNavigationCapability *)navigationCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameNavigationCapability ofClass:SDLNavigationCapability.class error:nil];
}

- (void)setPhoneCapability:(nullable SDLPhoneCapability *)phoneCapability {
    [self.store sdl_setObject:phoneCapability forName:SDLRPCParameterNamePhoneCapability];
}

- (nullable SDLPhoneCapability *)phoneCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNamePhoneCapability ofClass:SDLPhoneCapability.class error:nil];
}

- (void)setVideoStreamingCapability:(nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    [self.store sdl_setObject:videoStreamingCapability forName:SDLRPCParameterNameVideoStreamingCapability];
}

- (nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameVideoStreamingCapability ofClass:SDLVideoStreamingCapability.class error:nil];
}

- (void)setRemoteControlCapability:(nullable SDLRemoteControlCapabilities *)remoteControlCapability {
    [self.store sdl_setObject:remoteControlCapability forName:SDLRPCParameterNameRemoteControlCapability];
}

- (nullable SDLRemoteControlCapabilities *)remoteControlCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameRemoteControlCapability ofClass:SDLRemoteControlCapabilities.class error:nil];
}

- (void)setSeatLocationCapability:(nullable SDLSeatLocationCapability *)seatLocationCapability {
    [self.store sdl_setObject:seatLocationCapability forName:SDLRPCParameterNameSeatLocationCapability];
}

- (nullable SDLSeatLocationCapability *)seatLocationCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameSeatLocationCapability ofClass:SDLSeatLocationCapability.class error:nil];
}

- (void)setDisplayCapabilities:(nullable NSArray<SDLDisplayCapability *> *)displayCapabilities {
    [self.store sdl_setObject:displayCapabilities forName:SDLRPCParameterNameDisplayCapabilities];
}

- (nullable NSArray<SDLDisplayCapability *> *)displayCapabilities {
    return [self.store sdl_objectsForName:SDLRPCParameterNameDisplayCapabilities ofClass:SDLDisplayCapability.class error:nil];
}

- (void)setDriverDistractionCapability:(nullable SDLDriverDistractionCapability *)driverDistractionCapability {
    [self.store sdl_setObject:driverDistractionCapability forName:SDLRPCParameterNameDriverDistractionCapability];
}

- (nullable SDLDriverDistractionCapability *)driverDistractionCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameDriverDistractionCapability ofClass:SDLDriverDistractionCapability.class error:nil];
}

// for debugging only
- (NSString *)description {
    if ([self.systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeVideoStreaming]) {
        return [NSString stringWithFormat:@"<%@:%p>type:VIDEO_STREAMING {%@}", NSStringFromClass(self.class), self,
                self.videoStreamingCapability];
    }
    return [super description];
}

@end

NS_ASSUME_NONNULL_END
