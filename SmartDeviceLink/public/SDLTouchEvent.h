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

@class SDLTouchCoord;

NS_ASSUME_NONNULL_BEGIN

/**
 A touch which occurred on the IVI system during projection

 @added in SmartDeviceLink 3.0.0
 */
@interface SDLTouchEvent : SDLRPCStruct

/**
 * @param idParam - @(idParam)
 * @param ts - ts
 * @param c - c
 * @return A SDLTouchEvent object
 */
- (instancetype)initWithIdParam:(UInt8)idParam ts:(NSArray<NSNumber<SDLUInt> *> *)ts c:(NSArray<SDLTouchCoord *> *)c;

/**
 * A touch's unique identifier. The application can track the current touch events by id. If a touch event has type begin, the id should be added to the set of touches. If a touch event has type end, the id should be removed from the set of touches.
 * {"num_min_value": 0, "num_max_value": 9}
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *idParam;

/**
 A touch's unique identifier.  The application can track the current touch events by id.

 If a touch event has type begin, the id should be added to the set of touches.

 If a touch event has type end, the id should be removed from the set of touches.
 
 Required, 0-9
 */
@property (strong, nonatomic) NSNumber<SDLInt> *touchEventId __deprecated_msg("Use idParam instead");

/**
 The time that the touch was recorded. This number can the time since the beginning of the session or something else as long as the units are in milliseconds.
 
 The timestamp is used to determined the rate of change of position of a touch.
 
 The application also uses the time to verify whether two touches, with different ids, are part of a single action by the user.
 
 If there is only a single timestamp in this array, it is the same for every coordinate in the coordinates array.
 
 Required, array size 1-1000, contains integer value 0-2000000000
 */
@property (strong, nonatomic) NSArray<NSNumber *> *timeStamp;

/**
 The touch's coordinate

 Required, array size 1-1000
 */
@property (strong, nonatomic) NSArray<SDLTouchCoord *> *coord;

@end

NS_ASSUME_NONNULL_END
