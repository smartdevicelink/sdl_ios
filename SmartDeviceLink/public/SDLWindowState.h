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

NS_ASSUME_NONNULL_BEGIN

/**
 * @since SDL 7.0.0
 */
@interface SDLWindowState : SDLRPCStruct

/**
 * @param approximatePosition - The approximate percentage that the window is open - 0 being fully closed, 100 being fully open
 * @param deviation - The percentage deviation of the approximatePosition. e.g. If the approximatePosition is 50 and the deviation is 10, then the window's location is somewhere between 40 and 60.
 * @return A SDLWindowState object
 */
- (instancetype)initWithApproximatePosition:(UInt8)approximatePosition deviation:(UInt8)deviation;

/**
 * The approximate percentage that the window is open - 0 being fully closed, 100 being fully open
 *
 *  Mandatory, Integer, 0 - 100
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *approximatePosition;

/**
 * The percentage deviation of the approximatePosition. e.g. If the approximatePosition is 50 and the deviation is 10, then the window's location is somewhere between 40 and 60.
 *
 *  Mandatory, Integer, 0 - 100
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *deviation;

@end

NS_ASSUME_NONNULL_END
