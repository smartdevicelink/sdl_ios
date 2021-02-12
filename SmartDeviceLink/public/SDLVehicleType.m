/*
 * Copyright (c) 2021, SmartDeviceLink Consortium, Inc.
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
#import "SDLRPCParameterNames.h"
#import "SDLVehicleType.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SDLVehicleType

- (instancetype)initWithMake:(nullable NSString *)make model:(nullable NSString *)model modelYear:(nullable NSString *)modelYear trim:(nullable NSString *)trim {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.make = make;
    self.model = model;
    self.modelYear = modelYear;
    self.trim = trim;
    return self;
}

- (void)setMake:(nullable NSString *)make {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.store sdl_setObject:make forName:SDLRPCParameterNameMake];
#pragma clang diagnostic pop
}

- (nullable NSString *)make {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self.store sdl_objectForName:SDLRPCParameterNameMake ofClass:NSString.class error:nil];
#pragma clang diagnostic pop
}

- (void)setModel:(nullable NSString *)model {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.store sdl_setObject:model forName:SDLRPCParameterNameModel];
#pragma clang diagnostic pop
}

- (nullable NSString *)model {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self.store sdl_objectForName:SDLRPCParameterNameModel ofClass:NSString.class error:nil];
#pragma clang diagnostic pop
}

- (void)setModelYear:(nullable NSString *)modelYear {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.store sdl_setObject:modelYear forName:SDLRPCParameterNameModelYear];
#pragma clang diagnostic pop
}

- (nullable NSString *)modelYear {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self.store sdl_objectForName:SDLRPCParameterNameModelYear ofClass:NSString.class error:nil];
#pragma clang diagnostic pop
}

- (void)setTrim:(nullable NSString *)trim {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.store sdl_setObject:trim forName:SDLRPCParameterNameTrim];
#pragma clang diagnostic pop
}

- (nullable NSString *)trim {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self.store sdl_objectForName:SDLRPCParameterNameTrim ofClass:NSString.class error:nil];
#pragma clang diagnostic pop
}

@end

NS_ASSUME_NONNULL_END
