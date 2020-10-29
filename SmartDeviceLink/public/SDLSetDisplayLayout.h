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

#import "SDLPredefinedLayout.h"

@class SDLTemplateColorScheme;

NS_ASSUME_NONNULL_BEGIN

/**
 * This RPC is deprecated. Use Show RPC to change layout.
 *
 * @deprecated in SmartDeviceLink 6.0.0
 * @added in SmartDeviceLink 3.0.0
 */
__deprecated_msg("Use SDLManager.screenManager.changeLayout() instead")
@interface SDLSetDisplayLayout : SDLRPCRequest

/**
 * @param displayLayout - displayLayout
 * @return A SDLSetDisplayLayout object
 */
- (instancetype)initWithDisplayLayout:(NSString *)displayLayout;

/**
 * @param displayLayout - displayLayout
 * @param dayColorScheme - dayColorScheme
 * @param nightColorScheme - nightColorScheme
 * @return A SDLSetDisplayLayout object
 */
- (instancetype)initWithDisplayLayout:(NSString *)displayLayout dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/// Convenience init to set a display layout
///
/// @param predefinedLayout A template layout an app uses to display information
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout;

/// Convenience init to set a display layout
///
/// @param displayLayout A display layout name
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithLayout:(NSString *)displayLayout __deprecated_msg("Use initWithDisplayLayout: instead");

/// Convenience init to set a display layout
///
/// @param predefinedLayout A display layout. Predefined or dynamically created screen layout
/// @param dayColorScheme The color scheme to be used on a head unit using a "light" or "day" color scheme
/// @param nightColorScheme The color scheme to be used on a head unit using a "dark" or "night" color scheme
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/// Convenience init to set a display layout
/// @param displayLayout A display layout name
/// @param dayColorScheme The color scheme to be used on a head unit using a "light" or "day" color scheme
/// @param nightColorScheme The color scheme to be used on a head unit using a "dark" or "night" color scheme
/// @return An SDLSetDisplayLayout object
- (instancetype)initWithLayout:(NSString *)displayLayout dayColorScheme:(SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(SDLTemplateColorScheme *)nightColorScheme __deprecated_msg("Use initWithDisplayLayout:dayColorScheme:nightColorScheme: instead");

/**
 * A display layout. Predefined or dynamically created screen layout.
 * Currently only predefined screen layouts are defined. Predefined layouts
 * include: "ONSCREEN_PRESETS" Custom screen containing app-defined onscreen
 * presets. Currently defined for GEN2
 */
@property (strong, nonatomic) NSString *displayLayout;

/**
 The color scheme to be used on a head unit using a "light" or "day" color scheme. The OEM may only support this theme if their head unit only has a light color scheme.

 Optional
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;

/**
 The color scheme to be used on a head unit using a "dark" or "night" color scheme. The OEM may only support this theme if their head unit only has a dark color scheme.

 Optional
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

@end

NS_ASSUME_NONNULL_END
