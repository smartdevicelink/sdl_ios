//
//  SDLWindowType.h
//  SmartDeviceLink

#import "SDLEnum.h"
/**
 The type of the window to be created. Main window or widget.
 
 @since SDL 6.0
 */
typedef SDLEnum SDLWindowType NS_TYPED_ENUM;

/**
 This window type describes the main window on a display.
 */
extern SDLWindowType const SDLWindowTypeMain;

/**
 A widget is a small window that the app can create to provide information and soft buttons for quick app control.
 */
extern SDLWindowType const SDLWindowTypeWidget;
