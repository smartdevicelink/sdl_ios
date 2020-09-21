//  SDLImage.h
//

#import "SDLRPCMessage.h"

#import "SDLImageType.h"
#import "SDLStaticIconName.h"

/**
 * Specifies which image shall be used e.g. in SDLAlerts or on SDLSoftbuttons provided the display supports it.
 * 
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLImage : SDLRPCStruct

/**
 *  Convenience init for displaying a dynamic image. The image must be uploaded to SDL Core before being displayed.
 *
 *  @param name        The unique name used to upload the image to SDL Core
 *  @param imageType   Describes whether the image is static or dynamic
 *  @param isTemplate  Whether or not the image is a template that can be (re)colored by the SDL HMI. Static images are templates by default.
 *  @return            A SDLImage object
 */
- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType)imageType isTemplate:(BOOL)isTemplate;

/**
 *  Convenience init for displaying a dynamic image. The image must be uploaded to SDL Core before being displayed.
 *
 *  @param name        The unique name used to upload the image to SDL Core
 *  @param isTemplate  Whether or not the image is a template that can be (re)colored by the SDL HMI
 *  @return            A SDLImage object
 */
- (instancetype)initWithName:(NSString *)name isTemplate:(BOOL)isTemplate;

/**
 *  Convenience init for displaying a static image. Static images are already on-board SDL Core and can be used by providing the image's value.
 *
 *  @param staticImageValue    The image value assigned to the static image
 *  @return                    A SDLImage object
 */
- (instancetype)initWithStaticImageValue:(UInt16)staticImageValue;

/**
 *  Convenience init for displaying a static image. Static images are already on-board SDL Core and can be used by providing the image's value.
 *
 *  @param staticIconName      A SDLStaticIconName value
 *  @return                    A SDLImage object
 */
- (instancetype)initWithStaticIconName:(SDLStaticIconName)staticIconName;

/**
 *  The static hex icon value or the binary image file name identifier (sent by SDLPutFile)
 *
 *  Required, max length = 65535
 */
@property (strong, nonatomic) NSString *value;

/**
 *  Describes whether the image is static or dynamic
 *
 *  Required
 */
@property (strong, nonatomic) SDLImageType imageType;

/**
 *  Indicates that this image can be (re)colored by the HMI to best fit the current color scheme.
 */
@property (assign, nonatomic) NSNumber<SDLBool> *isTemplate;

@end

NS_ASSUME_NONNULL_END
