//
//  SDLChoiceSet.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLChoiceSetDelegate;
@class SDLChoiceCell;
@class SDLTTSChunk;
@class SDLVRHelpItem;

NS_ASSUME_NONNULL_BEGIN

/**
 Notifies the subscriber that the choice set should be cancelled.
 */
typedef void (^SDLChoiceSetCanceledHandler)(void);

/// The layout to use when a choice set is displayed
typedef NS_ENUM(NSUInteger, SDLChoiceSetLayout) {
    /// Menu items will be displayed in a list
    SDLChoiceSetLayoutList,

    /// Menu items will be displayed as a tiled list
    SDLChoiceSetLayoutTiles,
};

/**
 The choice set to be displayed to the user. Contains a list of selectable options.
 */
@interface SDLChoiceSet: NSObject

/**
 Set this to change the default timeout for all choice sets. If a timeout is not set on an individual choice set object (or if it is set to 0.0), then it will use this timeout instead. See `timeout` for more details. If this is not set by you, it will default to 10 seconds.
 */
@property (class, assign, nonatomic) NSTimeInterval defaultTimeout;

/**
 Set this to change the default layout for all choice sets. If a layout is not set on an individual choice set object, then it will use this layout instead. See `layout` for more details. If this is not set by you, it will default to `SDLChoiceSetLayoutList`.
 */
@property (class, assign, nonatomic) SDLChoiceSetLayout defaultLayout;

/**
 Maps to PerformInteraction.initialText. The title of the choice set, and/or the initial text on a keyboard prompt.
 */
@property (copy, nonatomic) NSString *title;

/**
 Maps to PerformInteraction.initialPrompt. The initial prompt spoken to the user at the start of an interaction.
 */
@property (copy, nonatomic, nullable) NSArray<SDLTTSChunk *> *initialPrompt;

/**
 Maps to PerformInteraction.interactionLayout. Whether the presented choices are arranged as a set of tiles or a list.
 */
@property (assign, nonatomic) SDLChoiceSetLayout layout;

/**
 Maps to PerformInteraction.timeout. This applies only to a manual selection (not a voice selection, which has its timeout handled by the system). Defaults to `defaultTimeout`.
 */
@property (assign, nonatomic) NSTimeInterval timeout;

/**
 Maps to PerformInteraction.timeoutPrompt. This text is spoken when a VR interaction times out. If this set is presented in a manual (non-voice) only interaction, this will be ignored.
 */
@property (copy, nonatomic, nullable) NSArray<SDLTTSChunk *> *timeoutPrompt;

/**
 Maps to PerformInteraction.helpPrompt. This is the spoken string when a user speaks "help" when the interaction is occurring.
 */
@property (copy, nonatomic, nullable) NSArray<SDLTTSChunk *> *helpPrompt;

/**
 Maps to PerformInteraction.vrHelp. This is a list of help text presented to the user when they are in a voice recognition interaction from your choice set of options. If this set is presented in a touch only interaction, this will be ignored.

 @note that while SDLVRHelpItem's position will be automatically set based on position in the array, the image will need to uploaded by you before use using SDLFileManager.
 */
@property (copy, nonatomic, nullable) NSArray<SDLVRHelpItem *> *helpList;

/**
 The delegate of this choice set, called when the user interacts with it.
 */
@property (weak, nonatomic) id<SDLChoiceSetDelegate> delegate;

/**
 The choices to be displayed to the user within this choice set. These choices could match those already preloaded via `SDLScreenManager preloadChoices:withCompletionHandler:`.

 This is limited to 100 items. If you attempt to set more than 100 items, the set will not have any items (this array will be empty).
 */
@property (copy, nonatomic) NSArray<SDLChoiceCell *> *choices;

/**
 Initialize with a title, delegate, and choices. It will use the default timeout and layout, all other properties (such as prompts) will be `nil`.

 @param title The choice set's title
 @param delegate The choice set delegate called after the user has interacted with your choice set
 @param choices The choices to be displayed to the user for interaction
 @return The choice set
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate choices:(NSArray<SDLChoiceCell *> *)choices;

/**
 Initializer with all possible properties.

 @param title The choice set's title
 @param delegate The choice set delegate called after the user has interacted with your choice set
 @param layout The layout of choice options (Manual/touch only)
 @param timeout The timeout of a touch interaction (Manual/touch only)
 @param initialPrompt A voice prompt spoken to the user when this set is displayed
 @param timeoutPrompt A voice prompt spoken to the user when the set times out (Voice only)
 @param helpPrompt A voice prompt spoken to the user when the user asks for "help"
 @param helpList A table list of text and images shown to the user during a voice recognition session for this choice set (Voice only)
 @param choices The list of choices presented to the user either as a manual/touch interaction or via the user's voice
 @return The choice set
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate layout:(SDLChoiceSetLayout)layout timeout:(NSTimeInterval)timeout initialPromptString:(nullable NSString *)initialPrompt timeoutPromptString:(nullable NSString *)timeoutPrompt helpPromptString:(nullable NSString *)helpPrompt vrHelpList:(nullable NSArray<SDLVRHelpItem *> *)helpList choices:(NSArray<SDLChoiceCell *> *)choices;

/**
 Initializer with all possible properties.

 @param title The choice set's title
 @param delegate The choice set delegate called after the user has interacted with your choice set
 @param layout The layout of choice options (Manual/touch only)
 @param timeout The timeout of a touch interaction (Manual/touch only)
 @param initialPrompt A voice prompt spoken to the user when this set is displayed
 @param timeoutPrompt A voice prompt spoken to the user when the set times out (Voice only)
 @param helpPrompt A voice prompt spoken to the user when the user asks for "help"
 @param helpList A table list of text and images shown to the user during a voice recognition session for this choice set (Voice only)
 @param choices The list of choices presented to the user either as a manual/touch interaction or via the user's voice
 @return The choice set
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate layout:(SDLChoiceSetLayout)layout timeout:(NSTimeInterval)timeout initialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt vrHelpList:(nullable NSArray<SDLVRHelpItem *> *)helpList choices:(NSArray<SDLChoiceCell *> *)choices;


/**
 Cancels the choice set. If the choice set has not yet been sent to Core, it will not be sent. If the choice set is already presented on Core, the choice set will be immediately dismissed. Canceling an already presented choice set will only work if connected to Core versions 6.0+. On older versions of Core, the choice set will not be dismissed.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
