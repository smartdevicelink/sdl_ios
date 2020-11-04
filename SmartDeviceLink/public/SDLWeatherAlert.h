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

#import "SDLRPCRequest.h"
#import "SDLDateTime.h"

NS_ASSUME_NONNULL_BEGIN

/// Contains information about a weather alert
///
/// @added in SmartDeviceLink 5.1.0
@interface SDLWeatherAlert : SDLRPCStruct

/**
 *  Convenience init for all parameters
 *
 *  @param title        The title of the alert
 *  @param summary      A summary for the alert
 *  @param expires      The date the alert expires
 *  @param regions      Regions affected
 *  @param severity     Severity
 *  @param timeIssued   The date the alert was issued
 *  @return             A SDLWeatherAlert alert
 */
- (instancetype)initWithTitle:(nullable NSString *)title summary:(nullable NSString *)summary expires:(nullable SDLDateTime *)expires regions:(nullable NSArray<NSString *> *)regions severity:(nullable NSString *)severity timeIssued:(nullable SDLDateTime *)timeIssued;

/**
 *  The title of the alert.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *title;

/**
 *  A summary for the alert.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *summary;

/**
 *  The date the alert expires.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *expires;

/**
 *  Regions affected.
 *
 *  Array of Strings, Optional, minsize="1" maxsize="99"
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *regions;

/**
 *  Severity of the weather alert.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *severity;

/**
 *  The date the alert was issued.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *timeIssued;

@end

NS_ASSUME_NONNULL_END
