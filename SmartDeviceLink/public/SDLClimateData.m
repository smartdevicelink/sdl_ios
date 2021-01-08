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

#import "NSMutableDictionary+Store.h"
#import "SDLClimateData.h"
#import "SDLRPCParameterNames.h"
#import "SDLTemperature.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SDLClimateData

- (instancetype)initWithExternalTemperature:(nullable SDLTemperature *)externalTemperature cabinTemperature:(nullable SDLTemperature *)cabinTemperature atmosphericPressure:(nullable NSNumber<SDLFloat> *)atmosphericPressure {
    self = [self init];
    if (self) {
        self.externalTemperature = externalTemperature;
        self.cabinTemperature = cabinTemperature;
        self.atmosphericPressure = atmosphericPressure;
    }
    return self;
}

- (void)setExternalTemperature:(nullable SDLTemperature *)externalTemperature {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.store sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
#pragma clang diagnostic pop
}

- (nullable SDLTemperature *)externalTemperature {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self.store sdl_objectForName:SDLRPCParameterNameExternalTemperature ofClass:SDLTemperature.class error:nil];
#pragma clang diagnostic pop
}

- (void)setCabinTemperature:(nullable SDLTemperature *)cabinTemperature {
    [self.store sdl_setObject:cabinTemperature forName:SDLRPCParameterNameCabinTemperature];
}

- (nullable SDLTemperature *)cabinTemperature {
    return [self.store sdl_objectForName:SDLRPCParameterNameCabinTemperature ofClass:SDLTemperature.class error:nil];
}

- (void)setAtmosphericPressure:(nullable NSNumber<SDLFloat> *)atmosphericPressure {
    [self.store sdl_setObject:atmosphericPressure forName:SDLRPCParameterNameAtmosphericPressure];
}

- (nullable NSNumber<SDLFloat> *)atmosphericPressure {
    return [self.store sdl_objectForName:SDLRPCParameterNameAtmosphericPressure ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
