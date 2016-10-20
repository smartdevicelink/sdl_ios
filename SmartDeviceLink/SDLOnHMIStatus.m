//  SDLOnHMIStatus.m
//

#import "SDLOnHMIStatus.h"

#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLNames.h"
#import "SDLSystemContext.h"

@implementation SDLOnHMIStatus

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnHMIStatus]) {
    }
    return self;
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    if (hmiLevel != nil) {
        [parameters setObject:hmiLevel forKey:SDLNameHMILevel];
    } else {
        [parameters removeObjectForKey:SDLNameHMILevel];
    }
}

- (SDLHMILevel)hmiLevel {
    NSObject *obj = [parameters objectForKey:SDLNameHMILevel];
    return (SDLHMILevel)obj;
}

- (void)setAudioStreamingState:(SDLAudioStreamingState)audioStreamingState {
    if (audioStreamingState != nil) {
        [parameters setObject:audioStreamingState forKey:SDLNameAudioStreamingState];
    } else {
        [parameters removeObjectForKey:SDLNameAudioStreamingState];
    }
}

- (SDLAudioStreamingState)audioStreamingState {
    NSObject *obj = [parameters objectForKey:SDLNameAudioStreamingState];
    return (SDLAudioStreamingState)obj;
}

- (void)setSystemContext:(SDLSystemContext)systemContext {
    if (systemContext != nil) {
        [parameters setObject:systemContext forKey:SDLNameSystemContext];
    } else {
        [parameters removeObjectForKey:SDLNameSystemContext];
    }
}

- (SDLSystemContext)systemContext {
    NSObject *obj = [parameters objectForKey:SDLNameSystemContext];
    return (SDLSystemContext)obj;
}

@end
