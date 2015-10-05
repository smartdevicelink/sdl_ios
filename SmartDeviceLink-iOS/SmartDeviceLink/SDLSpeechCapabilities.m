//  SDLSpeechCapabilities.m
//


#import "SDLSpeechCapabilities.h"

SDLSpeechCapabilities *SDLSpeechCapabilities_TEXT = nil;
SDLSpeechCapabilities *SDLSpeechCapabilities_SAPI_PHONEMES = nil;
SDLSpeechCapabilities *SDLSpeechCapabilities_LHPLUS_PHONEMES = nil;
SDLSpeechCapabilities *SDLSpeechCapabilities_PRE_RECORDED = nil;
SDLSpeechCapabilities *SDLSpeechCapabilities_SILENCE = nil;

NSArray *SDLSpeechCapabilities_values = nil;

@implementation SDLSpeechCapabilities

+ (SDLSpeechCapabilities *)valueOf:(NSString *)value {
    for (SDLSpeechCapabilities *item in SDLSpeechCapabilities.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLSpeechCapabilities_values == nil) {
        SDLSpeechCapabilities_values = @[
            SDLSpeechCapabilities.TEXT,
            SDLSpeechCapabilities.SAPI_PHONEMES,
            SDLSpeechCapabilities.LHPLUS_PHONEMES,
            SDLSpeechCapabilities.PRE_RECORDED,
            SDLSpeechCapabilities.SILENCE,
        ];
    }
    return SDLSpeechCapabilities_values;
}

+ (SDLSpeechCapabilities *)TEXT {
    if (SDLSpeechCapabilities_TEXT == nil) {
        SDLSpeechCapabilities_TEXT = [[SDLSpeechCapabilities alloc] initWithValue:@"TEXT"];
    }
    return SDLSpeechCapabilities_TEXT;
}

+ (SDLSpeechCapabilities *)SAPI_PHONEMES {
    if (SDLSpeechCapabilities_SAPI_PHONEMES == nil) {
        SDLSpeechCapabilities_SAPI_PHONEMES = [[SDLSpeechCapabilities alloc] initWithValue:@"SAPI_PHONEMES"];
    }
    return SDLSpeechCapabilities_SAPI_PHONEMES;
}

+ (SDLSpeechCapabilities *)LHPLUS_PHONEMES {
    if (SDLSpeechCapabilities_LHPLUS_PHONEMES == nil) {
        SDLSpeechCapabilities_LHPLUS_PHONEMES = [[SDLSpeechCapabilities alloc] initWithValue:@"LHPLUS_PHONEMES"];
    }
    return SDLSpeechCapabilities_LHPLUS_PHONEMES;
}

+ (SDLSpeechCapabilities *)PRE_RECORDED {
    if (SDLSpeechCapabilities_PRE_RECORDED == nil) {
        SDLSpeechCapabilities_PRE_RECORDED = [[SDLSpeechCapabilities alloc] initWithValue:@"PRE_RECORDED"];
    }
    return SDLSpeechCapabilities_PRE_RECORDED;
}

+ (SDLSpeechCapabilities *)SILENCE {
    if (SDLSpeechCapabilities_SILENCE == nil) {
        SDLSpeechCapabilities_SILENCE = [[SDLSpeechCapabilities alloc] initWithValue:@"SILENCE"];
    }
    return SDLSpeechCapabilities_SILENCE;
}

@end
