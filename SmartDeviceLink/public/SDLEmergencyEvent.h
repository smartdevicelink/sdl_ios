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

#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data struct for an emergency event
 */
@interface SDLEmergencyEvent : SDLRPCStruct

/**
 * @param emergencyEventType - emergencyEventType
 * @param fuelCutoffStatus - fuelCutoffStatus
 * @param rolloverEvent - rolloverEvent
 * @param maximumChangeVelocity - @(maximumChangeVelocity)
 * @param multipleEvents - multipleEvents
 * @return A SDLEmergencyEvent object
 */
- (instancetype)initWithEmergencyEventType:(SDLEmergencyEventType)emergencyEventType fuelCutoffStatus:(SDLFuelCutoffStatus)fuelCutoffStatus rolloverEvent:(SDLVehicleDataEventStatus)rolloverEvent maximumChangeVelocity:(UInt8)maximumChangeVelocity multipleEvents:(SDLVehicleDataEventStatus)multipleEvents;

/**
 References signal "VedsEvntType_D_Ltchd". See EmergencyEventType.

 Required
 */
@property (strong, nonatomic) SDLEmergencyEventType emergencyEventType;

/**
 References signal "RCM_FuelCutoff". See FuelCutoffStatus.

 Required
 */
@property (strong, nonatomic) SDLFuelCutoffStatus fuelCutoffStatus;

/**
 References signal "VedsEvntRoll_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rolloverEvent;

/**
 References signal "VedsMaxDeltaV_D_Ltchd". Change in velocity in KPH.

 Additional reserved values:
 0x00 No event,
 0xFE Not supported,
 0xFF Fault

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *maximumChangeVelocity;

/**
 References signal "VedsMultiEvnt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus multipleEvents;

@end

NS_ASSUME_NONNULL_END
