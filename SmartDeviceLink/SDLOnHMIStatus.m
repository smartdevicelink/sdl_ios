//  SDLOnHMIStatus.m
//

#import "SDLOnHMIStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLNames.h"
#import "SDLSystemContext.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnHMIStatus

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnHMIStatus]) {
    }
    return self;
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    [parameters sdl_setObject:hmiLevel forName:SDLNameHMILevel];
}

- (SDLHMILevel)hmiLevel {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameHMILevel error:&error];
}

- (void)setAudioStreamingState:(SDLAudioStreamingState)audioStreamingState {
    [parameters sdl_setObject:audioStreamingState forName:SDLNameAudioStreamingState];
}

- (SDLAudioStreamingState)audioStreamingState {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameAudioStreamingState error:&error];
}

- (void)setVideoStreamingState:(nullable SDLVideoStreamingState)videoStreamingState {
    [parameters sdl_setObject:videoStreamingState forName:SDLNameVideoStreamingState];
}

- (nullable SDLVideoStreamingState)videoStreamingState {
    return [parameters sdl_enumForName:SDLNameVideoStreamingState];
}

- (void)setSystemContext:(SDLSystemContext)systemContext {
    [parameters sdl_setObject:systemContext forName:SDLNameSystemContext];
}

- (SDLSystemContext)systemContext {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameSystemContext error:&error];
}

@end

NS_ASSUME_NONNULL_END
