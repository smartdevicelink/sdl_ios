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
 * Include the data defined in Radio Data System, which is a communications protocol standard for embedding small amounts of digital information in conventional FM radio broadcasts.
 */
@interface SDLRDSData : SDLRPCStruct

/// Convenience init
///
/// @param programService Program Service Name
/// @param radioText Radio Text
/// @param clockText The clock text in UTC format as YYYY-MM-DDThh:mm:ss.sTZD
/// @param programIdentification  Program Identification - the call sign for the radio station
/// @param programType The program type - The region should be used to differentiate between EU and North America program types
/// @param trafficProgramIdentification Traffic Program Identification - Identifies a station that offers traffic
/// @param trafficAnnouncementIdentification Traffic Announcement Identification - Indicates an ongoing traffic announcement
/// @param region Region
- (instancetype)initWithProgramService:(nullable NSString *)programService radioText:(nullable NSString *)radioText clockText:(nullable NSString *)clockText programIdentification:(nullable NSString *)programIdentification programType:(nullable NSNumber<SDLInt> *)programType trafficProgramIdentification:(nullable NSNumber<SDLBool> *)trafficProgramIdentification trafficAnnouncementIdentification:(nullable NSNumber<SDLBool> *)trafficAnnouncementIdentification region:(nullable NSString *)region;

/**
 * Program Service Name
 *
 * optional, 0-8
 */
@property (nullable, strong, nonatomic) NSString *programService;

/**
 * Radio Text
 *
 * optional, 0-64
 */
@property (nullable, strong, nonatomic) NSString *radioText;

/**
 * The clock text in UTC format as YYYY-MM-DDThh:mm:ss.sTZD
 *
 * optional, 0-24
 */
@property (nullable, strong, nonatomic) NSString *clockText;

/**
 *  Program Identification - the call sign for the radio station
 *
 * optional, 0-6
 */
@property (nullable, strong, nonatomic) NSString *programIdentification;

/**
 * The program type - The region should be used to differentiate between EU
 * and North America program types
 *
 * optional, 0-31
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *programType;

/**
 * Traffic Program Identification - Identifies a station that offers traffic
 *
 * optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *trafficProgramIdentification;

/**
 * Traffic Announcement Identification - Indicates an ongoing traffic announcement
 *
 * optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *trafficAnnouncementIdentification;

/**
 * Region
 *
 * optional, 0-8
 */
@property (nullable, strong, nonatomic) NSString *region;

@end

NS_ASSUME_NONNULL_END
