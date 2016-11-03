//  SDLTTSChunk.m
//

#import "SDLTTSChunk.h"

#import "SDLNames.h"
#import "SDLSpeechCapabilities.h"


@implementation SDLTTSChunk

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text type:(SDLSpeechCapabilities *)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.text = text;
    self.type = type;

    return self;
}

+ (NSMutableArray<SDLTTSChunk *> *)textChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:[SDLSpeechCapabilities TEXT]];
}

+ (NSMutableArray<SDLTTSChunk *> *)sapiChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:[SDLSpeechCapabilities SAPI_PHONEMES]];
}

+ (NSMutableArray<SDLTTSChunk *> *)lhPlusChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:[SDLSpeechCapabilities LHPLUS_PHONEMES]];
}

+ (NSMutableArray<SDLTTSChunk *> *)prerecordedChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:[SDLSpeechCapabilities PRE_RECORDED]];
}

+ (NSMutableArray<SDLTTSChunk *> *)silenceChunks {
    return [self sdl_chunksFromString:nil type:[SDLSpeechCapabilities SILENCE]];
}

+ (NSMutableArray<SDLTTSChunk *> *)sdl_chunksFromString:(NSString *)string type:(SDLSpeechCapabilities *)type {
    if (string.length == 0) {
        return nil;
    }

    return [NSMutableArray arrayWithObject:[[[self class] alloc] initWithText:string type:type]];
}

- (void)setText:(NSString *)text {
    if (text != nil) {
        [store setObject:text forKey:NAMES_text];
    } else {
        [store removeObjectForKey:NAMES_text];
    }
}

- (NSString *)text {
    return [store objectForKey:NAMES_text];
}

- (void)setType:(SDLSpeechCapabilities *)type {
    if (type != nil) {
        [store setObject:type forKey:NAMES_type];
    } else {
        [store removeObjectForKey:NAMES_type];
    }
}

- (SDLSpeechCapabilities *)type {
    NSObject *obj = [store objectForKey:NAMES_type];
    if (obj == nil || [obj isKindOfClass:SDLSpeechCapabilities.class]) {
        return (SDLSpeechCapabilities *)obj;
    } else {
        return [SDLSpeechCapabilities valueOf:(NSString *)obj];
    }
}

@end
