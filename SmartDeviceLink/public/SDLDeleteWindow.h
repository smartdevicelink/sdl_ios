//
//  SDLDeleteWindow.h
//  SmartDeviceLink

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Deletes previously created window of the SDL application.
 
 @since SDL 6.0
 */
@interface SDLDeleteWindow : SDLRPCRequest

/**
 @param windowId A unique ID to identify the window. The value of '0' will always be the default main window on the main display and cannot be deleted.
 */
- (instancetype)initWithId:(NSUInteger)windowId;

/**
 A unique ID to identify the window.
 
 The value of '0' will always be the default main window on the main display and cannot be deleted.
 
 @see PredefinedWindows enum.
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *windowID;

@end

NS_ASSUME_NONNULL_END
