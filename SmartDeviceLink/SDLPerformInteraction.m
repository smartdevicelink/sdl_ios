//  SDLPerformInteraction.m
//


#import "SDLPerformInteraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVRHelpItem.h"

static UInt16 const SDLDefaultTimeout = 10000;

@implementation SDLPerformInteraction

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformInteraction]) {
    }
    return self;
}

- (instancetype)initWithInteractionChoiceSetId:(UInt16)interactionChoiceSetId {
    return [self initWithInteractionChoiceSetIdList:@[@(interactionChoiceSetId)]];
}

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID {
    return [self initWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetID:interactionChoiceSetID vrHelp:nil];
}

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(UInt16)interactionChoiceSetID vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetIDList:@[@(interactionChoiceSetID)] helpPrompt:nil timeoutPrompt:nil interactionMode:nil timeout:SDLDefaultTimeout vrHelp:vrHelp];
}

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout {
    return [self initWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpPrompt:helpPrompt timeoutPrompt:timeoutPrompt interactionMode:interactionMode timeout:timeout vrHelp:nil];
}

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp {
    NSMutableArray *initialChunks = [SDLTTSChunk textChunksFromString:initialPrompt];
    NSMutableArray *helpChunks = [SDLTTSChunk textChunksFromString:helpPrompt];
    NSMutableArray *timeoutChunks = [SDLTTSChunk textChunksFromString:timeoutPrompt];
    return [self initWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:interactionMode timeout:timeout vrHelp:vrHelp];
}

- (instancetype)initWithInitialChunks:(NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(NSArray *)helpChunks timeoutChunks:(NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:interactionMode timeout:timeout vrHelp:vrHelp interactionLayout:nil];
}

- (instancetype)initWithInitialChunks:(NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(UInt32)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(SDLLayoutMode)layout {
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

- (void)setInitialPrompt:(NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    [parameters sdl_setObject:initialPrompt forName:SDLNameInitialPrompt];
}

- (NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    return [parameters sdl_objectsForName:SDLNameInitialPrompt ofClass:SDLTTSChunk.class];
}

- (void)setInteractionMode:(SDLInteractionMode)interactionMode {
    [parameters sdl_setObject:interactionMode forName:SDLNameInteractionMode];
}

- (SDLInteractionMode)interactionMode {
    return [parameters sdl_objectForName:SDLNameInteractionMode];
}

- (void)setInteractionChoiceSetIDList:(NSMutableArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    [parameters sdl_setObject:interactionChoiceSetIDList forName:SDLNameInteractionChoiceSetIdList];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    return [parameters sdl_objectForName:SDLNameInteractionChoiceSetIdList];
}

- (void)setHelpPrompt:(NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    [parameters sdl_setObject:helpPrompt forName:SDLNameHelpPrompt];
}

- (NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    return [parameters sdl_objectsForName:SDLNameHelpPrompt ofClass:SDLTTSChunk.class];
}

- (void)setTimeoutPrompt:(NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    [parameters sdl_setObject:timeoutPrompt forName:SDLNameTimeoutPrompt];
}

- (NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    return [parameters sdl_objectsForName:SDLNameTimeoutPrompt ofClass:SDLTTSChunk.class];
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLNameTimeout];
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLNameTimeout];
}

- (void)setVrHelp:(NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    [parameters sdl_setObject:vrHelp forName:SDLNameVRHelp];
}

- (NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    return [parameters sdl_objectsForName:SDLNameVRHelp ofClass:SDLVRHelpItem.class];
}

- (void)setInteractionLayout:(SDLLayoutMode)interactionLayout {
    [parameters sdl_setObject:interactionLayout forName:SDLNameInteractionLayout];
}

- (SDLLayoutMode)interactionLayout {
    return [parameters sdl_objectForName:SDLNameInteractionLayout];
}

@end
