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
 * Describes the hour, minute and second values used to set the media clock.
 *
 * @since SDL 1.0
 */
@interface SDLStartTime : SDLRPCStruct

/**
 Create a time struct with a time interval (time in seconds). Fractions of the second will be eliminated and rounded down.

 @param timeInterval The time interval to transform into hours, minutes, seconds
 @return The object
 */
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 Create a time struct with hours, minutes, and seconds

 @param hours The number of hours
 @param minutes The number of minutes
 @param seconds The number of seconds
 @return The object
 */
- (instancetype)initWithHours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds;

/**
 * The hour of the media clock
 * 
 * Some display types only support a max value of 19. If out of range, it will be rejected.
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *hours;

/**
 * The minute of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *minutes;

/**
 * The second of the media clock
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *seconds;

@end

NS_ASSUME_NONNULL_END
