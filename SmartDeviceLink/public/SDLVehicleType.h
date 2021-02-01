/*
 * Copyright (c) 2021, SmartDeviceLink Consortium, Inc.
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
 * Describes the type of vehicle the mobile phone is connected with.
 *
 * @since SDL 2.0
 */
@interface SDLVehicleType : SDLRPCStruct

/**
 * @param make - make
 * @param model - model
 * @param modelYear - modelYear
 * @param trim - trim
 * @return A SDLVehicleType object
 */
- (instancetype)initWithMake:(nullable NSString *)make model:(nullable NSString *)model modelYear:(nullable NSString *)modelYear trim:(nullable NSString *)trim;

/**
 * Make of the vehicle, e.g. Ford
 * {"string_min_length": 1, "string_max_length": 500}
 */
@property (nullable, strong, nonatomic) NSString *make;

/**
 * Model of the vehicle, e.g. Fiesta
 * {"string_min_length": 1, "string_max_length": 500}
 */
@property (nullable, strong, nonatomic) NSString *model;

/**
 * Model Year of the vehicle, e.g. 2013
 * {"string_min_length": 1, "string_max_length": 500}
 */
@property (nullable, strong, nonatomic) NSString *modelYear;

/**
 * Trim of the vehicle, e.g. SE
 * {"string_min_length": 1, "string_max_length": 500}
 */
@property (nullable, strong, nonatomic) NSString *trim;

@end

NS_ASSUME_NONNULL_END