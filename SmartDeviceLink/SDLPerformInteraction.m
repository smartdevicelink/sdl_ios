//  SDLPerformInteraction.m
//


#import "SDLPerformInteraction.h"

#import "SDLInteractionMode.h"
#import "SDLLayoutMode.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLTTSChunkFactory.h"
#import "SDLVrHelpItem.h"

static UInt16 const SDLDefaultTimeout = 10000;

@implementation SDLPerformInteraction

- (instancetype)init {
    if (self = [super initWithName:NAMES_PerformInteraction]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode *)interactionMode timeout:(UInt32)timeout {
    return [self initWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpPrompt:helpPrompt timeoutPrompt:timeoutPrompt interactionMode:interactionMode timeout:timeout vrHelp:nil];
}

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode *)interactionMode timeout:(UInt32)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp {
    NSMutableArray *initialChunks = [SDLTTSChunk textChunksFromString:initialPrompt];
    NSMutableArray *helpChunks = [SDLTTSChunk textChunksFromString:helpPrompt];
    NSMutableArray *timeoutChunks = [SDLTTSChunk textChunksFromString:timeoutPrompt];
    return [self initWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:interactionMode timeout:timeout vrHelp:vrHelp];
}

- (instancetype)initWithInitialChunks:(NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(NSArray *)helpChunks timeoutChunks:(NSArray *)timeoutChunks interactionMode:(SDLInteractionMode *)interactionMode timeout:(UInt32)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:interactionMode timeout:timeout vrHelp:vrHelp interactionLayout:nil];
}

- (instancetype)initWithInitialChunks:(NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLUInt> *> *)interactionChoiceSetIDList helpChunks:(NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode *)interactionMode timeout:(UInt32)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp interactionLayout:(SDLLayoutMode *)layout {
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

- (instancetype)initWithInteractionChoiceSetIdList:(NSArray *)interactionChoiceSetIdList {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.interactionChoiceSetIDList = [interactionChoiceSetIdList mutableCopy];

    return self;
}

- (void)setInitialText:(NSString *)initialText {
    if (initialText != nil) {
        [parameters setObject:initialText forKey:NAMES_initialText];
    } else {
        [parameters removeObjectForKey:NAMES_initialText];
    }
}

- (NSString *)initialText {
    return [parameters objectForKey:NAMES_initialText];
}

- (void)setInitialPrompt:(NSMutableArray *)initialPrompt {
    if (initialPrompt != nil) {
        [parameters setObject:initialPrompt forKey:NAMES_initialPrompt];
    } else {
        [parameters removeObjectForKey:NAMES_initialPrompt];
    }
}

- (NSMutableArray *)initialPrompt {
    NSMutableArray *array = [parameters objectForKey:NAMES_initialPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setInteractionMode:(SDLInteractionMode *)interactionMode {
    if (interactionMode != nil) {
        [parameters setObject:interactionMode forKey:NAMES_interactionMode];
    } else {
        [parameters removeObjectForKey:NAMES_interactionMode];
    }
}

- (SDLInteractionMode *)interactionMode {
    NSObject *obj = [parameters objectForKey:NAMES_interactionMode];
    if (obj == nil || [obj isKindOfClass:SDLInteractionMode.class]) {
        return (SDLInteractionMode *)obj;
    } else {
        return [SDLInteractionMode valueOf:(NSString *)obj];
    }
}

- (void)setInteractionChoiceSetIDList:(NSMutableArray *)interactionChoiceSetIDList {
    if (interactionChoiceSetIDList != nil) {
        [parameters setObject:interactionChoiceSetIDList forKey:NAMES_interactionChoiceSetIDList];
    } else {
        [parameters removeObjectForKey:NAMES_interactionChoiceSetIDList];
    }
}

- (NSMutableArray *)interactionChoiceSetIDList {
    return [parameters objectForKey:NAMES_interactionChoiceSetIDList];
}

- (void)setHelpPrompt:(NSMutableArray *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:NAMES_helpPrompt];
    } else {
        [parameters removeObjectForKey:NAMES_helpPrompt];
    }
}

- (NSMutableArray *)helpPrompt {
    NSMutableArray *array = [parameters objectForKey:NAMES_helpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(NSMutableArray *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:NAMES_timeoutPrompt];
    } else {
        [parameters removeObjectForKey:NAMES_timeoutPrompt];
    }
}

- (NSMutableArray *)timeoutPrompt {
    NSMutableArray *array = [parameters objectForKey:NAMES_timeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeout:(NSNumber *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:NAMES_timeout];
    } else {
        [parameters removeObjectForKey:NAMES_timeout];
    }
}

- (NSNumber *)timeout {
    return [parameters objectForKey:NAMES_timeout];
}

- (void)setVrHelp:(NSMutableArray *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:NAMES_vrHelp];
    } else {
        [parameters removeObjectForKey:NAMES_vrHelp];
    }
}

- (NSMutableArray *)vrHelp {
    NSMutableArray *array = [parameters objectForKey:NAMES_vrHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRHelpItem.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLVRHelpItem alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setInteractionLayout:(SDLLayoutMode *)interactionLayout {
    if (interactionLayout != nil) {
        [parameters setObject:interactionLayout forKey:NAMES_interactionLayout];
    } else {
        [parameters removeObjectForKey:NAMES_interactionLayout];
    }
}

- (SDLLayoutMode *)interactionLayout {
    NSObject *obj = [parameters objectForKey:NAMES_interactionLayout];
    if (obj == nil || [obj isKindOfClass:SDLLayoutMode.class]) {
        return (SDLLayoutMode *)obj;
    } else {
        return [SDLLayoutMode valueOf:(NSString *)obj];
    }
}

@end
