//  SDLAudioStreamingState.m
//


#import "SDLAudioStreamingState.h"

SDLAudioStreamingState *SDLAudioStreamingState_AUDIBLE = nil;
SDLAudioStreamingState *SDLAudioStreamingState_ATTENUATED = nil;
SDLAudioStreamingState *SDLAudioStreamingState_NOT_AUDIBLE = nil;

NSArray *SDLAudioStreamingState_values = nil;

@implementation SDLAudioStreamingState

+ (SDLAudioStreamingState *)valueOf:(NSString *)value {
    for (SDLAudioStreamingState *item in SDLAudioStreamingState.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLAudioStreamingState_values == nil) {
        SDLAudioStreamingState_values = @[
            SDLAudioStreamingState.AUDIBLE,
            SDLAudioStreamingState.ATTENUATED,
            SDLAudioStreamingState.NOT_AUDIBLE,
        ];
    }
    return SDLAudioStreamingState_values;
}

+ (SDLAudioStreamingState *)AUDIBLE {
    if (SDLAudioStreamingState_AUDIBLE == nil) {
        SDLAudioStreamingState_AUDIBLE = [[SDLAudioStreamingState alloc] initWithValue:@"AUDIBLE"];
    }
    return SDLAudioStreamingState_AUDIBLE;
}

+ (SDLAudioStreamingState *)ATTENUATED {
    if (SDLAudioStreamingState_ATTENUATED == nil) {
        SDLAudioStreamingState_ATTENUATED = [[SDLAudioStreamingState alloc] initWithValue:@"ATTENUATED"];
    }
    return SDLAudioStreamingState_ATTENUATED;
}

+ (SDLAudioStreamingState *)NOT_AUDIBLE {
    if (SDLAudioStreamingState_NOT_AUDIBLE == nil) {
        SDLAudioStreamingState_NOT_AUDIBLE = [[SDLAudioStreamingState alloc] initWithValue:@"NOT_AUDIBLE"];
    }
    return SDLAudioStreamingState_NOT_AUDIBLE;
}

@end
