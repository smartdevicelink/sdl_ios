//  SDLPerformInteraction.m
//


#import "SDLPerformInteraction.h"

#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLTTSChunkFactory.h"
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
    if (initialText != nil) {
        [parameters setObject:initialText forKey:SDLNameInitialText];
    } else {
        [parameters removeObjectForKey:SDLNameInitialText];
    }
}

- (NSString *)initialText {
    return [parameters objectForKey:SDLNameInitialText];
}

- (void)setInitialPrompt:(NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    if (initialPrompt != nil) {
        [parameters setObject:initialPrompt forKey:SDLNameInitialPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameInitialPrompt];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameInitialPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setInteractionMode:(SDLInteractionMode)interactionMode {
    if (interactionMode != nil) {
        [parameters setObject:interactionMode forKey:SDLNameInteractionMode];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionMode];
    }
}

- (SDLInteractionMode)interactionMode {
    NSObject *obj = [parameters objectForKey:SDLNameInteractionMode];
    return (SDLInteractionMode)obj;
}

- (void)setInteractionChoiceSetIDList:(NSMutableArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    if (interactionChoiceSetIDList != nil) {
        [parameters setObject:interactionChoiceSetIDList forKey:SDLNameInteractionChoiceSetIdList];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionChoiceSetIdList];
    }
}

- (NSMutableArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList {
    return [parameters objectForKey:SDLNameInteractionChoiceSetIdList];
}

- (void)setHelpPrompt:(NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:SDLNameHelpPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameHelpPrompt];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameHelpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:SDLNameTimeoutPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutPrompt];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameTimeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setVrHelp:(NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:SDLNameVRHelp];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelp];
    }
}

- (NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    NSMutableArray<SDLVRHelpItem *> *array = [parameters objectForKey:SDLNameVRHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRHelpItem.class]) {
        return array;
    } else {
        NSMutableArray<SDLVRHelpItem *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLVRHelpItem alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setInteractionLayout:(SDLLayoutMode)interactionLayout {
    if (interactionLayout != nil) {
        [parameters setObject:interactionLayout forKey:SDLNameInteractionLayout];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionLayout];
    }
}

- (SDLLayoutMode)interactionLayout {
    NSObject *obj = [parameters objectForKey:SDLNameInteractionLayout];
    return (SDLLayoutMode)obj;
}

@end
