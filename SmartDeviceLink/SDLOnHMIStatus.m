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
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameHMILevel];
    return (SDLHMILevel)obj;
}

- (void)setAudioStreamingState:(SDLAudioStreamingState)audioStreamingState {
    [parameters sdl_setObject:audioStreamingState forName:SDLRPCParameterNameAudioStreamingState];
}

- (SDLAudioStreamingState)audioStreamingState {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameAudioStreamingState];
    return (SDLAudioStreamingState)obj;
}

- (void)setVideoStreamingState:(nullable SDLVideoStreamingState)videoStreamingState {
    [parameters sdl_setObject:videoStreamingState forName:SDLRPCParameterNameVideoStreamingState];
}

- (nullable SDLVideoStreamingState)videoStreamingState {
    return [parameters sdl_objectForName:SDLRPCParameterNameVideoStreamingState];
}

- (void)setSystemContext:(SDLSystemContext)systemContext {
    [parameters sdl_setObject:systemContext forName:SDLRPCParameterNameSystemContext];
}

- (SDLSystemContext)systemContext {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameSystemContext];
    return (SDLSystemContext)obj;
}

@end

NS_ASSUME_NONNULL_END
