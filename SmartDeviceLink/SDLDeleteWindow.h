//
//  SDLDeleteWindow.h
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 11.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * Deletes previously created window of the SDL application.
 *
 */
@interface SDLDeleteWindow : SDLRPCRequest

/**
 * A unique ID to identify the window.
 * The value of '0' will always be the default main window on the main display and cannot be deleted.
 * @see PredefinedWindows enum.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *windowID;

@end

NS_ASSUME_NONNULL_END
