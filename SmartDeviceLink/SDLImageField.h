//  SDLImageField.h
//

#import "SDLRPCMessage.h"

#import "SDLFileType.h"
#import "SDLImageFieldName.h"

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

/**
 A struct used in DisplayCapabilities describing the capability of an image field
 */
@interface SDLImageField : SDLRPCStruct

/**
 The name that identifies the field.

 Required
 */
@property (strong, nonatomic) SDLImageFieldName name;

/**
 The image types that are supported in this field.

 Required
 */
@property (strong, nonatomic) NSArray<SDLFileType> *imageTypeSupported;

/**
 The image resolution of this field

 Optional
 */
@property (nullable, strong, nonatomic) SDLImageResolution *imageResolution;

/// Convenience initalizer for the ImageField RPC struct
/// @param name The name identifying this image field
/// @param imageTypeSupported The image data types this field supports
/// @param imageResolution The native resolution of this image field
- (instancetype)initWithName:(SDLImageFieldName)name imageTypeSupported:(NSArray<SDLFileType> *)imageTypeSupported imageResolution:(nullable SDLImageResolution *)imageResolution;

@end

NS_ASSUME_NONNULL_END
