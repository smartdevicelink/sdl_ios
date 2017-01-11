//  SDLPerformInteraction.m
//


#import "SDLPerformInteraction.h"

#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLTTSChunkFactory.h"
#import "SDLVRHelpItem.h"

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
    NSMutableArray *initialChunks = [SDLTTSChunk textChunksFromString:initialPrompt];
    NSMutableArray *helpChunks = [SDLTTSChunk textChunksFromString:helpPrompt];
    NSMutableArray *timeoutChunks = [SDLTTSChunk textChunksFromString:timeoutPrompt];
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
    if (initialText != nil) {
        [parameters setObject:initialText forKey:SDLNameInitialText];
    } else {
        [parameters removeObjectForKey:SDLNameInitialText];
    }
}

- (NSString *)initialText {
    return [parameters objectForKey:SDLNameInitialText];
}

- (void)setInitialPrompt:(nullable NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    if (initialPrompt != nil) {
        [parameters setObject:initialPrompt forKey:SDLNameInitialPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameInitialPrompt];
    }
}

- (nullable NSMutableArray<SDLTTSChunk *> *)initialPrompt {
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

- (void)setHelpPrompt:(nullable NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:SDLNameHelpPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameHelpPrompt];
    }
}

- (nullable NSMutableArray<SDLTTSChunk *> *)helpPrompt {
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

- (void)setTimeoutPrompt:(nullable NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:SDLNameTimeoutPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutPrompt];
    }
}

- (nullable NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
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

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setVrHelp:(nullable NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:SDLNameVRHelp];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelp];
    }
}

- (nullable NSMutableArray<SDLVRHelpItem *> *)vrHelp {
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

- (void)setInteractionLayout:(nullable SDLLayoutMode)interactionLayout {
    if (interactionLayout != nil) {
        [parameters setObject:interactionLayout forKey:SDLNameInteractionLayout];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionLayout];
    }
}

- (nullable SDLLayoutMode)interactionLayout {
    NSObject *obj = [parameters objectForKey:SDLNameInteractionLayout];
    return (SDLLayoutMode)obj;
}

@end

NS_ASSUME_NONNULL_END
