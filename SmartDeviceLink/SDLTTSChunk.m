//  SDLTTSChunk.m
//

#import "SDLTTSChunk.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLTTSChunk

- (instancetype)initWithText:(NSString *)text type:(SDLSpeechCapabilities)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.text = text;
    self.type = type;

    return self;
}

+ (NSMutableArray<SDLTTSChunk *> *)textChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesText];
}

+ (NSMutableArray<SDLTTSChunk *> *)sapiChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesSAPIPhonemes];
}

+ (NSMutableArray<SDLTTSChunk *> *)lhPlusChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesLHPlusPhonemes];
}

+ (NSMutableArray<SDLTTSChunk *> *)prerecordedChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesPrerecorded];
}

+ (NSMutableArray<SDLTTSChunk *> *)silenceChunks {
    return [self sdl_chunksFromString:nil type:SDLSpeechCapabilitiesSilence];
}

+ (NSMutableArray<SDLTTSChunk *> *)sdl_chunksFromString:(NSString *)string type:(SDLSpeechCapabilities)type {
    if (string.length == 0) {
        return nil;
    }

    return [NSMutableArray arrayWithObject:[[[self class] alloc] initWithText:string type:type]];
}

- (void)setText:(NSString *)text {
    [store sdl_setObject:text forName:SDLNameText];
}

- (NSString *)text {
    return [store sdl_objectForName:SDLNameText];
}

- (void)setType:(SDLSpeechCapabilities)type {
    [store sdl_setObject:type forName:SDLNameType];
}

- (SDLSpeechCapabilities)type {
    return [store sdl_objectForName:SDLNameType];
}

@end
