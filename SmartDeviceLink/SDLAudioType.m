//  SDLAudioType.m
//

#import "SDLAudioType.h"

SDLAudioType *SDLAudioType_PCM = nil;

NSArray *SDLAudioType_values = nil;

@implementation SDLAudioType

+ (SDLAudioType *)valueOf:(NSString *)value {
    for (SDLAudioType *item in SDLAudioType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLAudioType_values == nil) {
        SDLAudioType_values = @[
            SDLAudioType.PCM,
        ];
    }
    return SDLAudioType_values;
}

+ (SDLAudioType *)PCM {
    if (SDLAudioType_PCM == nil) {
        SDLAudioType_PCM = [[SDLAudioType alloc] initWithValue:@"PCM"];
    }
    return SDLAudioType_PCM;
}

@end
