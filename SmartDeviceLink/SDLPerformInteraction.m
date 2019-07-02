//  SDLPerformInteraction.m
//


#import "SDLPerformInteraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformInteraction

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePerformInteraction]) {
    }
    return self;
}
#pragma clang diagnostic pop

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
    [self.parameters sdl_setObject:initialText forName:SDLRPCParameterNameInitialText];
}

- (NSString *)initialText {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInitialText ofClass:NSString.class error:&error];
}

- (void)setInitialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt {
    [self.parameters sdl_setObject:initialPrompt forName:SDLRPCParameterNameInitialPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)initialPrompt {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameInitialPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setInteractionMode:(SDLInteractionMode)interactionMode {
    [self.parameters sdl_setObject:interactionMode forName:SDLRPCParameterNameInteractionMode];
}

- (SDLInteractionMode)interactionMode {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameInteractionMode error:&error];
}

- (void)setInteractionChoiceSetIDList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    [self.parameters sdl_setObject:interactionChoiceSetIDList forName:SDLRPCParameterNameInteractionChoiceSetIdList];
}

- (NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameInteractionChoiceSetIdList ofClass:NSNumber.class error:&error];
}

- (void)setHelpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    [self.parameters sdl_setObject:helpPrompt forName:SDLRPCParameterNameHelpPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameHelpPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setTimeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    [self.parameters sdl_setObject:timeoutPrompt forName:SDLRPCParameterNameTimeoutPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTimeoutPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [self.parameters sdl_setObject:timeout forName:SDLRPCParameterNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTimeout ofClass:NSNumber.class error:nil];
}

- (void)setVrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    [self.parameters sdl_setObject:vrHelp forName:SDLRPCParameterNameVRHelp];
}

- (nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameVRHelp ofClass:SDLVRHelpItem.class error:nil];
}

- (void)setInteractionLayout:(nullable SDLLayoutMode)interactionLayout {
    [self.parameters sdl_setObject:interactionLayout forName:SDLRPCParameterNameInteractionLayout];
}

- (nullable SDLLayoutMode)interactionLayout {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameInteractionLayout error:nil];
}

@end

NS_ASSUME_NONNULL_END
