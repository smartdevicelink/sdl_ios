//
//  SDLCloseApplication.h
//  SmartDeviceLink
//
//  Created by Nicole on 7/9/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Used by an app to set itself to a HMILevel of NONE. The app will close but is still registered. If the app is a navigation app it will not be used as the preferred mobile-nav application anymore.
 */
@interface SDLCloseApplication : SDLRPCRequest

@end

NS_ASSUME_NONNULL_END
