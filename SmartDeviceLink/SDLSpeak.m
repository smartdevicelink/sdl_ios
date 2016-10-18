//  SDLSpeak.m
//


#import "SDLSpeak.h"

#import "SDLNames.h"
#import "SDLTTSChunk.h"

@implementation SDLSpeak

- (instancetype)init {
    if (self = [super initWithName:SDLNameSpeak]) {
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
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
