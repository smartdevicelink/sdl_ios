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

#import "SDLECallConfirmationStatus.h"
#import "SDLVehicleDataNotificationStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data struct for emergency call information
 */
@interface SDLECallInfo : SDLRPCStruct

/**
 * @param eCallNotificationStatus - eCallNotificationStatus
 * @param auxECallNotificationStatus - auxECallNotificationStatus
 * @param eCallConfirmationStatus - eCallConfirmationStatus
 * @return A SDLECallInfo object
 */
- (instancetype)initWithECallNotificationStatus:(SDLVehicleDataNotificationStatus)eCallNotificationStatus auxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus eCallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus;

/**
 References signal "eCallNotification_4A". See VehicleDataNotificationStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataNotificationStatus eCallNotificationStatus;

/**
 References signal "eCallNotification". See VehicleDataNotificationStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataNotificationStatus auxECallNotificationStatus;

/**
 References signal "eCallConfirmation". See ECallConfirmationStatus.

 Required
 */
@property (strong, nonatomic) SDLECallConfirmationStatus eCallConfirmationStatus;

@end

NS_ASSUME_NONNULL_END
