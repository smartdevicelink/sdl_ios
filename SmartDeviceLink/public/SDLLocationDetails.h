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

@class SDLLocationCoordinate;
@class SDLImage;
@class SDLOasisAddress;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes a location, including its coordinate, name, etc. Used in WayPoints.
 */
@interface SDLLocationDetails : SDLRPCStruct

/**
 *  Convenience init for all parameters.
 *
 *  @param coordinate Latitude/Longitude of the location
 *  @param locationName Name of location
 *  @param addressLines Location address for display purposes only
 *  @param locationDescription Description intended location / establishment
 *  @param phoneNumber Phone number of location / establishment
 *  @param locationImage Image / icon of intended location
 *  @param searchAddress Address to be used by navigation engines for search
 *  @return A SDLLocationDetails object
 */
- (instancetype)initWithCoordinate:(nullable SDLLocationCoordinate *)coordinate locationName:(nullable NSString *)locationName addressLines:(nullable NSArray<NSString *> *)addressLines locationDescription:(nullable NSString *)locationDescription phoneNumber:(nullable NSString*)phoneNumber locationImage:(nullable SDLImage *)locationImage searchAddress:(nullable SDLOasisAddress *)searchAddress;

/**
 *  Convenience init for location coordinate.
 *
 *  @param coordinate       Latitude/Longitude of the location
 *  @return                 A SDLLocationDetails object
 */
- (instancetype)initWithCoordinate:(SDLLocationCoordinate *)coordinate __deprecated_msg("Use initWithCoordinate:locationName:addressLines:locationDescription:phoneNumber:locationImage:searchAddress: instead");

/**
 * Latitude/Longitude of the location
 *
 * @see SDLLocationCoordinate
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLLocationCoordinate *coordinate;

/**
 * Name of location.
 *
 * Optional, Max length 500 chars
 */
@property (nullable, copy, nonatomic) NSString *locationName;

/**
 * Location address for display purposes only.
 *
 * Optional, Array of Strings, Array length 0 - 4, Max String length 500
 */
@property (nullable, copy, nonatomic) NSArray<NSString *> *addressLines;

/**
 * Description intended location / establishment.
 *
 * Optional, Max length 500 chars
 */
@property (nullable, copy, nonatomic) NSString *locationDescription;

/**
 * Phone number of location / establishment.
 *
 * Optional, Max length 500 chars
 */
@property (nullable, copy, nonatomic) NSString *phoneNumber;

/**
 * Image / icon of intended location.
 *
 * @see SDLImage
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *locationImage;

/**
 * Address to be used by navigation engines for search.
 *
 * @see SDLOASISAddress
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLOasisAddress *searchAddress;


@end

NS_ASSUME_NONNULL_END
