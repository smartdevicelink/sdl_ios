//
//  SDLOpenMenu.h
//  SmartDeviceLink
//
//  Created by Justin Gluck on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Used by an app to show the app's menu, typically this is used by a navigation app if the menu button is hidden.
 
 Added in SmartDeviceLink 6.0
 */
@interface SDLShowAppMenu : SDLRPCRequest

/**
 Creates a ShowAppMenu RPC to open the app menu directly to a AddSubMenu RPC's submenu.

 @param menuID The ID of the AddSubMenu to open
 @return SDLShowAppMenu RPCRequest
 */
- (instancetype)initWithMenuID:(UInt32)menuID;

/**
 A Menu ID that identifies the AddSubMenu to open if it correlates with the AddSubMenu menuID parameter. If not set the top level menu will be opened.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *menuID;

@end

NS_ASSUME_NONNULL_END
