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
 * This notification tells an app to update the AddSubMenu or its 'sub' AddCommand and AddSubMenus with the requested data
 *
 * @since SDL 7.0
 */
@interface SDLOnUpdateSubMenu : SDLRPCNotification

/**
 * @param menuID - @(menuID)
 * @return A SDLOnUpdateSubMenu object
 */
- (instancetype)initWithMenuID:(UInt32)menuID;

/**
 * @param menuID - @(menuID)
 * @param updateSubCells - updateSubCells
 * @return A SDLOnUpdateSubMenu object
 */
- (instancetype)initWithMenuID:(UInt32)menuID updateSubCells:(nullable NSNumber<SDLBool> *)updateSubCells;

/**
 * This menuID must match a menuID in the current menu structure
 * {"num_min_value": 0, "num_max_value": 2000000000}
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *menuID;

/**
 * If not set, assume false. If true, the app should send AddCommands with parentIDs matching the menuID. These AddCommands will then be attached to the submenu and displayed if the submenu is selected.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *updateSubCells;

@end

NS_ASSUME_NONNULL_END
