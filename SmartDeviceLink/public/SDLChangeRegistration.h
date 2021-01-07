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
#import "SDLLanguage.h"

@class SDLTTSChunk;

NS_ASSUME_NONNULL_BEGIN

/**
 * If the app recognizes during the app registration that the SDL HMI language (voice/TTS and/or display) does not match the app language, the app will be able (but does not need) to change this registration with changeRegistration prior to app being brought into focus.
 *
 * Any HMILevel allowed
 *
 * @since SDL 2.0
 */
@interface SDLChangeRegistration : SDLRPCRequest

/**
Constructs a newly allocated SDLChangeRegistration object with required parameters

@param language the name of the button
@param hmiDisplayLanguage the module where the button should be pressed

@return An instance of the SDLChangeRegistration class.
*/
- (instancetype)initWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage;

/**
Constructs a newly allocated SDLChangeRegistration object with all parameters

@param language the language the app wants to change to
@param hmiDisplayLanguage HMI display language
@param appName request a new app name registration
@param ttsName request a new TTSName registration
@param ngnMediaScreenAppName request a new app short name registration
@param vrSynonyms request a new VR synonyms registration

@return An instance of the SDLChangeRegistration class.
*/
- (instancetype)initWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage appName:(nullable NSString *)appName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName ngnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms;

/**
 * The language the app wants to change to
 */
@property (strong, nonatomic) SDLLanguage language;

/**
 * HMI display language
 */
@property (strong, nonatomic) SDLLanguage hmiDisplayLanguage;

/**
 *  Request a new app name registration
 *
 *  Optional, Max string length 100 chars
 */
@property (nullable, copy, nonatomic) NSString *appName;

/**
 *  Request a new TTSName registration.
 *
 *  Optional, Array of SDLTTSChunk, 1 - 100 elements
 */
@property (nullable, copy, nonatomic) NSArray<SDLTTSChunk *> *ttsName;

/**
 *  Request a new app short name registration
 *
 *  Optional, Max string length 100 chars
 */
@property (nullable, copy, nonatomic) NSString *ngnMediaScreenAppName;

/**
 *  Request a new VR synonyms registration
 *
 *  Optional, Array of NSString, 1 - 100 elements, max string length 40 chars
 */
@property (nullable, copy, nonatomic) NSArray<NSString *> *vrSynonyms;

@end

NS_ASSUME_NONNULL_END
