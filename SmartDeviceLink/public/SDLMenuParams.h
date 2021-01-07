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


#import "SDLRPCMessage.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * Used when adding a sub menu to an application menu or existing sub menu.
 *
 * @since SDL 1.0
 */
@interface SDLMenuParams : SDLRPCStruct

/**
 * @param menuName - menuName
 * @return A SDLMenuParams object
 */
- (instancetype)initWithMenuName:(NSString *)menuName;

/**
 * @param menuName - menuName
 * @param parentID - parentID
 * @param position - position
 * @return A SDLMenuParams object
 */
- (instancetype)initWithMenuName:(NSString *)menuName parentID:(nullable NSNumber<SDLUInt> *)parentID position:(nullable NSNumber<SDLUInt> *)position;

/// Convenience init with all parameters.
///
/// @param menuName The menu name
/// @param parentId The unique ID of an existing submenu to which a command will be added
/// @param position The position within the items of the parent Command Menu
/// @return An instance of the add submenu class
- (instancetype)initWithMenuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position __deprecated_msg("Use initWithMenuName:parentID:position: instead");

/**
 * The unique ID of an existing submenu to which a command will be added

 * If this element is not provided, the command will be added to the top level of the Command Menu.
 *
 * Optional, Integer, 0 - 2,000,000,000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *parentID;

/**
 * The position within the items of the parent Command Menu

 * 0 will insert at the front, 1 will insert after the first existing element, etc.
 * 
 * Position of any submenu will always be located before the return and exit options.
 *
 * If position is greater or equal than the number of items in the parent Command Menu, the sub menu will be appended to the end of that Command Menu.
 *
 * If this element is omitted, the entry will be added at the end of the parent menu.
 *
 * Optional, Integer, 0 - 1000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *position;

/**
 * The menu name which appears in menu, representing this command
 * 
 * Required, max length 500 characters
 */
@property (strong, nonatomic) NSString *menuName;

@end

NS_ASSUME_NONNULL_END
