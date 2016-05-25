//  SDLPrerecordedSpeech.m
//


#import "SDLPrerecordedSpeech.h"

SDLPrerecordedSpeech *SDLPrerecordedSpeech_HELP_JINGLE = nil;
SDLPrerecordedSpeech *SDLPrerecordedSpeech_INITIAL_JINGLE = nil;
SDLPrerecordedSpeech *SDLPrerecordedSpeech_LISTEN_JINGLE = nil;
SDLPrerecordedSpeech *SDLPrerecordedSpeech_POSITIVE_JINGLE = nil;
SDLPrerecordedSpeech *SDLPrerecordedSpeech_NEGATIVE_JINGLE = nil;

NSArray *SDLPrerecordedSpeech_values = nil;

@implementation SDLPrerecordedSpeech

+ (SDLPrerecordedSpeech *)valueOf:(NSString *)value {
    for (SDLPrerecordedSpeech *item in SDLPrerecordedSpeech.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLPrerecordedSpeech_values == nil) {
        SDLPrerecordedSpeech_values = @[
            SDLPrerecordedSpeech.HELP_JINGLE,
            SDLPrerecordedSpeech.INITIAL_JINGLE,
            SDLPrerecordedSpeech.LISTEN_JINGLE,
            SDLPrerecordedSpeech.POSITIVE_JINGLE,
            SDLPrerecordedSpeech.NEGATIVE_JINGLE,
        ];
    }
    return SDLPrerecordedSpeech_values;
}

+ (SDLPrerecordedSpeech *)HELP_JINGLE {
    if (SDLPrerecordedSpeech_HELP_JINGLE == nil) {
        SDLPrerecordedSpeech_HELP_JINGLE = [[SDLPrerecordedSpeech alloc] initWithValue:@"HELP_JINGLE"];
    }
    return SDLPrerecordedSpeech_HELP_JINGLE;
}

+ (SDLPrerecordedSpeech *)INITIAL_JINGLE {
    if (SDLPrerecordedSpeech_INITIAL_JINGLE == nil) {
        SDLPrerecordedSpeech_INITIAL_JINGLE = [[SDLPrerecordedSpeech alloc] initWithValue:@"INITIAL_JINGLE"];
    }
    return SDLPrerecordedSpeech_INITIAL_JINGLE;
}

+ (SDLPrerecordedSpeech *)LISTEN_JINGLE {
    if (SDLPrerecordedSpeech_LISTEN_JINGLE == nil) {
        SDLPrerecordedSpeech_LISTEN_JINGLE = [[SDLPrerecordedSpeech alloc] initWithValue:@"LISTEN_JINGLE"];
    }
    return SDLPrerecordedSpeech_LISTEN_JINGLE;
}

+ (SDLPrerecordedSpeech *)POSITIVE_JINGLE {
    if (SDLPrerecordedSpeech_POSITIVE_JINGLE == nil) {
        SDLPrerecordedSpeech_POSITIVE_JINGLE = [[SDLPrerecordedSpeech alloc] initWithValue:@"POSITIVE_JINGLE"];
    }
    return SDLPrerecordedSpeech_POSITIVE_JINGLE;
}

+ (SDLPrerecordedSpeech *)NEGATIVE_JINGLE {
    if (SDLPrerecordedSpeech_NEGATIVE_JINGLE == nil) {
        SDLPrerecordedSpeech_NEGATIVE_JINGLE = [[SDLPrerecordedSpeech alloc] initWithValue:@"NEGATIVE_JINGLE"];
    }
    return SDLPrerecordedSpeech_NEGATIVE_JINGLE;
}

@end
