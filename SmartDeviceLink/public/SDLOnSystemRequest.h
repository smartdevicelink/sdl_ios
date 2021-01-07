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

#import "SDLRPCNotification.h"

#import "SDLFileType.h"
#import "SDLRequestType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An asynchronous request from the system for specific data from the device or the cloud or response to a request from the device or cloud Binary data can be included in hybrid part of message for some requests (such as Authentication request responses)
 *
 * @added in SmartDeviceLink 3.0.0
 */
@interface SDLOnSystemRequest : SDLRPCNotification

/**
 * @param requestType - requestType
 * @return A SDLOnSystemRequest object
 */
- (instancetype)initWithRequestType:(SDLRequestType)requestType;

/**
 * @param requestType - requestType
 * @param requestSubType - requestSubType
 * @param url - url
 * @param timeout - timeout
 * @param fileType - fileType
 * @param offset - offset
 * @param length - length
 * @return A SDLOnSystemRequest object
 */
- (instancetype)initWithRequestType:(SDLRequestType)requestType requestSubType:(nullable NSString *)requestSubType url:(nullable NSString *)url timeout:(nullable NSNumber<SDLUInt> *)timeout fileType:(nullable SDLFileType)fileType offset:(nullable NSNumber<SDLUInt> *)offset length:(nullable NSNumber<SDLUInt> *)length;

/**
 The type of system request.
 */
@property (strong, nonatomic) SDLRequestType requestType;

/**
 A request subType used when the `requestType` is `OEM_SPECIFIC`.

 Optional, Max length 255
 */
@property (strong, nonatomic, nullable) NSString *requestSubType;

/**
 Optional URL for HTTP requests. If blank, the binary data shall be forwarded to the app. If not blank, the binary data shall be forwarded to the url with a provided timeout in seconds.
 */
@property (nullable, strong, nonatomic) NSString *url;

/**
 Optional timeout for HTTP requests Required if a URL is provided
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;

/**
 Optional file type (meant for HTTP file requests).
 */
@property (nullable, strong, nonatomic) SDLFileType fileType;

/**
 Optional offset in bytes for resuming partial data chunks
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *offset;

/**
 Optional length in bytes for resuming partial data chunks
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *length;

@end

NS_ASSUME_NONNULL_END
