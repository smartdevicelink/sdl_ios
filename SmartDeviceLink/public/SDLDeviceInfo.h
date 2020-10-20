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
 Various information about connecting device. Referenced in RegisterAppInterface
 */
@interface SDLDeviceInfo : SDLRPCStruct

/**
 * @param hardware - hardware
 * @param firmwareRev - firmwareRev
 * @param os - os
 * @param osVersion - osVersion
 * @param carrier - carrier
 * @param maxNumberRFCOMMPorts - maxNumberRFCOMMPorts
 * @return A SDLDeviceInfo object
 */
- (instancetype)initWithHardware:(nullable NSString *)hardware firmwareRev:(nullable NSString *)firmwareRev os:(nullable NSString *)os osVersion:(nullable NSString *)osVersion carrier:(nullable NSString *)carrier maxNumberRFCOMMPorts:(nullable NSNumber<SDLUInt> *)maxNumberRFCOMMPorts;

/// Convenience init. Object will contain all information about the connected device automatically.
///
/// @return An SDLDeviceInfo object
+ (instancetype)currentDevice;

/**
 Device model

 Optional
 */
@property (nullable, strong, nonatomic) NSString *hardware;

/**
 Device firmware version

 Optional
 */
@property (nullable, strong, nonatomic) NSString *firmwareRev;

/**
 Device OS

 Optional
 */
@property (nullable, strong, nonatomic) NSString *os;

/**
 Device OS version

 Optional
 */
@property (nullable, strong, nonatomic) NSString *osVersion;

/**
 Device mobile carrier

 Optional
 */
@property (nullable, strong, nonatomic) NSString *carrier;

/**
 Number of bluetooth RFCOMM ports available.

 Omitted if not connected via BT or on iOS

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxNumberRFCOMMPorts;

@end

NS_ASSUME_NONNULL_END
