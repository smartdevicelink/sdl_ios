//  SDLPerformInteraction.h
//

#import "SDLRPCRequest.h"

#import "SDLInteractionMode.h"
#import "SDLLayoutMode.h"

@class SDLTTSChunk;
@class SDLVRHelpItem;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Performs an application-initiated interaction in which the user can select a choice from the passed choice set. For instance, an application may use a `PerformInteraction` to ask a user to say the name of a song to play. The user's response is only valid if it appears in the specified choice set.
 *
 *  If connecting to SDL Core v.6.0+, the perform interaction can be cancelled programatically using the `cancelID`. On older versions of SDL Core, the perform interaction will persist until the user has interacted with the perform interaction or the specified timeout has elapsed.
 *
 *  @see SDLCreateInteractionChoiceSet, SDLDeleteInteractionChoiceSet
 *
 *  @since SDL 1.0
 */
@interface SDLPerformInteraction : SDLRPCRequest

/**
 *  Convenience init for creating a basic display or voice-recognition menu.
 *
 *  @param initialText                  Text to be displayed first
 *  @param interactionMode              Indicates the method in which the user is notified and uses the interaction
 *  @param interactionChoiceSetIDList   List of interaction choice set IDs to use with an interaction
 *  @param cancelID                     An ID for this specific perform interaction to allow cancellation through the `CancelInteraction` RPC
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialText:(NSString *)initialText interactionMode:(SDLInteractionMode)interactionMode interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList cancelID:(UInt32)cancelID;

/**
 *  Convenience init for setting all parameters of a display or voice-recognition menu.
 *
 *  @param initialText                  Text to be displayed first
 *  @param initialPrompt                The initial prompt spoken to the user at the start of an interaction
 *  @param interactionMode              The method in which the user is notified and uses the interaction (voice, visual or both)
 *  @param interactionChoiceSetIDList   List of interaction choice set IDs to use with an interaction
 *  @param helpPrompt                   The spoken text when a user speaks "help" when the interaction is occurring
 *  @param timeoutPrompt                The text spoken when a VR interaction times out
 *  @param timeout                      Timeout in milliseconds
 *  @param vrHelp                       Suggested voice recognition help items to display on-screen during a perform interaction
 *  @param interactionLayout            For touchscreen interactions, the mode of how the choices are presented
 *  @param cancelID                     An ID for this specific perform interaction to allow cancellation through the `CancelInteraction` RPC.
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialText:(NSString *)initialText initialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt interactionMode:(SDLInteractionMode)interactionMode interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt timeout:(UInt16)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(nullable SDLLayoutMode)interactionLayout cancelID:(UInt32)cancelID;

/**
 *  Convenience init for setting the a single visual or voice-recognition menu choice.
 *
 *  @param interactionChoiceSetId       Single interaction choice set ID to use with an interaction
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInteractionChoiceSetId:(UInt16)interactionChoiceSetId __deprecated_msg("Use initWithInitialText:interactionMode:interactionChoiceSetIDList:cancelID: instead");

/**
 *  Convenience init for setting the a visual or voice-recognition menu choices.
 *
 *  @param interactionChoiceSetIdList   List of interaction choice set IDs to use with an interaction
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInteractionChoiceSetIdList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIdList __deprecated_msg("Use initWithInitialText:interactionMode:interactionChoiceSetIDList:cancelID: instead");

/**
 *  Convenience init for creating a visual or voice-recognition menu with one choice.
 *
 *  @param initialPrompt                The initial prompt spoken to the user at the start of an interaction
 *  @param initialText                  Text to be displayed first
 *  @param interactionChoiceSetID       Single interaction choice set ID to use with an interaction
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID __deprecated_msg("Use initWithInitialText:interactionMode:interactionChoiceSetIDList:cancelID: instead");

/**
 *  Convenience init for creating a visual or voice-recognition menu with one choice and VR help items.
 *
 *  @param initialPrompt                The initial prompt spoken to the user at the start of an interaction
 *  @param initialText                  Text to be displayed first
 *  @param interactionChoiceSetID       Single interaction choice set ID to use with an interaction
 *  @param vrHelp                       Suggested voice recognition help items to display on-screen during a perform interaction
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp __deprecated_msg("Use initWithInitialText:initialPrompt:interactionMode:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:timeout:vrHelp:interactionLayout:cancelID: instead");

/**
 *  Convenience init for creating a visual or voice-recognition menu using the default display layout and VR help items. Prompts are created from the passed strings.
 *
 *  @param initialText                  Text to be displayed first
 *  @param initialPrompt                The initial prompt spoken to the user at the start of an interaction
 *  @param interactionMode              The method in which the user is notified and uses the interaction (voice, visual or both)
 *  @param interactionChoiceSetIDList   List of interaction choice set IDs to use with an interaction
 *  @param helpPrompt                   The spoken text when a user speaks "help" when the interaction is occurring
 *  @param timeoutPrompt                The text spoken when a VR interaction times out
 *  @param timeout                      Timeout in milliseconds
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSString *)helpPrompt timeoutPrompt:(nullable NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout __deprecated_msg("Use initWithInitialText:initialPrompt:interactionMode:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:timeout:vrHelp:interactionLayout:cancelID: instead");

/**
 *  Convenience init for creating a visual or voice-recognition menu using the default display layout. Prompts are created from the passed strings.
 *
 *  @param initialText                  Text to be displayed first
 *  @param initialPrompt                The initial prompt spoken to the user at the start of an interaction
 *  @param interactionMode              The method in which the user is notified and uses the interaction (voice, visual or both)
 *  @param interactionChoiceSetIDList   List of interaction choice set IDs to use with an interaction
 *  @param helpPrompt                   The spoken text when a user speaks "help" when the interaction is occurring
 *  @param timeoutPrompt                The text spoken when a VR interaction times out
 *  @param timeout                      Timeout in milliseconds
 *  @param vrHelp                       Suggested voice recognition help items to display on-screen during a perform interaction
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSString *)helpPrompt timeoutPrompt:(nullable NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp __deprecated_msg("Use initWithInitialText:initialPrompt:interactionMode:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:timeout:vrHelp:interactionLayout:cancelID: instead");

/**
 *  Convenience init for creating a visual or voice-recognition menu using the default display layout.
 *
 *  @param initialText                  Text to be displayed first
 *  @param initialChunks                The initial prompt spoken to the user at the start of an interaction
 *  @param interactionMode              The method in which the user is notified and uses the interaction (voice, visual or both)
 *  @param interactionChoiceSetIDList   List of interaction choice set IDs to use with an interaction
 *  @param helpChunks                   The spoken text when a user speaks "help" when the interaction is occurring
 *  @param timeoutChunks                The text spoken when a VR interaction times out
 *  @param timeout                      Timeout in milliseconds
 *  @param vrHelp                       Suggested voice recognition help items to display on-screen during a perform interaction
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialChunks:(nullable NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(nullable NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(nullable NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp __deprecated_msg("Use initWithInitialText:initialPrompt:interactionMode:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:timeout:vrHelp:interactionLayout:cancelID: instead");

/**
 *  Convenience init for setting all parameters of a visual or voice-recognition menu.
 *
 *  @param initialText                  Text to be displayed first
 *  @param initialChunks                The initial prompt spoken to the user at the start of an interaction
 *  @param interactionMode              The method in which the user is notified and uses the interaction (voice, visual or both)
 *  @param interactionChoiceSetIDList   List of interaction choice set IDs to use with an interaction
 *  @param helpChunks                   The spoken text when a user speaks "help" when the interaction is occurring
 *  @param timeoutChunks                The text spoken when a VR interaction times out
 *  @param timeout                      Timeout in milliseconds
 *  @param vrHelp                       Suggested voice recognition help items to display on-screen during a perform interaction
 *  @param layout                       For touchscreen interactions, the mode of how the choices are presented
 *  @return                             An SDLPerformInteraction object
 */
- (instancetype)initWithInitialChunks:(nullable NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(nullable NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(nullable NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(nullable SDLLayoutMode)layout __deprecated_msg("Use initWithInitialText:initialPrompt:interactionMode:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:timeout:vrHelp:interactionLayout:cancelID: instead");

/**
 *  Text to be displayed first.
 *
 *  String, Required
 *
 *  @since SDL 1.0
 */
@property (strong, nonatomic) NSString *initialText;

/**
 *  This is the initial prompt spoken to the user at the start of an interaction.
 *
 *  Array of SDLTTSChunk, Optional, Array size: 1-100
 *
 *  @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *initialPrompt;

/**
 *  For application-requested interactions, this mode indicates the method in which the user is notified and uses the interaction. Users can choose either by voice (VR_ONLY), by visual selection from the menu (MANUAL_ONLY), or by either mode (BOTH)
 *
 *  SDLInteractionMode, Required
 *
 *  @since SDL 1.0
 */
@property (strong, nonatomic) SDLInteractionMode interactionMode;

/**
 *  List of interaction choice set IDs to use with an interaction.
 *
 *  Array of Integers, Required, Array size: 0-100, Min value: 0, Max value: 2000000000
 *
 *  @since SDL 1.0
 */
@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *interactionChoiceSetIDList;

/**
 *  Help text. This is the spoken text when a user speaks "help" when the interaction is occurring.
 *
 *  SDLTTSChunk, Optional
 *
 *  @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *helpPrompt;

/**
 *  Timeout text. This text is spoken when a VR interaction times out.
 *
 *  Array of SDLTTSChunk, Optional, Array size: 1-100
 *
 *  @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *timeoutPrompt;

/**
 *  Timeout in milliseconds. Applies only to the menu portion of the interaction. The VR timeout will be handled by the platform. If omitted a standard value of 10 seconds is used.
 *
 *  Integer, Optional, Min value: 5000, Max value: 100,000
 *
 *  @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;

/**
 *  Suggested voice recognition help items to display on-screen during a perform interaction. If omitted on supported displays, the default generated list of suggested choices shall be displayed.
 *
 *  SDLVRHelpItem, Optional
 *
 *  @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLVRHelpItem *> *vrHelp;

/**
 *  For touchscreen interactions, the layout mode of how the choices are presented.
 *
 *  SDLLayoutMode, Optional
 *
 *  @since SDL 3.0
 */
@property (nullable, strong, nonatomic) SDLLayoutMode interactionLayout;

/**
 *  An ID for this specific perform interaction to allow cancellation through the `CancelInteraction` RPC.
 *
 *  Integer, Optional
 *
 *  @see SDLCancelInteraction
 *  @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

@end

NS_ASSUME_NONNULL_END
