//  SDLTTSChunk.m
//

#import "SDLTTSChunk.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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

+ (NSArray<SDLTTSChunk *> *)textChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesText];
}

+ (NSArray<SDLTTSChunk *> *)sapiChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesSAPIPhonemes];
}

+ (NSArray<SDLTTSChunk *> *)lhPlusChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesLHPlusPhonemes];
}

+ (NSArray<SDLTTSChunk *> *)prerecordedChunksFromString:(NSString *)string {
    return [self sdl_chunksFromString:string type:SDLSpeechCapabilitiesPrerecorded];
}

+ (NSArray<SDLTTSChunk *> *)silenceChunks {
    return [self sdl_chunksFromString:@"" type:SDLSpeechCapabilitiesSilence];
}

+ (NSArray<SDLTTSChunk *> *)fileChunksWithName:(NSString *)fileName {
    return [self sdl_chunksFromString:fileName type:SDLSpeechCapabilitiesFile];
}

+ (nullable NSArray<SDLTTSChunk *> *)sdl_chunksFromString:(nullable NSString *)string type:(SDLSpeechCapabilities)type {
    if (string == nil) {
        return nil;
    }

    return @[[[SDLTTSChunk alloc] initWithText:string type:type]];
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

NS_ASSUME_NONNULL_END
