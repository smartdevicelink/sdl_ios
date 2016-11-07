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
    [self setObject:hmiLevel forName:SDLNameHMILevel];
}

- (SDLHMILevel)hmiLevel {
    NSObject *obj = [parameters objectForKey:SDLNameHMILevel];
    return (SDLHMILevel)obj;
}

- (void)setAudioStreamingState:(SDLAudioStreamingState)audioStreamingState {
    [self setObject:audioStreamingState forName:SDLNameAudioStreamingState];
}

- (SDLAudioStreamingState)audioStreamingState {
    NSObject *obj = [parameters objectForKey:SDLNameAudioStreamingState];
    return (SDLAudioStreamingState)obj;
}

- (void)setSystemContext:(SDLSystemContext)systemContext {
    [self setObject:systemContext forName:SDLNameSystemContext];
}

- (SDLSystemContext)systemContext {
    NSObject *obj = [parameters objectForKey:SDLNameSystemContext];
    return (SDLSystemContext)obj;
}

@end
