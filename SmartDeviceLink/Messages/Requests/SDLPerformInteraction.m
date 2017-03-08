//  SDLPerformInteraction.m
//


#import "SDLPerformInteraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformInteraction

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformInteraction]) {
    }
    return self;
}

- (instancetype)initWithInteractionChoiceSetId:(UInt16)interactionChoiceSetId {
    return [self initWithInteractionChoiceSetIdList:@[@(interactionChoiceSetId)]];
}

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID {
    self = [self initWithInteractionChoiceSetId:interactionChoiceSetID];
    if (!self) {
        return nil;
    }
    
    self.initialPrompt = [SDLTTSChunk textChunksFromString:initialPrompt];
    self.initialText = initialText;
    
    return self;
}

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    self = [self initWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetID:interactionChoiceSetID];
    if (!self) {
        return nil;
    }
    
    self.vrHelp = [vrHelp mutableCopy];
    
    return self;
}

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSString *)helpPrompt timeoutPrompt:(nullable NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout {
    return [self initWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpPrompt:helpPrompt timeoutPrompt:timeoutPrompt interactionMode:interactionMode timeout:timeout vrHelp:nil];
}

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSString *)helpPrompt timeoutPrompt:(nullable NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    NSArray *initialChunks = [SDLTTSChunk textChunksFromString:initialPrompt];
    NSArray *helpChunks = [SDLTTSChunk textChunksFromString:helpPrompt];
    NSArray *timeoutChunks = [SDLTTSChunk textChunksFromString:timeoutPrompt];
    return [self initWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:interactionMode timeout:timeout vrHelp:vrHelp];
}

- (instancetype)initWithInitialChunks:(nullable NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(nullable NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(nullable NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:interactionMode timeout:timeout vrHelp:vrHelp interactionLayout:nil];
}

- (instancetype)initWithInitialChunks:(nullable NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(nullable NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(nullable NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(nullable SDLLayoutMode)layout {
    self = [self initWithInteractionChoiceSetIdList:interactionChoiceSetIDList];
    if (!self) {
        return nil;
    }

    self.initialPrompt = [initialChunks mutableCopy];
    self.initialText = initialText;
    self.helpPrompt = [helpChunks mutableCopy];
    self.timeoutPrompt = [timeoutChunks mutableCopy];
    self.interactionMode = interactionMode;
    self.timeout = @(timeout);
    self.vrHelp = [vrHelp mutableCopy];
    self.interactionLayout = layout;

    return self;
}

- (instancetype)initWithInteractionChoiceSetIdList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIdList {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.interactionChoiceSetIDList = [interactionChoiceSetIdList mutableCopy];

    return self;
}

- (void)setInitialText:(NSString *)initialText {
    [parameters sdl_setObject:initialText forName:SDLNameInitialText];
}

- (NSString *)initialText {
    return [parameters sdl_objectForName:SDLNameInitialText];
}

- (void)setInitialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt {
    [parameters sdl_setObject:initialPrompt forName:SDLNameInitialPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)initialPrompt {
    return [parameters sdl_objectsForName:SDLNameInitialPrompt ofClass:SDLTTSChunk.class];
}

- (void)setInteractionMode:(SDLInteractionMode)interactionMode {
    [parameters sdl_setObject:interactionMode forName:SDLNameInteractionMode];
}

- (SDLInteractionMode)interactionMode {
    return [parameters sdl_objectForName:SDLNameInteractionMode];
}

- (void)setInteractionChoiceSetIDList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    [parameters sdl_setObject:interactionChoiceSetIDList forName:SDLNameInteractionChoiceSetIdList];
}

- (NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    return [parameters sdl_objectForName:SDLNameInteractionChoiceSetIdList];
}

- (void)setHelpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    [parameters sdl_setObject:helpPrompt forName:SDLNameHelpPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    return [parameters sdl_objectsForName:SDLNameHelpPrompt ofClass:SDLTTSChunk.class];
}

- (void)setTimeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    [parameters sdl_setObject:timeoutPrompt forName:SDLNameTimeoutPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    return [parameters sdl_objectsForName:SDLNameTimeoutPrompt ofClass:SDLTTSChunk.class];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLNameTimeout];
}

- (void)setVrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    [parameters sdl_setObject:vrHelp forName:SDLNameVRHelp];
}

- (nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [parameters sdl_objectsForName:SDLNameVRHelp ofClass:SDLVRHelpItem.class];
}

- (void)setInteractionLayout:(nullable SDLLayoutMode)interactionLayout {
    [parameters sdl_setObject:interactionLayout forName:SDLNameInteractionLayout];
}

- (nullable SDLLayoutMode)interactionLayout {
    return [parameters sdl_objectForName:SDLNameInteractionLayout];
}

@end

NS_ASSUME_NONNULL_END
