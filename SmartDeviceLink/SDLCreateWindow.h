//
//  SDLCreateWindow.h
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 15.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLWindowType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCreateWindow : SDLRPCRequest


/**
 *  Create a new window on the display with the specified window type.
 *
 *  @param windowId                      A unique ID to identify the window. The value of '0' will always be the default main window on the main
 *                                       display and should not be used in this context as it will already be created for the app. See PredefinedWindows enum.
 *                                       Creating a window with an ID that is already in use will be rejected with `INVALID_ID`.
 *  @param windowName                    The window name to be used by the HMI. The name of the pre-created default window will match the app name.
 *                                       Multiple apps can share the same window name except for the default main window.
 *                                       Creating a window with a name which is already in use by the app will result in `DUPLICATE_NAME`.
 *  @param windowType                    The type of the window to be created. Main window or widget.
 */
- (instancetype)initWithId:(UInt32)windowId windowName:(NSString *)windowName windowType:(SDLWindowType)windowType NS_DESIGNATED_INITIALIZER;

/**
 *  Create a new window on the display with the specified window type.
 *
 *  @param windowId                      A unique ID to identify the window. The value of '0' will always be the default main window on the main
 *                                       display and should not be used in this context as it will already be created for the app. See PredefinedWindows enum.
 *                                       Creating a window with an ID that is already in use will be rejected with `INVALID_ID`.
 *  @param windowName                    The window name to be used by the HMI. The name of the pre-created default window will match the app name.
 *                                       Multiple apps can share the same window name except for the default main window.
 *                                       Creating a window with a name which is already in use by the app will result in `DUPLICATE_NAME`.
 *  @param windowType                    The type of the window to be created. Main window or widget.
 *
 *  @param associatedServiceType         Allows an app to create a widget related to a specific service type.
 *                                       As an example if a `MEDIA` app becomes active, this app becomes audible and is allowed to play audio.
 *                                       Actions such as skip or play/pause will be directed to this active media app.
 *                                       In case of widgets, the system can provide a single "media" widget which will act as a placeholder for the active media app.
 *                                       It is only allowed to have one window per service type. This means that a media app can only have a single MEDIA widget.
 *                                       Still the app can create widgets omitting this parameter.
 *                                       Those widgets would be available as app specific widgets that are permanently included in the HMI.
 */
- (instancetype)initWithId:(UInt32)windowId windowName:(NSString *)windowName windowType:(SDLWindowType)windowType associatedServiceType:(nullable NSString *)associatedServiceType;



/**
 *  Create a new window on the display with the specified window type.
 *
 *  @param windowId                      A unique ID to identify the window. The value of '0' will always be the default main window on the main
 *                                       display and should not be used in this context as it will already be created for the app. See PredefinedWindows enum.
 *                                       Creating a window with an ID that is already in use will be rejected with `INVALID_ID`.
 *  @param windowName                    The window name to be used by the HMI. The name of the pre-created default window will match the app name.
 *                                       Multiple apps can share the same window name except for the default main window.
 *                                       Creating a window with a name which is already in use by the app will result in `DUPLICATE_NAME`.
 *  @param windowType                    The type of the window to be created. Main window or widget.
 *
 *  @param associatedServiceType         Allows an app to create a widget related to a specific service type.
 *                                       As an example if a `MEDIA` app becomes active, this app becomes audible and is allowed to play audio.
 *                                       Actions such as skip or play/pause will be directed to this active media app.
 *                                       In case of widgets, the system can provide a single "media" widget which will act as a placeholder for the active media app.
 *                                       It is only allowed to have one window per service type. This means that a media app can only have a single MEDIA widget.
 *                                       Still the app can create widgets omitting this parameter.
 *                                       Those widgets would be available as app specific widgets that are permanently included in the HMI.
 *  @param duplicateUpdatesFromWindowID  Specify whether the content sent to an existing window should be duplicated to the created window.
 *                                       If there isn't a window with the ID, the request will be rejected with `INVALID_DATA`.
 */
- (instancetype)initWithId:(UInt32)windowId windowName:(NSString *)windowName windowType:(SDLWindowType)windowType associatedServiceType:(nullable NSString *)associatedServiceType duplicateUpdatesFromWindowID:(UInt32)duplicateUpdatesFromWindowID;


/**
 *
 *
 */
@property (strong, nonatomic) NSNumber<SDLInt> *windowID;

/**
 *
 *
 */
@property (strong, nonatomic) NSString *windowName;

/**
 *
 *
 */
@property (strong, nonatomic) SDLWindowType type;

/**
 *
 *
 */
@property (strong, nonatomic, nullable) NSString *associatedServiceType;


/**
 *
 *
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *duplicateUpdatesFromWindowID;

@end

NS_ASSUME_NONNULL_END
