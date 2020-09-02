//  SDLChoice.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


/**
 * A choice is an option which a user can select either via the menu or via voice recognition (VR) during an application initiated interaction.
 *
 * Since RPC 1.0
 */
NS_ASSUME_NONNULL_BEGIN

@interface SDLChoice : SDLRPCStruct

/**
Constructs a newly allocated SDLChangeRegistration object with the required parameters

@param choiceId the application-scoped identifier that uniquely identifies this choice
@param menuName text which appears in menu, representing this choice
@param vrCommands vr synonyms for this choice

@return An instance of the SDLChangeRegistration class.
*/
- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(nullable NSArray<NSString *> *)vrCommands;

/**
Constructs a newly allocated SDLChangeRegistration object with all parameters

@param choiceId the application-scoped identifier that uniquely identifies this choice
@param menuName text which appears in menu, representing this choice
@param vrCommands vr synonyms for this choice
@param image the image of the choice
@param secondaryText secondary text to display; e.g. address of POI in a search result entry
@param secondaryImage secondary image for choice
@param tertiaryText tertiary text to display; e.g. distance to POI for a search result entry

@return An instance of the SDLChangeRegistration class.
*/
- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(nullable NSArray<NSString *> *)vrCommands image:(nullable SDLImage *)image secondaryText:(nullable NSString *)secondaryText secondaryImage:(nullable SDLImage *)secondaryImage tertiaryText:(nullable NSString *)tertiaryText;

/**
 * The application-scoped identifier that uniquely identifies this choice
 * 
 * Required, Integer 0 - 65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *choiceID;

/**
 * Text which appears in menu, representing this choice
 *
 * Required, Max string length 500 chars
 */
@property (strong, nonatomic) NSString *menuName;

/**
 * VR synonyms for this choice
 *
 * Optional, Array of Strings, Array length 1 - 100, Max String length 99 chars
 *
 * @discussion, VR commands are optional beginning with SDL Core v.5.0. They are required for previous versions.
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *vrCommands;

/**
 * The image of the choice
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *image;

/**
 * Secondary text to display; e.g. address of POI in a search result entry
 *
 * Optional, Max String length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *secondaryText;

/**
 * Tertiary text to display; e.g. distance to POI for a search result entry
 *
 * Optional, Max String length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *tertiaryText;

/**
 * Secondary image for choice
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *secondaryImage;

@end

NS_ASSUME_NONNULL_END
