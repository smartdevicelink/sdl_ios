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

#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data status struct for airbags
 */
@interface SDLAirbagStatus : SDLRPCStruct

/**
 * @param driverAirbagDeployed - driverAirbagDeployed
 * @param driverSideAirbagDeployed - driverSideAirbagDeployed
 * @param driverCurtainAirbagDeployed - driverCurtainAirbagDeployed
 * @param passengerAirbagDeployed - passengerAirbagDeployed
 * @param passengerCurtainAirbagDeployed - passengerCurtainAirbagDeployed
 * @param driverKneeAirbagDeployed - driverKneeAirbagDeployed
 * @param passengerSideAirbagDeployed - passengerSideAirbagDeployed
 * @param passengerKneeAirbagDeployed - passengerKneeAirbagDeployed
 * @return A SDLAirbagStatus object
 */
- (instancetype)initWithDriverAirbagDeployed:(SDLVehicleDataEventStatus)driverAirbagDeployed driverSideAirbagDeployed:(SDLVehicleDataEventStatus)driverSideAirbagDeployed driverCurtainAirbagDeployed:(SDLVehicleDataEventStatus)driverCurtainAirbagDeployed passengerAirbagDeployed:(SDLVehicleDataEventStatus)passengerAirbagDeployed passengerCurtainAirbagDeployed:(SDLVehicleDataEventStatus)passengerCurtainAirbagDeployed driverKneeAirbagDeployed:(SDLVehicleDataEventStatus)driverKneeAirbagDeployed passengerSideAirbagDeployed:(SDLVehicleDataEventStatus)passengerSideAirbagDeployed passengerKneeAirbagDeployed:(SDLVehicleDataEventStatus)passengerKneeAirbagDeployed;

/**
 References signal "VedsDrvBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverAirbagDeployed;

/**
 References signal "VedsDrvSideBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverSideAirbagDeployed;

/**
 References signal "VedsDrvCrtnBag_D_Ltchd". See VehicleDataEventStatus

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverCurtainAirbagDeployed;

/**
 References signal "VedsPasBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerAirbagDeployed;

/**
 References signal "VedsPasCrtnBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerCurtainAirbagDeployed;

/**
 References signal "VedsKneeDrvBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverKneeAirbagDeployed;

/**
 References signal "VedsPasSideBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerSideAirbagDeployed;

/**
 References signal "VedsKneePasBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerKneeAirbagDeployed;

@end

NS_ASSUME_NONNULL_END
