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
#import "SDLMassageCushion.h"
/**
 * The intensity or firmness of a cushion.
 */

NS_ASSUME_NONNULL_BEGIN
@interface SDLMassageCushionFirmness : SDLRPCStruct

/**
 * @param cushion - cushion
 * @param firmness - @(firmness)
 * @return A SDLMassageCushionFirmness object
 */
- (instancetype)initWithCushion:(SDLMassageCushion)cushion firmness:(UInt8)firmness;

/**
 Constructs a newly allocated SDLMassageCushionFirmness object with cushion and firmness

 @param cushion The cushion type for a multi-contour massage seat
 @param firmness The firmness value for the multi-contour massage seat, MinValue: 0 MaxValue: 100
 @return An instance of the SDLMassageCushionFirmness class
 */
- (instancetype)initWithMassageCushion:(SDLMassageCushion)cushion firmness:(UInt8)firmness __deprecated_msg("Use initWithCushion:firmness: instead");

/**
 * @abstract cushion of a multi-contour massage seat.
 *
 * @see SDLMassageCushion
 */
@property (strong, nonatomic) SDLMassageCushion cushion;

/**
 * @abstract zone of a multi-contour massage seat.
 *
 * Required, MinValue: 0 MaxValue: 100
 *
 */
@property (strong, nonatomic) NSNumber<SDLInt> *firmness;
@end

NS_ASSUME_NONNULL_END

