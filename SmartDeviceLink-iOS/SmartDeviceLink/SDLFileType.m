//  SDLFileType.m
//


#import "SDLFileType.h"

SDLFileType *SDLFileType_GRAPHIC_BMP = nil;
SDLFileType *SDLFileType_GRAPHIC_JPEG = nil;
SDLFileType *SDLFileType_GRAPHIC_PNG = nil;
SDLFileType *SDLFileType_AUDIO_WAVE = nil;
SDLFileType *SDLFileType_AUDIO_MP3 = nil;
SDLFileType *SDLFileType_AUDIO_AAC = nil;
SDLFileType *SDLFileType_BINARY = nil;
SDLFileType *SDLFileType_JSON = nil;

NSArray *SDLFileType_values = nil;

@implementation SDLFileType

+ (SDLFileType *)valueOf:(NSString *)value {
    for (SDLFileType *item in SDLFileType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLFileType_values == nil) {
        SDLFileType_values = @[
            SDLFileType.GRAPHIC_BMP,
            SDLFileType.GRAPHIC_JPEG,
            SDLFileType.GRAPHIC_PNG,
            SDLFileType.AUDIO_WAVE,
            SDLFileType.AUDIO_MP3,
            SDLFileType.AUDIO_AAC,
            SDLFileType.BINARY,
            SDLFileType.JSON,
        ];
    }
    return SDLFileType_values;
}

+ (SDLFileType *)GRAPHIC_BMP {
    if (SDLFileType_GRAPHIC_BMP == nil) {
        SDLFileType_GRAPHIC_BMP = [[SDLFileType alloc] initWithValue:@"GRAPHIC_BMP"];
    }
    return SDLFileType_GRAPHIC_BMP;
}

+ (SDLFileType *)GRAPHIC_JPEG {
    if (SDLFileType_GRAPHIC_JPEG == nil) {
        SDLFileType_GRAPHIC_JPEG = [[SDLFileType alloc] initWithValue:@"GRAPHIC_JPEG"];
    }
    return SDLFileType_GRAPHIC_JPEG;
}

+ (SDLFileType *)GRAPHIC_PNG {
    if (SDLFileType_GRAPHIC_PNG == nil) {
        SDLFileType_GRAPHIC_PNG = [[SDLFileType alloc] initWithValue:@"GRAPHIC_PNG"];
    }
    return SDLFileType_GRAPHIC_PNG;
}

+ (SDLFileType *)AUDIO_WAVE {
    if (SDLFileType_AUDIO_WAVE == nil) {
        SDLFileType_AUDIO_WAVE = [[SDLFileType alloc] initWithValue:@"AUDIO_WAVE"];
    }
    return SDLFileType_AUDIO_WAVE;
}

+ (SDLFileType *)AUDIO_MP3 {
    if (SDLFileType_AUDIO_MP3 == nil) {
        SDLFileType_AUDIO_MP3 = [[SDLFileType alloc] initWithValue:@"AUDIO_MP3"];
    }
    return SDLFileType_AUDIO_MP3;
}

+ (SDLFileType *)AUDIO_AAC {
    if (SDLFileType_AUDIO_AAC == nil) {
        SDLFileType_AUDIO_AAC = [[SDLFileType alloc] initWithValue:@"AUDIO_AAC"];
    }
    return SDLFileType_AUDIO_AAC;
}

+ (SDLFileType *)BINARY {
    if (SDLFileType_BINARY == nil) {
        SDLFileType_BINARY = [[SDLFileType alloc] initWithValue:@"BINARY"];
    }
    return SDLFileType_BINARY;
}

+ (SDLFileType *)JSON {
    if (SDLFileType_JSON == nil) {
        SDLFileType_JSON = [[SDLFileType alloc] initWithValue:@"JSON"];
    }
    return SDLFileType_JSON;
}

@end
