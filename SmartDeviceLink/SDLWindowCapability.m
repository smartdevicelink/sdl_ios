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

#import "SDLWindowCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLButtonCapabilities.h"
#import "SDLDynamicUpdateCapabilities.h"
#import "SDLImageField.h"
#import "SDLRPCParameterNames.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLTextField.h"

@implementation SDLWindowCapability

- (instancetype)initWithWindowID:(nullable NSNumber<SDLInt> *)windowID textFields:(nullable NSArray<SDLTextField *> *)textFields imageFields:(nullable NSArray<SDLImageField *> *)imageFields imageTypeSupported:(nullable NSArray<SDLImageType> *)imageTypeSupported templatesAvailable:(nullable NSArray<NSString *> *)templatesAvailable numCustomPresetsAvailable:(nullable NSNumber<SDLUInt> *)numCustomPresetsAvailable buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities softButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities menuLayoutsAvailable:(nullable NSArray<SDLMenuLayout> *)menuLayoutsAvailable dynamicUpdateCapabilities:(nullable SDLDynamicUpdateCapabilities *)dynamicUpdateCapabilities {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.windowID = windowID;
    self.textFields = textFields;
    self.imageFields = imageFields;
    self.imageTypeSupported = imageTypeSupported;
    self.templatesAvailable = templatesAvailable;
    self.numCustomPresetsAvailable = numCustomPresetsAvailable;
    self.buttonCapabilities = buttonCapabilities;
    self.softButtonCapabilities = softButtonCapabilities;
    self.menuLayoutsAvailable = menuLayoutsAvailable;
    self.dynamicUpdateCapabilities = dynamicUpdateCapabilities;
    return self;
}

- (void)setWindowID:(nullable NSNumber<SDLUInt> *)windowID {
    [self.store sdl_setObject:windowID forName:SDLRPCParameterNameWindowId];
}

- (nullable NSNumber<SDLUInt> *)windowID {
    return [self.store sdl_objectForName:SDLRPCParameterNameWindowId ofClass:NSNumber.class error:nil];
}

- (void)setTextFields:(nullable NSArray<SDLTextField *> *)textFields {
    [self.store sdl_setObject:textFields forName:SDLRPCParameterNameTextFields];
}

- (nullable NSArray<SDLTextField *> *)textFields {
    return [self.store sdl_objectsForName:SDLRPCParameterNameTextFields ofClass:SDLTextField.class error:nil];
}

- (void)setImageFields:(nullable NSArray<SDLImageField *> *)imageFields {
    [self.store sdl_setObject:imageFields forName:SDLRPCParameterNameImageFields];
}

- (nullable NSArray<SDLImageField *> *)imageFields {
    return [self.store sdl_objectsForName:SDLRPCParameterNameImageFields ofClass:SDLImageField.class error:nil];
}

- (void)setImageTypeSupported:(nullable NSArray<SDLImageType> *)imageTypeSupported {
    [self.store sdl_setObject:imageTypeSupported forName:SDLRPCParameterNameImageTypeSupported];
}

- (nullable NSArray<SDLImageType> *)imageTypeSupported {
    return [self.store sdl_enumsForName:SDLRPCParameterNameImageTypeSupported error:nil];
}

- (void)setTemplatesAvailable:(nullable NSArray<NSString *> *)templatesAvailable {
    [self.store sdl_setObject:templatesAvailable forName:SDLRPCParameterNameTemplatesAvailable];
}

- (nullable NSArray<NSString *> *)templatesAvailable {
    return [self.store sdl_objectsForName:SDLRPCParameterNameTemplatesAvailable ofClass:NSString.class error:nil];
}

- (void)setNumCustomPresetsAvailable:(nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    [self.store sdl_setObject:numCustomPresetsAvailable forName:SDLRPCParameterNameNumberCustomPresetsAvailable];
}

- (nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameNumberCustomPresetsAvailable ofClass:NSNumber.class error:nil];
}

- (void)setButtonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [self.store sdl_setObject:buttonCapabilities forName:SDLRPCParameterNameButtonCapabilities];
}

- (nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [self.store sdl_objectsForName:SDLRPCParameterNameButtonCapabilities ofClass:SDLButtonCapabilities.class error:nil];
}


- (void)setSoftButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [self.store sdl_setObject:softButtonCapabilities forName:SDLRPCParameterNameSoftButtonCapabilities];
}

- (nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    return [self.store sdl_objectsForName:SDLRPCParameterNameSoftButtonCapabilities ofClass:SDLSoftButtonCapabilities.class error:nil];
}

- (void)setMenuLayoutsAvailable:(nullable NSArray<SDLMenuLayout> *)menuLayoutsAvailable {
    [self.store sdl_setObject:menuLayoutsAvailable forName:SDLRPCParameterNameMenuLayoutsAvailable];
}

- (nullable NSArray<SDLMenuLayout> *)menuLayoutsAvailable {
    return [self.store sdl_enumsForName:SDLRPCParameterNameMenuLayoutsAvailable error:nil];
}

- (void)setDynamicUpdateCapabilities:(nullable SDLDynamicUpdateCapabilities *)dynamicUpdateCapabilities {
    [self.store sdl_setObject:dynamicUpdateCapabilities forName:SDLRPCParameterNameDynamicUpdateCapabilities];
}

- (nullable SDLDynamicUpdateCapabilities *)dynamicUpdateCapabilities {
    return [self.store sdl_objectForName:SDLRPCParameterNameDynamicUpdateCapabilities ofClass:SDLDynamicUpdateCapabilities.class error:nil];
}

@end
