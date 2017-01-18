//  SDLTTSChunk.m
//

#import "SDLTTSChunk.h"

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

+ (nullable NSMutableArray<SDLTTSChunk *> *)sdl_chunksFromString:(nullable NSString *)string type:(SDLSpeechCapabilities)type {
    if (string.length == 0) {
        return nil;
    }

    return [NSMutableArray arrayWithObject:[[[self class] alloc] initWithText:string type:type]];
}

- (void)setText:(NSString *)text {
    if (text != nil) {
        [store setObject:text forKey:SDLNameText];
    } else {
        [store removeObjectForKey:SDLNameText];
    }
}

- (NSString *)text {
    return [store objectForKey:SDLNameText];
}

- (void)setType:(SDLSpeechCapabilities)type {
    if (type != nil) {
        [store setObject:type forKey:SDLNameType];
    } else {
        [store removeObjectForKey:SDLNameType];
    }
}

- (SDLSpeechCapabilities)type {
    NSObject *obj = [store objectForKey:SDLNameType];
    return (SDLSpeechCapabilities)obj;
}

@end

NS_ASSUME_NONNULL_END
