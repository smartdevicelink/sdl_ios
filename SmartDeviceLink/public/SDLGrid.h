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

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes a location (origin coordinates and span) of a vehicle component.
 */
@interface SDLGrid : SDLRPCStruct

/**
 * @param col - @(col)
 * @param row - @(row)
 * @return A SDLGrid object
 */
- (instancetype)initWithCol:(UInt8)col row:(UInt8)row;

/**
 * @param col - @(col)
 * @param row - @(row)
 * @param level - level
 * @param colspan - colspan
 * @param rowspan - rowspan
 * @param levelspan - levelspan
 * @return A SDLGrid object
 */
- (instancetype)initWithCol:(UInt8)col row:(UInt8)row level:(nullable NSNumber<SDLInt> *)level colspan:(nullable NSNumber<SDLUInt> *)colspan rowspan:(nullable NSNumber<SDLUInt> *)rowspan levelspan:(nullable NSNumber<SDLUInt> *)levelspan;

/**
 *
 * Required, Integer, -1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *col;

/**
 *
 * Required, Integer, -1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *row;

/**
 *
 * Optional, Integer, -1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *level;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *colspan;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *rowspan;

/**
 *
 * Optional, Integer, 1 - 100
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *levelspan;

@end

NS_ASSUME_NONNULL_END
