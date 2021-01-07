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

#import "SDLWarningLightStatus.h"

@class SDLSingleTireStatus;

NS_ASSUME_NONNULL_BEGIN

/**
 Struct used in Vehicle Data; the status and pressure of the tires.

 @added in SmartDeviceLink 2.0.0
 */
@interface SDLTireStatus : SDLRPCStruct

/**
 * @param pressureTelltale - pressureTelltale
 * @param leftFront - leftFront
 * @param rightFront - rightFront
 * @param leftRear - leftRear
 * @param rightRear - rightRear
 * @param innerLeftRear - innerLeftRear
 * @param innerRightRear - innerRightRear
 * @return A SDLTireStatus object
 */
- (instancetype)initWithPressureTelltale:(SDLWarningLightStatus)pressureTelltale leftFront:(SDLSingleTireStatus *)leftFront rightFront:(SDLSingleTireStatus *)rightFront leftRear:(SDLSingleTireStatus *)leftRear rightRear:(SDLSingleTireStatus *)rightRear innerLeftRear:(SDLSingleTireStatus *)innerLeftRear innerRightRear:(SDLSingleTireStatus *)innerRightRear;

/**
 Status of the Tire Pressure Telltale. See WarningLightStatus.

 Required
 */
@property (strong, nonatomic) SDLWarningLightStatus pressureTelltale;

/**
 The status of the left front tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *leftFront;

/**
 The status of the right front tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *rightFront;

/**
 The status of the left rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *leftRear;

/**
 The status of the right rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *rightRear;

/**
 The status of the inner left rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *innerLeftRear;

/**
 The status of the innter right rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *innerRightRear;

@end

NS_ASSUME_NONNULL_END
