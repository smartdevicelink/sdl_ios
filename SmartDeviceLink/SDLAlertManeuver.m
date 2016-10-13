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

- (void)setTtsChunks:(NSMutableArray *)ttsChunks {
    if (ttsChunks != nil) {
        [parameters setObject:ttsChunks forKey:SDLNameTTSChunks];
    } else {
        [parameters removeObjectForKey:SDLNameTTSChunks];
    }
}

- (NSMutableArray *)ttsChunks {
    NSMutableArray *array = [parameters objectForKey:SDLNameTTSChunks];
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

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
