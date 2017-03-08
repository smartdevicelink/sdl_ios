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
    NSObject *obj = [parameters sdl_objectForName:SDLNameHMILevel];
    return (SDLHMILevel)obj;
}

- (void)setAudioStreamingState:(SDLAudioStreamingState)audioStreamingState {
    [parameters sdl_setObject:audioStreamingState forName:SDLNameAudioStreamingState];
}

- (SDLAudioStreamingState)audioStreamingState {
    NSObject *obj = [parameters sdl_objectForName:SDLNameAudioStreamingState];
    return (SDLAudioStreamingState)obj;
}

- (void)setSystemContext:(SDLSystemContext)systemContext {
    [parameters sdl_setObject:systemContext forName:SDLNameSystemContext];
}

- (SDLSystemContext)systemContext {
    NSObject *obj = [parameters sdl_objectForName:SDLNameSystemContext];
    return (SDLSystemContext)obj;
}

@end

NS_ASSUME_NONNULL_END
