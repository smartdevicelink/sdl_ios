//  SDLPerformInteraction.h
//


#import "SDLRPCRequest.h"

@class SDLInteractionMode;
@class SDLLayoutMode;
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
@interface SDLPerformInteraction : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLPerformInteraction object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLPerformInteraction object indicated by the NSMutableDictionary
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithInteractionChoiceSetId:(UInt16)interactionChoiceSetId;

- (instancetype)initWithInteractionChoiceSetIdList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIdList;

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID;

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp;

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode *)interactionMode timeout:(UInt16)timeout;

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode *)interactionMode timeout:(UInt16)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp;

- (instancetype)initWithInitialChunks:(NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList helpChunks:(NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(NSArray *)timeoutChunks interactionMode:(SDLInteractionMode *)interactionMode timeout:(UInt16)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp;

/**
 * @abstract The Text that Displayed when the interaction begins. This text may
 * be overlaid by the "Listening" prompt during the interaction. Text is
 * displayed on first line of multiline display, and is centered. If text
 * does not fit on line, it will be truncated
 */
@property (strong) NSString *initialText;
/**
 * @abstract An array of one or more TTSChunks that, taken together, specify
 * what is to be spoken to the user at the start of an interaction
 */
@property (strong) NSMutableArray *initialPrompt;
/**
 * @abstract The Indicates mode that indicate how user selects interaction
 * choice. User can choose either by voice (VR_ONLY), by visual selection
 * from the menu (MANUAL_ONLY), or by either mode (BOTH)
 */
@property (strong) SDLInteractionMode *interactionMode;
/**
 * @abstract A Vector<Integer> value representing an Array of one or more Choice
 * Set IDs
 */
@property (strong) NSMutableArray *interactionChoiceSetIDList;
/**
 * @abstract A Vector<TTSChunk> which taken together, specify the help phrase to
 * be spoken when the user says "help" during the VR session
 */
@property (strong) NSMutableArray *helpPrompt;
/**
 * @abstract An array of TTSChunks which, taken together, specify the phrase to
 * be spoken when the listen times out during the VR session
 */
@property (strong) NSMutableArray *timeoutPrompt;
/**
 * @abstract An Integer value representing the amount of time, in milliseconds,
 * SDL will wait for the user to make a choice (VR or Menu)
 */
@property (strong) NSNumber *timeout;
/**
 * @abstract A Voice recognition Help, which is a suggested VR Help Items to
 * display on-screen during Perform Interaction
 * @since SmartDeviceLink 2.0
 */
@property (strong) NSMutableArray *vrHelp;
@property (strong) SDLLayoutMode *interactionLayout;

@end
