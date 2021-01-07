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
 Struct used in SendLocation describing an address
 */
@interface SDLOasisAddress : SDLRPCStruct

/**
 * @param countryName - countryName
 * @param countryCode - countryCode
 * @param postalCode - postalCode
 * @param administrativeArea - administrativeArea
 * @param subAdministrativeArea - subAdministrativeArea
 * @param locality - locality
 * @param subLocality - subLocality
 * @param thoroughfare - thoroughfare
 * @param subThoroughfare - subThoroughfare
 * @return A SDLOASISAddress object
 */
- (instancetype)initWithCountryName:(nullable NSString *)countryName countryCode:(nullable NSString *)countryCode postalCode:(nullable NSString *)postalCode administrativeArea:(nullable NSString *)administrativeArea subAdministrativeArea:(nullable NSString *)subAdministrativeArea locality:(nullable NSString *)locality subLocality:(nullable NSString *)subLocality thoroughfare:(nullable NSString *)thoroughfare subThoroughfare:(nullable NSString *)subThoroughfare;

/// Convenience init to describe an oasis address
///
/// @param subThoroughfare Portion of thoroughfare (e.g. house number)
/// @param thoroughfare Hypernym for street, road etc
/// @param locality Hypernym for city/village
/// @param administrativeArea Portion of country (e.g. state)
/// @param postalCode PostalCode of location (PLZ, ZIP, PIN, CAP etc.)
/// @param countryCode CountryCode of the country(ISO 3166-2)
- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode __deprecated_msg("Use initWithCountryName:countryCode:postalCode:administrativeArea:subAdministrativeArea:locality:subLocality:thoroughfare:subThoroughfare:");

/// Convenience init to describe an oasis address with all parameters
///
/// @param subThoroughfare Portion of thoroughfare (e.g. house number)
/// @param thoroughfare Hypernym for street, road etc
/// @param locality Hypernym for city/village
/// @param administrativeArea Portion of country (e.g. state)
/// @param postalCode PostalCode of location (PLZ, ZIP, PIN, CAP etc.)
/// @param countryCode CountryCode of the country(ISO 3166-2)
/// @param subAdministrativeArea Portion of administrativeArea (e.g. county)
/// @param subLocality Hypernym for district
- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode countryName:(nullable NSString *)countryName subAdministrativeArea:(nullable NSString *)subAdministrativeArea subLocality:(nullable NSString *)subLocality __deprecated_msg("Use initWithCountryName:countryCode:postalCode:administrativeArea:subAdministrativeArea:locality:subLocality:thoroughfare:subThoroughfare:");

/**
 * Name of the country (localized)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *countryName;

/**
 * countryCode of the country(ISO 3166-2)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *countryCode;

/**
 * postalCode of location (PLZ, ZIP, PIN, CAP etc.)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *postalCode;

/**
 * Portion of country (e.g. state)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *administrativeArea;

/**
 * Portion of administrativeArea (e.g. county)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subAdministrativeArea;

/**
 * Hypernym for city/village
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *locality;

/**
 * Hypernym for district
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subLocality;

/**
 * Hypernym for street, road etc.
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *thoroughfare;

/**
 * Portion of thoroughfare (e.g. house number)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subThoroughfare;

@end

NS_ASSUME_NONNULL_END
