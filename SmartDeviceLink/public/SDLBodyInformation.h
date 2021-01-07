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

#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"


/**
 * The body information including power modes.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLBodyInformation : SDLRPCStruct

/**
 * @param parkBrakeActive - @(parkBrakeActive)
 * @param ignitionStableStatus - ignitionStableStatus
 * @param ignitionStatus - ignitionStatus
 * @return A SDLBodyInformation object
 */
- (instancetype)initWithParkBrakeActive:(BOOL)parkBrakeActive ignitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus ignitionStatus:(SDLIgnitionStatus)ignitionStatus;

/**
 * @param parkBrakeActive - @(parkBrakeActive)
 * @param ignitionStableStatus - ignitionStableStatus
 * @param ignitionStatus - ignitionStatus
 * @param driverDoorAjar - driverDoorAjar
 * @param passengerDoorAjar - passengerDoorAjar
 * @param rearLeftDoorAjar - rearLeftDoorAjar
 * @param rearRightDoorAjar - rearRightDoorAjar
 * @return A SDLBodyInformation object
 */
- (instancetype)initWithParkBrakeActive:(BOOL)parkBrakeActive ignitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus ignitionStatus:(SDLIgnitionStatus)ignitionStatus driverDoorAjar:(nullable NSNumber<SDLBool> *)driverDoorAjar passengerDoorAjar:(nullable NSNumber<SDLBool> *)passengerDoorAjar rearLeftDoorAjar:(nullable NSNumber<SDLBool> *)rearLeftDoorAjar rearRightDoorAjar:(nullable NSNumber<SDLBool> *)rearRightDoorAjar;

/**
 * References signal "PrkBrkActv_B_Actl".

 Required
 */
@property (strong, nonatomic) NSNumber<SDLBool> *parkBrakeActive;

/**
 * References signal "Ignition_Switch_Stable". See IgnitionStableStatus.

 Required
 */
@property (strong, nonatomic) SDLIgnitionStableStatus ignitionStableStatus;

/**
 * References signal "Ignition_status". See IgnitionStatus.

 Required
 */
@property (strong, nonatomic) SDLIgnitionStatus ignitionStatus;

/**
 * References signal "DrStatDrv_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverDoorAjar;

/**
 * References signal "DrStatPsngr_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *passengerDoorAjar;

/**
 * References signal "DrStatRl_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rearLeftDoorAjar;

/**
 * References signal "DrStatRr_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rearRightDoorAjar;

@end

NS_ASSUME_NONNULL_END
