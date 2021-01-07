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
#import "SDLMetadataType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @added in SmartDeviceLink 4.5.0
 */
@interface SDLMetadataTags : SDLRPCStruct

/**
 * @param mainField1 - mainField1
 * @param mainField2 - mainField2
 * @param mainField3 - mainField3
 * @param mainField4 - mainField4
 * @return A SDLMetadataTags object
 */
- (instancetype)initWithMainField1:(nullable NSArray<SDLMetadataType> *)mainField1 mainField2:(nullable NSArray<SDLMetadataType> *)mainField2 mainField3:(nullable NSArray<SDLMetadataType> *)mainField3 mainField4:(nullable NSArray<SDLMetadataType> *)mainField4;

/**
 Constructs a newly allocated SDLMetadataType object with NSArrays
 */
- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLMetadataType> *)mainField1 mainField2:(nullable NSArray<SDLMetadataType> *)mainField2 __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4: instead");

/// Constructs a newly allocated SDLMetadataType with all parameters
- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLMetadataType> *)mainField1 mainField2:(nullable NSArray<SDLMetadataType> *)mainField2 mainField3:(nullable NSArray<SDLMetadataType> *)mainField3 mainField4:(nullable NSArray<SDLMetadataType> *)mainField4 __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4: instead");

/**
 The type of data contained in the "mainField1" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField1;

/**
 The type of data contained in the "mainField2" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField2;

/**
 The type of data contained in the "mainField3" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField3;

/**
 The type of data contained in the "mainField4" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField4;

@end

NS_ASSUME_NONNULL_END
