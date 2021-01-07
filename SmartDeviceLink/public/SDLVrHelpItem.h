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

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

/**
 A help item for voice commands, used locally in interaction lists and globally

 @added in SmartDeviceLink 2.0.0
 */
@interface SDLVRHelpItem : SDLRPCStruct

/**
 * @param text - text
 * @param position - @(position)
 * @return A SDLVrHelpItem object
 */
- (instancetype)initWithText:(NSString *)text position:(UInt8)position;

/**
 * @param text - text
 * @param position - @(position)
 * @param image - image
 * @return A SDLVrHelpItem object
 */
- (instancetype)initWithText:(NSString *)text position:(UInt8)position image:(nullable SDLImage *)image;

/// Convenience init to create a VR help item with the following parameters
///
/// @param text Text to display for VR Help item
/// @param image Image for VR Help item
/// @return An SDLVRHelpItem object
- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image __deprecated_msg("Use initWithText:position:image: instead");

/// Convenience init to create a VR help item with all parameters
///
/// @param text Text to display for VR Help item
/// @param image Image for VR Help item
/// @param position  Position to display item in VR Help list
/// @return An SDLVRHelpItem object
- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image position:(UInt8)position __deprecated_msg("Use initWithText:position:image: instead");

/**
 Text to display for VR Help item

 Required
 */
@property (strong, nonatomic) NSString *text;

/**
 Image for VR Help item

 Optional
 */
@property (strong, nonatomic, nullable) SDLImage *image;

/**
 Position to display item in VR Help list

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *position;

@end

NS_ASSUME_NONNULL_END
