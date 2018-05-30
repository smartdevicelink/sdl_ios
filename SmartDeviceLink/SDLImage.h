//  SDLImage.h
//

#import "SDLRPCMessage.h"

#import "SDLImageType.h"

/**
 * Specifies which image shall be used e.g. in SDLAlerts or on SDLSoftbuttons provided the display supports it.
 * 
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLImage : SDLRPCStruct

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType)imageType __deprecated_msg("Use initWithName:ofType:isTemplate: instead");

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType)imageType isTemplate:(BOOL)isTemplate;

- (instancetype)initWithName:(NSString *)name __deprecated_msg("Use initWithName:isTemplate: instead");

- (instancetype)initWithName:(NSString *)name isTemplate:(BOOL)isTemplate;

- (instancetype)initWithStaticImageValue:(UInt16)staticImageValue __deprecated_msg("Use initWithStaticImageValue:isTemplate: instead");

- (instancetype)initWithStaticImageValue:(UInt16)staticImageValue isTemplate:(BOOL)isTemplate;

/**
 * The static hex icon value or the binary image file name identifier (sent by SDLPutFile)
 *
 * Required, max length = 65535
 */
@property (strong, nonatomic) NSString *value;

/**
 * Describes whether the image is static or dynamic
 *
 * Required
 */
@property (strong, nonatomic) SDLImageType imageType;

/**
 * Indicates that this image can be (re)colored by the HMI to best fit the current color scheme.
 */
@property (assign, nonatomic) NSNumber<SDLBool> *isTemplate;

@end

NS_ASSUME_NONNULL_END
