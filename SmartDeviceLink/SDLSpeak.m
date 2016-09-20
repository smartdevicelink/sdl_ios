//  SDLSpeak.m
//


#import "SDLSpeak.h"

#import "SDLNames.h"
#import "SDLTTSChunk.h"

@implementation SDLSpeak

- (instancetype)init {
    if (self = [super initWithName:NAMES_Speak]) {
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
        [parameters setObject:ttsChunks forKey:NAMES_ttsChunks];
    } else {
        [parameters removeObjectForKey:NAMES_ttsChunks];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)ttsChunks {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:NAMES_ttsChunks];
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

@end
