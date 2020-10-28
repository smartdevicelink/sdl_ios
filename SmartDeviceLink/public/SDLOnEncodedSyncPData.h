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

NS_ASSUME_NONNULL_BEGIN

/**
 Callback including encoded data of any SyncP packets that SYNC needs to send back to the mobile device. Legacy / v1 Protocol implementation; responds to EncodedSyncPData. *** DEPRECATED ***
 */
__deprecated
@interface SDLOnEncodedSyncPData : SDLRPCNotification

/**
 * @param data - data
 * @return A SDLOnEncodedSyncPData object
 */
- (instancetype)initWithData:(NSArray<NSString *> *)data;

/**
 * @param data - data
 * @param URL - URL
 * @param Timeout - Timeout
 * @return A SDLOnEncodedSyncPData object
 */
- (instancetype)initWithData:(NSArray<NSString *> *)data uRL:(nullable NSString *)URL timeout:(nullable NSNumber<SDLUInt> *)Timeout;

/**
 Contains base64 encoded string of SyncP packets.
 */
@property (strong, nonatomic) NSArray<NSString *> *data;

/**
 If blank, the SyncP data shall be forwarded to the app. If not blank, the SyncP data shall be forwarded to the provided URL.
 */
@property (nullable, strong, nonatomic) NSString *URL;

/**
 If blank, the SyncP data shall be forwarded to the app. If not blank, the SyncP data shall be forwarded with the provided timeout in seconds.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
