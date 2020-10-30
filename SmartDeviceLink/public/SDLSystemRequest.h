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

#import "SDLRequestType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  An asynchronous request from the device; binary data can be included in hybrid part of message for some requests (such as HTTP, Proprietary, or Authentication requests)
 *
 *  @since SmartDeviceLink 3.0
 */
@interface SDLSystemRequest : SDLRPCRequest

/**
 * @param requestType - requestType
 * @return A SDLSystemRequest object
 */
- (instancetype)initWithRequestType:(SDLRequestType)requestType;

/**
 * @param requestType - requestType
 * @param requestSubType - requestSubType
 * @param fileName - fileName
 * @return A SDLSystemRequest object
 */
- (instancetype)initWithRequestType:(SDLRequestType)requestType requestSubType:(nullable NSString *)requestSubType fileName:(nullable NSString *)fileName;

/**
 Create a generic system request with a file name

 @param requestType The request type to use
 @param fileName The name of the file to use
 @return The request
 */
- (instancetype)initWithType:(SDLRequestType)requestType fileName:(nullable NSString *)fileName __deprecated_msg("Use initWithRequestType: instead");

/**
 Create an OEM_PROPRIETARY system request with a subtype and file name

 @param proprietaryType The proprietary requestSubType to be used
 @param fileName The name of the file to use
 @return The request
 */
- (instancetype)initWithProprietaryType:(NSString *)proprietaryType fileName:(nullable NSString *)fileName __deprecated_msg("Use initWithRequestType:requestSubType:fileName: instead");

/**
 *  The type of system request. Note that Proprietary requests should forward the binary data to the known proprietary module on the system.
 *
 *  Required
 */
@property (strong, nonatomic) SDLRequestType requestType;

/**
 A request subType used when the `requestType` is `OEM_SPECIFIC`.

 Optional, Max length 255
 */
@property (strong, nonatomic, nullable) NSString *requestSubType;

/**
 *  Filename of HTTP data to store in predefined system staging area.
 *
 *  Required if requestType is HTTP. PROPRIETARY requestType should ignore this parameter.
 */
@property (strong, nonatomic, nullable) NSString *fileName;

@end

NS_ASSUME_NONNULL_END
