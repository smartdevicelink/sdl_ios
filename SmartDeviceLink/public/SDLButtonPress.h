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
#import "SDLModuleType.h"
#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This RPC allows a remote control type mobile application to simulate a hardware button press event.

 @since RPC 4.5
*/
@interface SDLButtonPress : SDLRPCRequest

/**
 * @param moduleType - moduleType
 * @param buttonName - buttonName
 * @param buttonPressMode - buttonPressMode
 * @return A SDLButtonPress object
 */
- (instancetype)initWithModuleType:(SDLModuleType)moduleType buttonName:(SDLButtonName)buttonName buttonPressMode:(SDLButtonPressMode)buttonPressMode;

/**
 * @param moduleType - moduleType
 * @param buttonName - buttonName
 * @param buttonPressMode - buttonPressMode
 * @param moduleId - moduleId
 * @return A SDLButtonPress object
 */
- (instancetype)initWithModuleType:(SDLModuleType)moduleType buttonName:(SDLButtonName)buttonName buttonPressMode:(SDLButtonPressMode)buttonPressMode moduleId:(nullable NSString *)moduleId;

/**
Constructs a newly allocated SDLButtonPress object with the given parameters

@param buttonName the name of the button
@param moduleType the module where the button should be pressed
@param moduleId the id of the module
@param buttonPressMode indicates LONG or SHORT button press event

@return An instance of the SDLButtonPress class.
*/
- (instancetype)initWithButtonName:(SDLButtonName)buttonName moduleType:(SDLModuleType)moduleType moduleId:(nullable NSString *)moduleId buttonPressMode:(SDLButtonPressMode)buttonPressMode __deprecated_msg("Use initWithModuleType:buttonName:buttonPressMode:moduleId instead");

/**
 * The module where the button should be pressed.
 *
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 *  Id of a module, published by System Capability.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) NSString *moduleId;

/**
 * The name of supported RC climate or radio button.
 *
 */
@property (strong, nonatomic) SDLButtonName buttonName;

/**
 * Indicates whether this is a LONG or SHORT button press event.
 *
 */
@property (strong, nonatomic) SDLButtonPressMode buttonPressMode;

@end

NS_ASSUME_NONNULL_END
