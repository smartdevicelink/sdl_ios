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

@class SDLWindowCapability;
@class SDLWindowTypeCapabilities;

NS_ASSUME_NONNULL_BEGIN

/**
 Contain the display related information and all windows related to that display.
 
 @since SDL 6.0
 */
@interface SDLDisplayCapability : SDLRPCStruct

/**
 * @param displayName - displayName
 * @param windowTypeSupported - windowTypeSupported
 * @param windowCapabilities - windowCapabilities
 * @return A SDLDisplayCapability object
 */
- (instancetype)initWithDisplayName:(nullable NSString *)displayName windowTypeSupported:(nullable NSArray<SDLWindowTypeCapabilities *> *)windowTypeSupported windowCapabilities:(nullable NSArray<SDLWindowCapability *> *)windowCapabilities;

/**
 Init with required properties
 
 @param displayName Name of the display.
 */
- (instancetype)initWithDisplayName:(NSString *)displayName __deprecated_msg("Use initWithDisplayName:windowTypeSupported:windowCapabilities: instead");

/**
 Init with all the properities

 @param displayName Name of the display.
 @param windowCapabilities Contains a list of capabilities of all windows related to the app. @see windowCapabilities
 @param windowTypeSupported Informs the application how many windows the app is allowed to create per type.
 */
- (instancetype)initWithDisplayName:(NSString *)displayName windowCapabilities:(nullable NSArray<SDLWindowCapability *> *)windowCapabilities windowTypeSupported:(nullable NSArray<SDLWindowTypeCapabilities *> *)windowTypeSupported __deprecated_msg("Use initWithDisplayName:windowTypeSupported:windowCapabilities: instead");


/**
 Name of the display.
 */
@property (strong, nonatomic, nullable) NSString *displayName;

/**
 Informs the application how many windows the app is allowed to create per type.
 
 Min size 1
 Max size 100
 */
@property (strong, nonatomic, nullable) NSArray<SDLWindowTypeCapabilities *> *windowTypeSupported;

/**
 Contains a list of capabilities of all windows related to the app. Once the app has registered the capabilities of all windows will be provided, but GetSystemCapability still allows requesting window capabilities of all windows.
 
 After registration, only windows with capabilities changed will be included. Following cases will cause only affected windows to be included:
 
 1. App creates a new window. After the window is created, a system capability notification will be sent related only to the created window.
 2. App sets a new template to the window. The new template changes window capabilties. The notification will reflect those changes to the single window.
 
 Min size 1, Max size 1000
 */
@property (strong, nonatomic, nullable) NSArray<SDLWindowCapability *> *windowCapabilities;

@end

NS_ASSUME_NONNULL_END
