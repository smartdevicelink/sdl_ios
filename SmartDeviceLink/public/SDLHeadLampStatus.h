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

#import "SDLAmbientLightStatus.h"


NS_ASSUME_NONNULL_BEGIN

/**
 Vehicle data struct for status of head lamps
 */
@interface SDLHeadLampStatus : SDLRPCStruct

/**
 * @param lowBeamsOn - @(lowBeamsOn)
 * @param highBeamsOn - @(highBeamsOn)
 * @return A SDLHeadLampStatus object
 */
- (instancetype)initWithLowBeamsOn:(BOOL)lowBeamsOn highBeamsOn:(BOOL)highBeamsOn;

/**
 * @param lowBeamsOn - @(lowBeamsOn)
 * @param highBeamsOn - @(highBeamsOn)
 * @param ambientLightSensorStatus - ambientLightSensorStatus
 * @return A SDLHeadLampStatus object
 */
- (instancetype)initWithLowBeamsOn:(BOOL)lowBeamsOn highBeamsOn:(BOOL)highBeamsOn ambientLightSensorStatus:(nullable SDLAmbientLightStatus)ambientLightSensorStatus;

/**
 Low beams are on or off.

 Required, boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *lowBeamsOn;
/**
 High beams are on or off

 Required, boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *highBeamsOn;

/**
 Status of the ambient light senser

 Optional
 */
@property (nullable, strong, nonatomic) SDLAmbientLightStatus ambientLightSensorStatus;

@end

NS_ASSUME_NONNULL_END
