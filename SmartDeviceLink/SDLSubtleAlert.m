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

#import "SDLSubtleAlert.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSubtleAlert

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameSubtleAlert];
    if (!self) {
        return nil;
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertIcon:(nullable SDLImage *)alertIcon ttsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks duration:(nullable NSNumber<SDLUInt> *)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons cancelID:(nullable NSNumber<SDLInt> *)cancelID {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.alertText1 = alertText1;
    self.alertText2 = alertText2;
    self.alertIcon = alertIcon;
    self.ttsChunks = ttsChunks;
    self.duration = duration;
    self.softButtons = softButtons;
    self.cancelID = cancelID;
    return self;
}

- (void)setAlertText1:(nullable NSString *)alertText1 {
    [self.parameters sdl_setObject:alertText1 forName:SDLRPCParameterNameAlertText1];
}

- (nullable NSString *)alertText1 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAlertText1 ofClass:NSString.class error:nil];
}

- (void)setAlertText2:(nullable NSString *)alertText2 {
    [self.parameters sdl_setObject:alertText2 forName:SDLRPCParameterNameAlertText2];
}

- (nullable NSString *)alertText2 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAlertText2 ofClass:NSString.class error:nil];
}

- (void)setAlertIcon:(nullable SDLImage *)alertIcon {
    [self.parameters sdl_setObject:alertIcon forName:SDLRPCParameterNameAlertIcon];
}

- (nullable SDLImage *)alertIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAlertIcon ofClass:SDLImage.class error:nil];
}

- (void)setTtsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    [self.parameters sdl_setObject:ttsChunks forName:SDLRPCParameterNameTTSChunks];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTTSChunks ofClass:SDLTTSChunk.class error:nil];
}

- (void)setDuration:(nullable NSNumber<SDLUInt> *)duration {
    [self.parameters sdl_setObject:duration forName:SDLRPCParameterNameDuration];
}

- (nullable NSNumber<SDLUInt> *)duration {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDuration ofClass:NSNumber.class error:nil];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [self.parameters sdl_setObject:softButtons forName:SDLRPCParameterNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameSoftButtons ofClass:SDLSoftButton.class error:nil];
}

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
