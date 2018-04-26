//  SDLPerformInteraction.h
//


#import "SDLRPCRequest.h"

#import "SDLInteractionMode.h"
#import "SDLLayoutMode.h"

@class SDLTTSChunk;
@class SDLVRHelpItem;

/**
 * Performs an application-initiated interaction in which the user can select a
 * {@linkplain Choice} from among the specified Choice Sets. For instance, an
 * application may use a PerformInteraction to ask a user to say the name of a
 * song to play. The user's response is only valid if it appears in the
 * specified Choice Sets and is recognized by SDL
 * <p>
 * Function Group: Base
 * <p>
 * <b>HMILevel needs to be FULL</b>
 * </p>
 *
 * Since SmartDeviceLink 1.0<br/>
 * See SDLCreateInteractionChoiceSet SDLDeleteInteractionChoiceSet
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLPerformInteraction : SDLRPCRequest

- (instancetype)initWithInteractionChoiceSetId:(UInt16)interactionChoiceSetId;

- (instancetype)initWithInteractionChoiceSetIdList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIdList;

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID;

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp;

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSString *)helpPrompt timeoutPrompt:(nullable NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout;

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSString *)helpPrompt timeoutPrompt:(nullable NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp;

- (instancetype)initWithInitialChunks:(nullable NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(nullable NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(nullable NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp;

- (instancetype)initWithInitialChunks:(nullable NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(nullable NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(nullable NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(nullable SDLLayoutMode)layout;

/**
 * The Text that Displayed when the interaction begins. This text may
 * be overlaid by the "Listening" prompt during the interaction. Text is
 * displayed on first line of multiline display, and is centered. If text
 * does not fit on line, it will be truncated
 */
@property (strong, nonatomic) NSString *initialText;
/**
 * An array of one or more TTSChunks that, taken together, specify
 * what is to be spoken to the user at the start of an interaction
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *initialPrompt;
/**
 * The Indicates mode that indicate how user selects interaction
 * choice. User can choose either by voice (VR_ONLY), by visual selection
 * from the menu (MANUAL_ONLY), or by either mode (BOTH)
 */
@property (strong, nonatomic) SDLInteractionMode interactionMode;
/**
 * A Vector<Integer> value representing an Array of one or more Choice
 * Set IDs
 */
@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *interactionChoiceSetIDList;
/**
 * A Vector<TTSChunk> which taken together, specify the help phrase to
 * be spoken when the user says "help" during the VR session
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *helpPrompt;
/**
 * An array of TTSChunks which, taken together, specify the phrase to
 * be spoken when the listen times out during the VR session
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *timeoutPrompt;
/**
 * An Integer value representing the amount of time, in milliseconds,
 * SDL will wait for the user to make a choice (VR or Menu)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;
/**
 * A Voice recognition Help, which is a suggested VR Help Items to
 * display on-screen during Perform Interaction
 * @since SmartDeviceLink 2.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLVRHelpItem *> *vrHelp;
@property (nullable, strong, nonatomic) SDLLayoutMode interactionLayout;

@end

NS_ASSUME_NONNULL_END
