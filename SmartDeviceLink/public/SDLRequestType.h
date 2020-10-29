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


#import "SDLEnum.h"

/**
 A type of system request. Used in SystemRequest.

 @added in SmartDeviceLink 3.0.0
 */
typedef SDLEnum SDLRequestType NS_TYPED_ENUM;

/**
 An HTTP request
 */
extern SDLRequestType const SDLRequestTypeHTTP;

/**
 A file resumption request
 */
extern SDLRequestType const SDLRequestTypeFileResume;

/**
 An authentication request
 */
extern SDLRequestType const SDLRequestTypeAuthenticationRequest;

/**
 An authentication challenge
 */
extern SDLRequestType const SDLRequestTypeAuthenticationChallenge;

/**
 An authentication acknowledgment
 */
extern SDLRequestType const SDLRequestTypeAuthenticationAck;

/**
 An proprietary formatted request
 */
extern SDLRequestType const SDLRequestTypeProprietary;

/**
 An Query Apps request
 */
extern SDLRequestType const SDLRequestTypeQueryApps;

/**
 A Launch Apps request
 */
extern SDLRequestType const SDLRequestTypeLaunchApp;

/**
 The URL for a lock screen icon
 */
extern SDLRequestType const SDLRequestTypeLockScreenIconURL;

/**
 A traffic message channel request
 */
extern SDLRequestType const SDLRequestTypeTrafficMessageChannel;

/**
 A driver profile request
 */
extern SDLRequestType const SDLRequestTypeDriverProfile;

/**
 A voice search request
 */
extern SDLRequestType const SDLRequestTypeVoiceSearch;

/**
 A navigation request
 */
extern SDLRequestType const SDLRequestTypeNavigation;

/**
 A phone request
 */
extern SDLRequestType const SDLRequestTypePhone;

/**
 A climate request
 */
extern SDLRequestType const SDLRequestTypeClimate;

/**
 A settings request
 */
extern SDLRequestType const SDLRequestTypeSettings;

/**
 A vehicle diagnostics request
 */
extern SDLRequestType const SDLRequestTypeVehicleDiagnostics;

/**
 An emergency request
 */
extern SDLRequestType const SDLRequestTypeEmergency;

/**
 A media request
 */
extern SDLRequestType const SDLRequestTypeMedia;

/**
 A firmware over-the-air request
 */
extern SDLRequestType const SDLRequestTypeFOTA;

/**
 A request that is OEM specific using the `RequestSubType` in SystemRequest
 */
extern SDLRequestType const SDLRequestTypeOEMSpecific;

/**
 A request for an icon url
 */
extern SDLRequestType const SDLRequestTypeIconURL;

