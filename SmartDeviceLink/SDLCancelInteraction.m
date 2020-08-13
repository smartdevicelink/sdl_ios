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

#import "SDLCancelInteraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLFunctionID.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLCancelInteraction

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCancelInteraction]) {
    }
    return self;
}
#pragma clang diagnostic pop


- (instancetype)initWithFunctionID:(UInt32)functionID {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.functionID = @(functionID);

    return self;
}

- (instancetype)initWithFunctionID:(UInt32)functionID cancelID:(UInt32)cancelID {
    self = [self initWithFunctionID:functionID];
    if (!self) {
        return nil;
    }

    self.cancelID = @(cancelID);

    return self;
}

- (instancetype)initWithAlertCancelID:(UInt32)cancelID {
    return [self initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameAlert].unsignedIntValue cancelID:cancelID];
}

- (instancetype)initWithSliderCancelID:(UInt32)cancelID {
    return [self initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameSlider].unsignedIntValue cancelID:cancelID];
}

- (instancetype)initWithScrollableMessageCancelID:(UInt32)cancelID {
    return [self initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameScrollableMessage].unsignedIntValue cancelID:cancelID];
}

- (instancetype)initWithPerformInteractionCancelID:(UInt32)cancelID {
    return [self initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNamePerformInteraction].unsignedIntValue cancelID:cancelID];
}

- (instancetype)initWithSubtleAlertCancelID:(UInt32)cancelID {
    return [self initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameSubtleAlert].unsignedIntValue cancelID:cancelID];
}

+ (instancetype)alert {
    return [[self alloc] initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameAlert].unsignedIntValue];
}

+ (instancetype)slider {
    return [[self alloc] initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameSlider].unsignedIntValue];
}

+ (instancetype)scrollableMessage {
    return [[self alloc] initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameScrollableMessage].unsignedIntValue];
}

+ (instancetype)performInteraction {
    return [[self alloc] initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNamePerformInteraction].unsignedIntValue];
}

+ (instancetype)subtleAlert {
    return [[self alloc] initWithFunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameSubtleAlert].unsignedIntValue];
}

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

- (void)setFunctionID:(NSNumber<SDLInt> *)functionID {
    [self.parameters sdl_setObject:functionID forName:SDLRPCParameterNameFunctionID];
}

- (NSNumber<SDLInt> *)functionID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFunctionID ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
