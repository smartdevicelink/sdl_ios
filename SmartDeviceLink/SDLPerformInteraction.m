//  SDLPerformInteraction.m
//


#import "SDLPerformInteraction.h"

#import "SDLInteractionMode.h"
#import "SDLLayoutMode.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVRHelpItem.h"

@implementation SDLPerformInteraction

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformInteraction]) {
    }
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

- (void)setInitialPrompt:(NSMutableArray *)initialPrompt {
    if (initialPrompt != nil) {
        [parameters setObject:initialPrompt forKey:SDLNameInitialPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameInitialPrompt];
    }
}

- (NSMutableArray *)initialPrompt {
    NSMutableArray *array = [parameters objectForKey:SDLNameInitialPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setInteractionMode:(SDLInteractionMode *)interactionMode {
    if (interactionMode != nil) {
        [parameters setObject:interactionMode forKey:SDLNameInteractionMode];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionMode];
    }
}

- (SDLInteractionMode *)interactionMode {
    NSObject *obj = [parameters objectForKey:SDLNameInteractionMode];
    if (obj == nil || [obj isKindOfClass:SDLInteractionMode.class]) {
        return (SDLInteractionMode *)obj;
    } else {
        return [SDLInteractionMode valueOf:(NSString *)obj];
    }
}

- (void)setInteractionChoiceSetIDList:(NSMutableArray *)interactionChoiceSetIDList {
    if (interactionChoiceSetIDList != nil) {
        [parameters setObject:interactionChoiceSetIDList forKey:SDLNameInteractionChoiceSetIdList];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionChoiceSetIdList];
    }
}

- (NSMutableArray *)interactionChoiceSetIDList {
    return [parameters objectForKey:SDLNameInteractionChoiceSetIdList];
}

- (void)setHelpPrompt:(NSMutableArray *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:SDLNameHelpPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameHelpPrompt];
    }
}

- (NSMutableArray *)helpPrompt {
    NSMutableArray *array = [parameters objectForKey:SDLNameHelpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(NSMutableArray *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:SDLNameTimeoutPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutPrompt];
    }
}

- (NSMutableArray *)timeoutPrompt {
    NSMutableArray *array = [parameters objectForKey:SDLNameTimeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeout:(NSNumber *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (NSNumber *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setVrHelp:(NSMutableArray *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:SDLNameVRHelp];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelp];
    }
}

- (NSMutableArray *)vrHelp {
    NSMutableArray *array = [parameters objectForKey:SDLNameVRHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRHelpItem.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLVRHelpItem alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setInteractionLayout:(SDLLayoutMode *)interactionLayout {
    if (interactionLayout != nil) {
        [parameters setObject:interactionLayout forKey:SDLNameInteractionLayout];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionLayout];
    }
}

- (SDLLayoutMode *)interactionLayout {
    NSObject *obj = [parameters objectForKey:SDLNameInteractionLayout];
    if (obj == nil || [obj isKindOfClass:SDLLayoutMode.class]) {
        return (SDLLayoutMode *)obj;
    } else {
        return [SDLLayoutMode valueOf:(NSString *)obj];
    }
}

@end
