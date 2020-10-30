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

#import "SDLTemplateColorScheme.h"
#import "SDLPredefinedLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Used to set an alternate template layout to a window.

 @since SDL 6.0
 */
@interface SDLTemplateConfiguration : SDLRPCStruct

/**
 Constructor with the required values.

 @param predefinedLayout A template layout an app uses to display information. The broad details of the layout are defined, but the details depend on the IVI system. Used in SetDisplayLayout.
 */
- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout;

// HAX: We are doing this because `template` is a C++ keyword and won't compile.
#ifndef __cplusplus
/**
 Init with the required values.

 @param template Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
- (instancetype)initWithTemplate:(NSString *)template;


/**
 Convinience constructor with all the parameters.

 @param template Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 @param dayColorScheme The color scheme to use when the head unit is in a light / day situation. If nil, the existing color scheme will be used.
 @param nightColorScheme The color scheme to use when the head unit is in a dark / night situation.
 */
- (instancetype)initWithTemplate:(NSString *)template dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
@property (strong, nonatomic) NSString *template;
#endif

#ifdef __cplusplus
/**
 Init with the required values.

 @param templateName Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
- (instancetype)initWithTemplate:(NSString *)templateName;


/**
 Convinience constructor with all the parameters.

 @param templateName Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 @param dayColorScheme The color scheme to use when the head unit is in a light / day situation. If nil, the existing color scheme will be used.
 @param nightColorScheme The color scheme to use when the head unit is in a dark / night situation.
 */
- (instancetype)initWithTemplate:(NSString *)templateName dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 Predefined or dynamically created window template. Currently only predefined window template layouts are defined.
 */
@property (strong, nonatomic) NSString *templateName;
#endif

/**
 The color scheme to use when the head unit is in a light / day situation.
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;

/**
 The color scheme to use when the head unit is in a dark / night situation.
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

@end

NS_ASSUME_NONNULL_END
