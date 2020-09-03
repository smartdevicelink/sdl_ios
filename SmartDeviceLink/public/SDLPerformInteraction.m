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

- (instancetype)initWithInitialDisplayText:(NSString *)initialText initialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt interactionMode:(SDLInteractionMode)interactionMode interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt timeout:(nullable NSNumber *)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(nullable SDLLayoutMode)interactionLayout cancelID:(nullable NSNumber *)cancelID {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.initialText = initialText;
    self.initialPrompt = initialPrompt;
    self.interactionMode = interactionMode;
    self.interactionChoiceSetIDList = interactionChoiceSetIDList;
    self.helpPrompt = helpPrompt;
    self.timeoutPrompt = timeoutPrompt;
    self.timeout = timeout;
    self.vrHelp = vrHelp;
    self.interactionLayout = interactionLayout;
    self.cancelID = cancelID;

    return self;
}

- (instancetype)initWithInitialText:(NSString *)initialText interactionMode:(SDLInteractionMode)interactionMode interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList cancelID:(UInt32)cancelID {
    return [self initWithInitialDisplayText:initialText initialPrompt:nil interactionMode:interactionMode interactionChoiceSetIDList:interactionChoiceSetIDList helpPrompt:nil timeoutPrompt:nil timeout:nil vrHelp:nil interactionLayout:nil cancelID:@(cancelID)];
}

- (instancetype)initWithInitialText:(NSString *)initialText initialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt interactionMode:(SDLInteractionMode)interactionMode interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt timeout:(UInt16)timeout vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(nullable SDLLayoutMode)interactionLayout cancelID:(UInt32)cancelID {
    return [self initWithInitialDisplayText:initialText initialPrompt:initialPrompt interactionMode:interactionMode interactionChoiceSetIDList:interactionChoiceSetIDList helpPrompt:helpPrompt timeoutPrompt:timeoutPrompt timeout:@(timeout) vrHelp:vrHelp interactionLayout:interactionLayout cancelID:@(cancelID)];
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

- (void)setInteractionChoiceSetIDList:(NSArray<NSNumber *> *)interactionChoiceSetIDList {
    [self.parameters sdl_setObject:interactionChoiceSetIDList forName:SDLRPCParameterNameInteractionChoiceSetIdList];
}

- (NSArray<NSNumber *> *)interactionChoiceSetIDList {
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

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
