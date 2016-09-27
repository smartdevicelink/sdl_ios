//  SDLAlertManeuver.m
//


#import "SDLAlertManeuver.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

@implementation SDLAlertManeuver

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlertManeuver]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setTtsChunks:(NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    if (ttsChunks != nil) {
        [parameters setObject:ttsChunks forKey:SDLNameTTSChunks];
    } else {
        [parameters removeObjectForKey:SDLNameTTSChunks];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameTTSChunks];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButton *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

@end
