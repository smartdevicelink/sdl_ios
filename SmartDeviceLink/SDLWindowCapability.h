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

#import "SDLRPCStruct.h"

#import "SDLImageType.h"
#import "SDLMenuLayout.h"

@class SDLButtonCapabilities;
@class SDLDynamicUpdateCapabilities;
@class SDLImageField;
@class SDLSoftButtonCapabilities;
@class SDLTextField;


NS_ASSUME_NONNULL_BEGIN

/**
 Reflects content of DisplayCapabilities, ButtonCapabilities and SoftButtonCapabilities
 
 @since SDL 6.0
 */
@interface SDLWindowCapability : SDLRPCStruct

/**
 * @param windowID - windowID
 * @param textFields - textFields
 * @param imageFields - imageFields
 * @param imageTypeSupported - imageTypeSupported
 * @param templatesAvailable - templatesAvailable
 * @param numCustomPresetsAvailable - numCustomPresetsAvailable
 * @param buttonCapabilities - buttonCapabilities
 * @param softButtonCapabilities - softButtonCapabilities
 * @param menuLayoutsAvailable - menuLayoutsAvailable
 * @param dynamicUpdateCapabilities - dynamicUpdateCapabilities
 * @return A SDLWindowCapability object
 */
- (instancetype)initWithWindowID:(nullable NSNumber<SDLInt> *)windowID textFields:(nullable NSArray<SDLTextField *> *)textFields imageFields:(nullable NSArray<SDLImageField *> *)imageFields imageTypeSupported:(nullable NSArray<SDLImageType> *)imageTypeSupported templatesAvailable:(nullable NSArray<NSString *> *)templatesAvailable numCustomPresetsAvailable:(nullable NSNumber<SDLUInt> *)numCustomPresetsAvailable buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities softButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities menuLayoutsAvailable:(nullable NSArray<SDLMenuLayout> *)menuLayoutsAvailable dynamicUpdateCapabilities:(nullable SDLDynamicUpdateCapabilities *)dynamicUpdateCapabilities;

/**
 The specified ID of the window. Can be set to a predefined window, or omitted for the main window on the main display.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *windowID;

/**
 A set of all fields that support text data. @see TextField
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLTextField *> *textFields;

/**
 A set of all fields that support images. @see ImageField
 
 Size: min 0 max 1000
 */
@property (nullable, strong, nonatomic) NSArray<SDLImageField *> *imageFields;

/**
 Provides information about image types supported by the system.
 
 Size: min 0 max 1000
 */
@property (nullable, strong, nonatomic) NSArray<SDLImageType> *imageTypeSupported;

/**
 A set of all window templates available on the head unit.
 
 Size: min 0 max 100
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *templatesAvailable;

/**
 The number of on-window custom presets available (if any); otherwise omitted.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *numCustomPresetsAvailable;

/**
 The number of buttons and the capabilities of each on-window button.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 The number of soft buttons available on-window and the capabilities for each button.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;

/**
 An array of available menu layouts. If this parameter is not provided, only the `LIST` layout is assumed to be available.

 Optional, array of 1 to 100, see SDLMenuLayout
 */
@property (nullable, strong, nonatomic) NSArray<SDLMenuLayout> *menuLayoutsAvailable;

/**
 * Contains the head unit's capabilities for dynamic updating features declaring if the module will send dynamic update RPCs.
 *
 * @since SDL 7.0.0
 */
@property (nullable, strong, nonatomic) SDLDynamicUpdateCapabilities *dynamicUpdateCapabilities;

@end

NS_ASSUME_NONNULL_END
