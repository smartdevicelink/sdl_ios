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

#import "SDLFileType.h"
#import "SDLImageFieldName.h"

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

/**
 A struct used in DisplayCapabilities describing the capability of an image field
 */
@interface SDLImageField : SDLRPCStruct

/**
 * @param nameParam - nameParam
 * @param imageTypeSupported - imageTypeSupported
 * @return A SDLImageField object
 */
- (instancetype)initWithNameParam:(SDLImageFieldName)nameParam imageTypeSupported:(NSArray<SDLFileType> *)imageTypeSupported;

/**
 * @param nameParam - nameParam
 * @param imageTypeSupported - imageTypeSupported
 * @param imageResolution - imageResolution
 * @return A SDLImageField object
 */
- (instancetype)initWithNameParam:(SDLImageFieldName)nameParam imageTypeSupported:(NSArray<SDLFileType> *)imageTypeSupported imageResolution:(nullable SDLImageResolution *)imageResolution;

/// Convenience initalizer for the ImageField RPC struct
/// @param name The name identifying this image field
/// @param imageTypeSupported The image data types this field supports
/// @param imageResolution The native resolution of this image field
- (instancetype)initWithName:(SDLImageFieldName)name imageTypeSupported:(NSArray<SDLFileType> *)imageTypeSupported imageResolution:(nullable SDLImageResolution *)imageResolution __deprecated_msg("Use initWithNameParam:imageTypeSupported:imageResolution: instead");

/**
 * The name that identifies the field. See ImageFieldName.
 */
@property (strong, nonatomic) SDLImageFieldName nameParam;

/**
 The name that identifies the field.

 Required
 */
@property (strong, nonatomic) SDLImageFieldName name __deprecated_msg("Use nameParam instead");

/**
 The image types that are supported in this field.

 Required
 */
@property (strong, nonatomic) NSArray<SDLFileType> *imageTypeSupported;

/**
 The image resolution of this field

 Optional
 */
@property (nullable, strong, nonatomic) SDLImageResolution *imageResolution;

@end

NS_ASSUME_NONNULL_END
