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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setTtsChunks:(NSMutableArray *)ttsChunks {
    if (ttsChunks != nil) {
        [parameters setObject:ttsChunks forKey:NAMES_ttsChunks];
    } else {
        [parameters removeObjectForKey:NAMES_ttsChunks];
    }
}

- (NSMutableArray *)ttsChunks {
    NSMutableArray *array = [parameters objectForKey:NAMES_ttsChunks];
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

@end
