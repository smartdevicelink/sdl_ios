//  SDLTTSChunk.m
//

#import "SDLTTSChunk.h"

#import "SDLNames.h"

@implementation SDLTTSChunk

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
