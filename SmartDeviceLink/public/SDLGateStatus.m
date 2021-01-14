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
#import "SDLDoorStatusType.h"
#import "SDLGateStatus.h"
#import "SDLGrid.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SDLGateStatus

- (instancetype)initWithLocation:(SDLGrid *)location status:(SDLDoorStatusType)status {
    self = [self init];
    if (self) {
        self.location = location;
        self.status = status;
    }
    return self;
}

- (void)setLocation:(SDLGrid *)location {
    [self.store sdl_setObject:location forName:SDLRPCParameterNameLocation];
}

- (SDLGrid *)location {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLocation ofClass:SDLGrid.class error:&error];
}

- (void)setStatus:(SDLDoorStatusType)status {
    [self.store sdl_setObject:status forName:SDLRPCParameterNameStatus];
}

- (SDLDoorStatusType)status {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameStatus error:&error];
}

@end

NS_ASSUME_NONNULL_END
