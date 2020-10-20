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
 Vehicle data struct for the seat belt status
 */
@interface SDLBeltStatus : SDLRPCStruct

/**
 * @param driverBeltDeployed - driverBeltDeployed
 * @param passengerBeltDeployed - passengerBeltDeployed
 * @param passengerBuckleBelted - passengerBuckleBelted
 * @param driverBuckleBelted - driverBuckleBelted
 * @param leftRow2BuckleBelted - leftRow2BuckleBelted
 * @param passengerChildDetected - passengerChildDetected
 * @param rightRow2BuckleBelted - rightRow2BuckleBelted
 * @param middleRow2BuckleBelted - middleRow2BuckleBelted
 * @param middleRow3BuckleBelted - middleRow3BuckleBelted
 * @param leftRow3BuckleBelted - leftRow3BuckleBelted
 * @param rightRow3BuckleBelted - rightRow3BuckleBelted
 * @param leftRearInflatableBelted - leftRearInflatableBelted
 * @param rightRearInflatableBelted - rightRearInflatableBelted
 * @param middleRow1BeltDeployed - middleRow1BeltDeployed
 * @param middleRow1BuckleBelted - middleRow1BuckleBelted
 * @return A SDLBeltStatus object
 */
- (instancetype)initWithDriverBeltDeployed:(SDLVehicleDataEventStatus)driverBeltDeployed passengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed passengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted driverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted leftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted passengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected rightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted middleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted middleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted leftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted rightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted leftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted rightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted middleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed middleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted;

/**
 References signal "VedsDrvBelt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverBeltDeployed;

/**
 References signal "VedsPasBelt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerBeltDeployed;

/**
 References signal "VedsRw1PasBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerBuckleBelted;

/**
 References signal "VedsRw1DrvBckl_D_Ltchd". See VehicleDataEventStatus

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverBuckleBelted;

/**
 References signal "VedsRw2lBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRow2BuckleBelted;

/**
 References signal "VedsRw1PasChld_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerChildDetected;

/**
 References signal "VedsRw2rBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRow2BuckleBelted;

/**
 References signal "VedsRw2mBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow2BuckleBelted;

/**
 References signal "VedsRw3mBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow3BuckleBelted;

/**
 References signal "VedsRw3lBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRow3BuckleBelted;

/**
 References signal "VedsRw3rBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRow3BuckleBelted;

/**
 References signal "VedsRw2lRib_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRearInflatableBelted;

/**
 References signal "VedsRw2rRib_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRearInflatableBelted;

/**
 References signal "VedsRw1mBelt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow1BeltDeployed;

/**
 References signal "VedsRw1mBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow1BuckleBelted;

@end

NS_ASSUME_NONNULL_END
