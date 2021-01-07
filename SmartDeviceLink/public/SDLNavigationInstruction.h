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

#import "SDLDirection.h"
#import "SDLNavigationAction.h"
#import "SDLNavigationJunction.h"

@class SDLDateTime;
@class SDLImage;
@class SDLLocationDetails;


NS_ASSUME_NONNULL_BEGIN

/**
 * @added in SmartDeviceLink 5.1.0
 */
@interface SDLNavigationInstruction : SDLRPCStruct

/**
 *  Convenience init for required parameters
 *
 *  @param locationDetails The location details
 *  @param action The navigation action
 *  @return A SDLNavigationInstruction object
 */
- (instancetype)initWithLocationDetails:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action;

/**
 * @param locationDetails - locationDetails
 * @param action - action
 * @param eta - eta
 * @param bearing - bearing
 * @param junctionType - junctionType
 * @param drivingSide - drivingSide
 * @param details - details
 * @param image - image
 * @return A SDLNavigationInstruction object
 */
- (instancetype)initWithLocationDetailsParam:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action eta:(nullable SDLDateTime *)eta bearing:(nullable NSNumber<SDLUInt> *)bearing junctionType:(nullable SDLNavigationJunction)junctionType drivingSide:(nullable SDLDirection)drivingSide details:(nullable NSString *)details image:(nullable SDLImage *)image __deprecated_msg("An initializer without param will eventually be added instead");

/**
 *  Convenience init for all parameters.
 *
 *  @param locationDetails The location details
 *  @param action The navigation action
 *  @param eta The estimated time of arrival
 *  @param bearing The angle at which this instruction takes place
 *  @param junctionType The navigation junction type
 *  @param drivingSide Used to infer which side of the road this instruction takes place
 *  @param details This is a string representation of this instruction, used to display instructions to the users
 *  @param image An image representation of this instruction
 *  @return A SDLNavigationInstruction object
 */
- (instancetype)initWithLocationDetails:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action eta:(nullable SDLDateTime *)eta bearing:(UInt16)bearing junctionType:(nullable SDLNavigationJunction)junctionType drivingSide:(nullable SDLDirection)drivingSide details:(nullable NSString *)details image:(nullable SDLImage *)image __deprecated_msg("An initializer with different parameter types will eventually be added instead");

/**
 *  The location details.
 *
 *  SDLLocationDetails, Required
 */
@property (strong, nonatomic) SDLLocationDetails *locationDetails;

/**
 *  The navigation action.
 *
 *  SDLNavigationAction, Required
 */
@property (strong, nonatomic) SDLNavigationAction action;

/**
 *  The estimated time of arrival.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *eta;

/**
 *  The angle at which this instruction takes place. For example, 0 would mean straight, <=45 is bearing right, >= 135 is sharp right, between 45 and 135 is a regular right, and 180 is a U-Turn, etc. 
 *
 *  Integer, Optional, minValue="0" maxValue="359"
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *bearing;

/**
 *  The navigation junction type.
 *
 *  SDLNavigationJunction, Optional
 */
@property (nullable, strong, nonatomic) SDLNavigationJunction junctionType;

/**
 *  Used to infer which side of the road this instruction takes place. For a U-Turn (action=TURN, bearing=180) this will determine which direction the turn should take place.
 *
 *  SDLDirection, Optional
 */
@property (nullable, strong, nonatomic) SDLDirection drivingSide;

/**
 *  This is a string representation of this instruction, used to display instructions to the users. This is not intended to be read aloud to the users, see the param prompt in `NavigationServiceData` for that.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *details;

/**
 *  An image representation of this instruction.
 *
 *  SDLImage, Optional
 */
@property (nullable, strong, nonatomic) SDLImage *image;

@end

NS_ASSUME_NONNULL_END
