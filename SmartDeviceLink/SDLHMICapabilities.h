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

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Contains information about the HMI capabilities.

 Since SDL 3.0
**/
@interface SDLHMICapabilities : SDLRPCStruct

/**
 * @param navigation - navigation
 * @param phoneCall - phoneCall
 * @param videoStreaming - videoStreaming
 * @param remoteControl - remoteControl
 * @param appServices - appServices
 * @param displays - displays
 * @param seatLocation - seatLocation
 * @param driverDistraction - driverDistraction
 * @return A SDLHMICapabilities object
 */
- (instancetype)initWithNavigation:(nullable NSNumber<SDLBool> *)navigation phoneCall:(nullable NSNumber<SDLBool> *)phoneCall videoStreaming:(nullable NSNumber<SDLBool> *)videoStreaming remoteControl:(nullable NSNumber<SDLBool> *)remoteControl appServices:(nullable NSNumber<SDLBool> *)appServices displays:(nullable NSNumber<SDLBool> *)displays seatLocation:(nullable NSNumber<SDLBool> *)seatLocation driverDistraction:(nullable NSNumber<SDLBool> *)driverDistraction;

/**
 Availability of built in Nav. True: Available, False: Not Available
 
 Boolean value. Optional.

 Since SDL 3.0
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *navigation;

/**
 Availability of built in phone. True: Available, False: Not Available
 
 Boolean value. Optional.

 Since SDL 3.0
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *phoneCall;

/**
 Availability of built in video streaming. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 4.5
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *videoStreaming;

/**
 Availability of built in remote control. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 4.5
**/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *remoteControl;

/**
 Availability of app services. True: Available, False: Not Available

 App services is supported since SDL 5.1. If your connection is 5.1+, you can assume that app services is available even though between v5.1 and v6.0 this parameter is `nil`.

 Boolean value. Optional.

 Since SDL 6.0
**/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *appServices;

/**
 Availability of displays. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 6.0
**/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *displays;

/**
 Availability of seatLocation. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 6.0
 **/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *seatLocation;

/**
 * Availability of driver distraction capability. True: Available, False: Not Available
 *
 * @since SDL 7.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverDistraction;

@end

NS_ASSUME_NONNULL_END
