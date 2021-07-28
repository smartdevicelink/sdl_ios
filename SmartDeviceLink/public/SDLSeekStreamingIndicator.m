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
#import "SDLRPCParameterNames.h"
#import "SDLSeekIndicatorType.h"
#import "SDLSeekStreamingIndicator.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SDLSeekStreamingIndicator

- (instancetype)initWithType:(SDLSeekIndicatorType)type {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.type = type;
    return self;
}

- (instancetype)initWithType:(SDLSeekIndicatorType)type seekTime:(nullable NSNumber<SDLUInt> *)seekTime {
    self = [self initWithType:type];
    if (!self) {
        return nil;
    }
    self.seekTime = seekTime;
    return self;
}

+ (instancetype)seekIndicatorWithSeekTime:(NSUInteger)seekTime {
    return [[self alloc] initWithType:SDLSeekIndicatorTypeTime seekTime:@(seekTime)];
}

- (void)setType:(SDLSeekIndicatorType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (SDLSeekIndicatorType)type {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameType error:&error];
}

- (void)setSeekTime:(nullable NSNumber<SDLUInt> *)seekTime {
    [self.store sdl_setObject:seekTime forName:SDLRPCParameterNameSeekTime];
}

- (nullable NSNumber<SDLUInt> *)seekTime {
    return [self.store sdl_objectForName:SDLRPCParameterNameSeekTime ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
