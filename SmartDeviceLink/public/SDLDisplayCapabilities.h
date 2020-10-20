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

#import "SDLRPCMessage.h"

#import "SDLDisplayType.h"
#import "SDLMediaClockFormat.h"

@class SDLImageField;
@class SDLScreenParams;
@class SDLTextField;

/**
 * Contains information about the display for the SDL system to which the application is currently connected.
 * 
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDisplayCapabilities : SDLRPCStruct

/**
 * @param textFields - textFields
 * @param mediaClockFormats - mediaClockFormats
 * @param graphicSupported - @(graphicSupported)
 * @return A SDLDisplayCapabilities object
 */
- (instancetype)initWithTextFields:(NSArray<SDLTextField *> *)textFields mediaClockFormats:(NSArray<SDLMediaClockFormat> *)mediaClockFormats graphicSupported:(BOOL)graphicSupported;

/**
 * @param textFields - textFields
 * @param mediaClockFormats - mediaClockFormats
 * @param graphicSupported - @(graphicSupported)
 * @param displayName - displayName
 * @param imageFields - imageFields
 * @param templatesAvailable - templatesAvailable
 * @param screenParams - screenParams
 * @param numCustomPresetsAvailable - numCustomPresetsAvailable
 * @return A SDLDisplayCapabilities object
 */
- (instancetype)initWithTextFields:(NSArray<SDLTextField *> *)textFields mediaClockFormats:(NSArray<SDLMediaClockFormat> *)mediaClockFormats graphicSupported:(BOOL)graphicSupported displayName:(nullable NSString *)displayName imageFields:(nullable NSArray<SDLImageField *> *)imageFields templatesAvailable:(nullable NSArray<NSString *> *)templatesAvailable screenParams:(nullable SDLScreenParams *)screenParams numCustomPresetsAvailable:(nullable NSNumber<SDLUInt> *)numCustomPresetsAvailable;

/**
 * The type of display
 *
 * Required
 */
@property (strong, nonatomic) SDLDisplayType displayType __deprecated_msg("See `displayName` instead");

/**
 The name of the connected display

 Optional
 */
@property (strong, nonatomic, nullable) NSString *displayName;

/**
 * An array of SDLTextField structures, each of which describes a field in the HMI which the application can write to using operations such as *SDLShow*, *SDLSetMediaClockTimer*, etc.
 *
 * @discussion This array of SDLTextField structures identify all the text fields to which the application can write on the current display (identified by SDLDisplayType).
 *
 * @see SDLTextField
 *
 * Required, Array of SDLTextField, 1 - 100 objects
 */
@property (strong, nonatomic) NSArray<SDLTextField *> *textFields;

/**
 * An array of SDLImageField elements
 *
 * @discussion A set of all fields that support images.
 *
 * @see SDLImageField
 *
 * Optional, Array of SDLImageField, 1 - 100 objects
 */
@property (nullable, strong, nonatomic) NSArray<SDLImageField *> *imageFields;

/**
 * An array of SDLMediaClockFormat elements, defining the valid string formats used in specifying the contents of the media clock field
 *
 * @see SDLMediaClockFormat
 *
 * Required, Array of SDLMediaClockFormats, 0 - 100 objects
 */
@property (strong, nonatomic) NSArray<SDLMediaClockFormat> *mediaClockFormats;

/**
 * The display's persistent screen supports.
 * 
 * @since SDL 2.0
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *graphicSupported;

/**
 * An array of all predefined persistent display templates available on the head unit.
 *
 * Optional, Array of String, max string size 100, 0 - 100 objects, since SDL 3.0
 *
 * See SDLPredefinedLayout
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *templatesAvailable;

/**
 * A set of all parameters related to a prescribed screen area (e.g. for video / touch input)
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLScreenParams *screenParams;

/**
 * The number of on-screen custom presets available (if any); otherwise omitted
 *
 * Optional, Integer 1 - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *numCustomPresetsAvailable;

@end

NS_ASSUME_NONNULL_END
