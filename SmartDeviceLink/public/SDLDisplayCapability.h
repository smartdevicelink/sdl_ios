//
//  SDLDisplayCapability.h
//  SmartDeviceLink

#import "SDLRPCStruct.h"

@class SDLWindowCapability;
@class SDLWindowTypeCapabilities;

NS_ASSUME_NONNULL_BEGIN

/**
 Contain the display related information and all windows related to that display.
 
 @since SDL 6.0
 */
@interface SDLDisplayCapability : SDLRPCStruct

/**
 Init with required properties
 
 @param displayName Name of the display.
 */
- (instancetype)initWithDisplayName:(NSString *)displayName;

/**
 Init with all the properities

 @param displayName Name of the display.
 @param windowCapabilities Contains a list of capabilities of all windows related to the app. @see windowCapabilities
 @param windowTypeSupported Informs the application how many windows the app is allowed to create per type.
 */
- (instancetype)initWithDisplayName:(NSString *)displayName windowCapabilities:(nullable NSArray<SDLWindowCapability *> *)windowCapabilities windowTypeSupported:(nullable NSArray<SDLWindowTypeCapabilities *> *)windowTypeSupported;


/**
 Name of the display.
 */
@property (strong, nonatomic, nullable) NSString *displayName;

/**
 Informs the application how many windows the app is allowed to create per type.
 
 Min size 1
 Max size 100
 */
@property (strong, nonatomic, nullable) NSArray<SDLWindowTypeCapabilities *> *windowTypeSupported;

/**
 Contains a list of capabilities of all windows related to the app. Once the app has registered the capabilities of all windows will be provided, but GetSystemCapability still allows requesting window capabilities of all windows.
 
 After registration, only windows with capabilities changed will be included. Following cases will cause only affected windows to be included:
 
 1. App creates a new window. After the window is created, a system capability notification will be sent related only to the created window.
 2. App sets a new template to the window. The new template changes window capabilties. The notification will reflect those changes to the single window.
 
 Min size 1, Max size 1000
 */
@property (strong, nonatomic, nullable) NSArray<SDLWindowCapability *> *windowCapabilities;

@end

NS_ASSUME_NONNULL_END
