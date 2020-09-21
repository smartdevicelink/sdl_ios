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

#import "SDLHMICapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMICapabilities

- (instancetype)initWithNavigation:(nullable NSNumber<SDLBool> *)navigation phoneCall:(nullable NSNumber<SDLBool> *)phoneCall videoStreaming:(nullable NSNumber<SDLBool> *)videoStreaming remoteControl:(nullable NSNumber<SDLBool> *)remoteControl appServices:(nullable NSNumber<SDLBool> *)appServices displays:(nullable NSNumber<SDLBool> *)displays seatLocation:(nullable NSNumber<SDLBool> *)seatLocation driverDistraction:(nullable NSNumber<SDLBool> *)driverDistraction {
    self = [super init];
    if (!self) { return nil; }

    self.navigation = navigation;
    self.phoneCall = phoneCall;
    self.videoStreaming = videoStreaming;
    self.remoteControl = remoteControl;
    self.appServices = appServices;
    self.displays = displays;
    self.seatLocation = seatLocation;
    self.driverDistraction = driverDistraction;

    return self;
}

- (void)setNavigation:(nullable NSNumber<SDLBool> *)navigation {
    [self.store sdl_setObject:navigation forName:SDLRPCParameterNameNavigation];
}

- (nullable NSNumber<SDLBool> *)navigation {
    return [self.store sdl_objectForName:SDLRPCParameterNameNavigation ofClass:NSNumber.class error:nil];
}

- (void)setPhoneCall:(nullable NSNumber<SDLBool> *)phoneCall {
    [self.store sdl_setObject:phoneCall forName:SDLRPCParameterNamePhoneCall];
}

- (nullable NSNumber<SDLBool> *)phoneCall {
    return [self.store sdl_objectForName:SDLRPCParameterNamePhoneCall ofClass:NSNumber.class error:nil];
}

- (void)setVideoStreaming:(nullable NSNumber<SDLBool> *)videoStreaming {
    [self.store sdl_setObject:videoStreaming forName:SDLRPCParameterNameVideoStreaming];
}

- (nullable NSNumber<SDLBool> *)videoStreaming {
    return [self.store sdl_objectForName:SDLRPCParameterNameVideoStreaming ofClass:NSNumber.class error:nil];
}

- (void)setRemoteControl:(nullable NSNumber<SDLBool> *)remoteControl {
    [self.store sdl_setObject:remoteControl forName:SDLRPCParameterNameRemoteControl];
}

- (nullable NSNumber<SDLBool> *)remoteControl {
    return [self.store sdl_objectForName:SDLRPCParameterNameRemoteControl ofClass:NSNumber.class error:nil];
}

- (void)setAppServices:(nullable NSNumber<SDLBool> *)appServices {
    [self.store sdl_setObject:appServices forName:SDLRPCParameterNameAppServices];
}

- (nullable NSNumber<SDLBool> *)appServices {
    return [self.store sdl_objectForName:SDLRPCParameterNameAppServices ofClass:NSNumber.class error:nil];
}

- (void)setDisplays:(nullable NSNumber<SDLBool> *)displays {
    [self.store sdl_setObject:displays forName:SDLRPCParameterNameDisplays];
}

- (nullable NSNumber<SDLBool> *)displays {
    return [self.store sdl_objectForName:SDLRPCParameterNameDisplays ofClass:NSNumber.class error:nil];
}

- (void)setSeatLocation:(nullable NSNumber<SDLBool> *)seatLocation {
    [self.store sdl_setObject:seatLocation forName:SDLRPCParameterNameSeatLocation];
}

- (nullable NSNumber<SDLBool> *)seatLocation {
    return [self.store sdl_objectForName:SDLRPCParameterNameSeatLocation ofClass:NSNumber.class error:nil];
}

- (void)setDriverDistraction:(nullable NSNumber<SDLBool> *)driverDistraction {
    [self.store sdl_setObject:driverDistraction forName:SDLRPCParameterNameDriverDistraction];
}

- (nullable NSNumber<SDLBool> *)driverDistraction {
    return [self.store sdl_objectForName:SDLRPCParameterNameDriverDistraction ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
