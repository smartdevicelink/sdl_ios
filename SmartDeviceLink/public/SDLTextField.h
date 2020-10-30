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

#import "SDLCharacterSet.h"
#import "SDLTextFieldName.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * Struct defining the characteristics of a displayed field on the HMI.
 *
 * @since SDL 1.0
 */
@interface SDLTextField : SDLRPCStruct

/**
 * @param nameParam - nameParam
 * @param characterSet - characterSet
 * @param width - @(width)
 * @param rows - @(rows)
 * @return A SDLTextField object
 */
- (instancetype)initWithNameParam:(SDLTextFieldName)nameParam characterSet:(SDLCharacterSet)characterSet width:(UInt16)width rows:(UInt8)rows;

/**
 * The name that identifies the field. See TextFieldName.
 */
@property (strong, nonatomic) SDLTextFieldName nameParam;

/**
 * The enumeration identifying the field.
 *
 * @see SDLTextFieldName
 *
 * Required
 */
@property (strong, nonatomic) SDLTextFieldName name __deprecated_msg("Use nameParam instead");

/**
 * The set of characters that are supported by this text field. All text is sent in UTF-8 format, but not all systems may support all of the characters expressed by UTF-8. All systems will support at least ASCII, but they may support more, either the LATIN-1 character set, or the full UTF-8 character set.
 */
@property (strong, nonatomic) SDLCharacterSet characterSet;

/**
 * The number of characters in one row of this field.
 * 
 * Required, Integer 1 - 500
 */
@property (strong, nonatomic) NSNumber<SDLInt> *width;

/**
 * The number of rows for this text field.
 * 
 * Required, Integer 1 - 8
 */
@property (strong, nonatomic) NSNumber<SDLInt> *rows;

/// Convenience initalizer for the TextField RPC struct
/// @param name The name identifying this text field
/// @param characterSet The character set of this text field
/// @param width The number of characters per row allowed in this text field
/// @param rows The number of rows allowed in this text field
- (instancetype)initWithName:(SDLTextFieldName)name characterSet:(SDLCharacterSet)characterSet width:(NSUInteger)width rows:(NSUInteger)rows;

@end

NS_ASSUME_NONNULL_END
