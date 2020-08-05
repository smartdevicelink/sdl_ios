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

#import "SDLMenuLayout.h"

@class SDLImage;

/**
 * Add a SDLSubMenu to the Command Menu
 * <p>
 * A SDLSubMenu can only be added to the Top Level Menu (i.e.a SDLSubMenu cannot be
 * added to a SDLSubMenu), and may only contain commands as children
 * <p>
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUD</b>
 * </p>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLDeleteSubMenu SDLAddCommand SDLDeleteCommand
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLAddSubMenu : SDLRPCRequest

/**
 * @param menuID - @(menuID)
 * @param menuName - menuName
 * @return A SDLAddSubMenu object
 */
- (instancetype)initWithMenuID:(UInt32)menuID menuName:(NSString *)menuName;

/**
 * @param menuID - @(menuID)
 * @param menuName - menuName
 * @param position - position
 * @param menuIcon - menuIcon
 * @param menuLayout - menuLayout
 * @param parentID - parentID
 * @return A SDLAddSubMenu object
 */
- (instancetype)initWithMenuID:(UInt32)menuID menuName:(NSString *)menuName position:(nullable NSNumber<SDLUInt> *)position menuIcon:(nullable SDLImage *)menuIcon menuLayout:(nullable SDLMenuLayout)menuLayout parentID:(nullable NSNumber<SDLUInt> *)parentID;

/// Convenience init for creating an add submenu
///
/// @param menuId A menu id
/// @param menuName The menu name
/// @return An SDLAddSubMenu object
- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName __deprecated_msg("Use initWithMenuID:menuName: instead");

/// Convenience init for creating an add submenu
///
/// @param menuId A menu id
/// @param menuName The menu name
/// @param position The position within the menu to add
/// @return An SDLAddSubMenu object
- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName position:(UInt8)position __deprecated_msg("Use initWithMenuID:menuName:position:menuIcon:menuLayout:parentID: instead");

/// Convenience init for creating an add submenu
///
/// @param menuId A menu id
/// @param menuName The menu name
/// @param icon The icon to show on the menu item
/// @param position The position within the menu to add
/// @return An SDLAddSubMenu object
- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName menuIcon:(nullable SDLImage *)icon position:(UInt8)position __deprecated_msg("Use initWithMenuID:menuName:position:menuIcon:menuLayout:parentID: instead");

/// Convenience init for creating an add submenu with all properties.
///
/// @param menuId A menu id
/// @param menuName The menu name
/// @param menuLayout The sub-menu layout
/// @param icon The icon to show on the menu item
/// @param position The position within the menu to add
/// @return An SDLAddSubMenu object
- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName menuLayout:(nullable SDLMenuLayout)menuLayout menuIcon:(nullable SDLImage *)icon position:(UInt8)position __deprecated_msg("Use initWithMenuID:menuName:position:menuIcon:menuLayout:parentID: instead");

/**
 * a Menu ID that identifies a sub menu
 * @discussion This value is used in
 * <i>SDLAddCommand</i> to which SDLSubMenu is the parent of the command being added
 * <p>
 */
@property (strong, nonatomic) NSNumber<SDLInt> *menuID;

/**
 * a position of menu
 * @discussion An NSNumber pointer representing the position within the items
 *            of the top level Command Menu. 0 will insert at the front, 1
 *            will insert after the first existing element, etc. Position of
 *            any submenu will always be located before the return and exit
 *            options
 *            <p>
 *            <b>Notes: </b><br/>
 *            <ul>
 *            <li>
 *            Min Value: 0; Max Value: 1000</li>
 *            <li>If position is greater or equal than the number of items
 *            on top level, the sub menu will be appended by the end</li>
 *            <li>If this parameter is omitted, the entry will be added at
 *            the end of the list</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *position;

/**
 * a menuName which is displayed representing this submenu item
 * @discussion NSString which will be displayed representing this submenu item
 */
@property (strong, nonatomic) NSString *menuName;

/**
 An image that is displayed alongside this submenu item
 */
@property (strong, nonatomic, nullable) SDLImage *menuIcon;

/**
 The sub-menu layout. See available menu layouts on SDLWindowCapability.menuLayoutsAvailable. Defaults to LIST.
 */
@property (strong, nonatomic, nullable) SDLMenuLayout menuLayout;

/**
 * Unique ID of the sub menu the command will be added to. If not provided or 0, it will be provided to the top level of the in application menu.
 * {"default_value": 0, "max_value": 2000000000, "min_value": 0}
 *
 * @since SDL 7.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *parentID;

@end

NS_ASSUME_NONNULL_END
