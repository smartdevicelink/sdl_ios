//
//  SDLWindowCapability.h
//  SmartDeviceLink

#import "SDLRPCStruct.h"
#import "SDLImageType.h"
#import "SDLMenuLayout.h"

@class SDLTextField;
@class SDLImageField;
@class SDLButtonCapabilities;
@class SDLSoftButtonCapabilities;


NS_ASSUME_NONNULL_BEGIN

/**
 Reflects content of DisplayCapabilities, ButtonCapabilities and SoftButtonCapabilities
 
 @since SDL 6.0
 */
@interface SDLWindowCapability : SDLRPCStruct

/**
 The specified ID of the window. Can be set to a predefined window, or omitted for the main window on the main display.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *windowID;

/**
 A set of all fields that support text data. @see TextField
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLTextField *> *textFields;

/**
 A set of all fields that support images. @see ImageField
 
 Size: min 0 max 1000
 */
@property (nullable, strong, nonatomic) NSArray<SDLImageField *> *imageFields;

/**
 Provides information about image types supported by the system.
 
 Size: min 0 max 1000
 */
@property (nullable, strong, nonatomic)  NSArray<SDLImageType> *imageTypeSupported;

/**
 A set of all window templates available on the head unit.
 
 Size: min 0 max 100
 */
@property (nullable, strong, nonatomic)  NSArray<NSString *> *templatesAvailable;

/**
 The number of on-window custom presets available (if any); otherwise omitted.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *numCustomPresetsAvailable;

/**
 The number of buttons and the capabilities of each on-window button.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 The number of soft buttons available on-window and the capabilities for each button.
 
 Size: min 1 max 100
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;

/**
 An array of available menu layouts. If this parameter is not provided, only the `LIST` layout is assumed to be available.

 Optional, array of 1 to 100, see SDLMenuLayout
 */
@property (nullable, strong, nonatomic) NSArray<SDLMenuLayout> *menuLayoutsAvailable;

@end

NS_ASSUME_NONNULL_END
