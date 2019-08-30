//
//  SDLCreateWindow.h
//  SmartDeviceLink
//

#import "SDLRPCRequest.h"
#import "SDLWindowType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Create a new window on the display with the specified window type.
 @discussion Windows of different types like MAIN or WIDGET windows can be created. Every application will have a pre-created MAIN window available. A widget is a small window that the app can create to provide information and soft buttons for quick app control. Widgets can be created depending on the capabilities of the system. Widgets can be associated with a specific App Service type such as `MEDIA` or `NAVIGATION`. As an example if a `MEDIA` app becomes active, this app becomes audible and is allowed to play audio. If the media app has created a widget with `MEDIA` type associated, this widget will automatically be activated together with the app.
 
 @since SDL 6.0
 */
@interface SDLCreateWindow : SDLRPCRequest


/**
 Constructor with the required parameters

 @param windowId The type of the window to be created. Main window or widget.
 @param windowName The window name to be used by the HMI. @see windowName
 @param windowType The type of the window to be created. Main window or widget.
 */
- (instancetype)initWithId:(NSUInteger)windowId windowName:(NSString *)windowName windowType:(SDLWindowType)windowType;

/**
 Convinience constructor with all the parameters.

 @param windowId The type of the window to be created. Main window or widget.
 @param windowName The window name to be used by the HMI. @see windowName
 @param windowType The type of the window to be created. Main window or widget.
 @param associatedServiceType Allows an app to create a widget related to a specific service type. @see associatedServiceType
 @param duplicateUpdatesFromWindowID  Optional parameter. Specify whether the content sent to an existing window should be duplicated to the created window. If there isn't a window with the ID, the request will be rejected with `INVALID_DATA`.
 */
- (instancetype)initWithId:(NSUInteger)windowId windowName:(NSString *)windowName windowType:(SDLWindowType)windowType associatedServiceType:(nullable NSString *)associatedServiceType duplicateUpdatesFromWindowID:(NSUInteger)duplicateUpdatesFromWindowID;


/**
 A unique ID to identify the window.
 @discussion The value of '0' will always be the default main window on the main display and should not be used in this context as it will already be created for the app. See PredefinedWindows enum. Creating a window with an ID that is already in use will be rejected with `INVALID_ID`.
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *windowID;

/**
 The window name to be used by the HMI.
 @discussion The name of the pre-created default window will match the app name. Multiple apps can share the same window name except for the default main window. Creating a window with a name which is already in use by the app will result in `DUPLICATE_NAME`. MaxLength 100.
 */
@property (strong, nonatomic) NSString *windowName;

/**
 The type of the window to be created. Main window or widget.
 */
@property (strong, nonatomic) SDLWindowType type;

/**
 Allows an app to create a widget related to a specific service type.
 @discussion As an example if a `MEDIA` app becomes active, this app becomes audible and is allowed to play audio. Actions such as skip or play/pause will be directed to this active media app. In case of widgets, the system can provide a single "media" widget which will act as a placeholder for the active media app. It is only allowed to have one window per service type. This means that a media app can only have a single MEDIA widget. Still the app can create widgets omitting this parameter. Those widgets would be available as app specific widgets that are permanently included in the HMI. This parameter is related to widgets only. The default main window, which is pre-created during app registration, will be created based on the HMI types specified in the app registration request.
 */
@property (strong, nonatomic, nullable) NSString *associatedServiceType;


/**
 Optional parameter. Specify whether the content sent to an existing window should be duplicated to the created window. If there isn't a window with the ID, the request will be rejected with `INVALID_DATA`.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLUInt> *duplicateUpdatesFromWindowID;

@end

NS_ASSUME_NONNULL_END
