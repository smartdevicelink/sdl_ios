//  SDLOnHMIStatus.m
//

#import "SDLOnHMIStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSystemContext.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnHMIStatus

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnHMIStatus]) {
    }
    return self;
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    [parameters sdl_setObject:hmiLevel forName:SDLRPCParameterNameHMILevel];
}

- (SDLHMILevel)hmiLevel {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameHMILevel error:&error];
}

- (void)setAudioStreamingState:(SDLAudioStreamingState)audioStreamingState {
    [parameters sdl_setObject:audioStreamingState forName:SDLRPCParameterNameAudioStreamingState];
}

- (SDLAudioStreamingState)audioStreamingState {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameAudioStreamingState error:&error];
}

- (void)setVideoStreamingState:(nullable SDLVideoStreamingState)videoStreamingState {
    [parameters sdl_setObject:videoStreamingState forName:SDLRPCParameterNameVideoStreamingState];
}

- (nullable SDLVideoStreamingState)videoStreamingState {
    return [parameters sdl_enumForName:SDLRPCParameterNameVideoStreamingState error:nil];
}

- (void)setSystemContext:(SDLSystemContext)systemContext {
    [parameters sdl_setObject:systemContext forName:SDLRPCParameterNameSystemContext];
}

- (SDLSystemContext)systemContext {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameSystemContext error:&error];
}

@end

NS_ASSUME_NONNULL_END
