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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setHmiLevel:(SDLHMILevel *)hmiLevel {
    if (hmiLevel != nil) {
        [parameters setObject:hmiLevel forKey:SDLNameHMILevel];
    } else {
        [parameters removeObjectForKey:SDLNameHMILevel];
    }
}

- (SDLHMILevel *)hmiLevel {
    NSObject *obj = [parameters objectForKey:SDLNameHMILevel];
    if (obj == nil || [obj isKindOfClass:SDLHMILevel.class]) {
        return (SDLHMILevel *)obj;
    } else {
        return [SDLHMILevel valueOf:(NSString *)obj];
    }
}

- (void)setAudioStreamingState:(SDLAudioStreamingState *)audioStreamingState {
    if (audioStreamingState != nil) {
        [parameters setObject:audioStreamingState forKey:SDLNameAudioStreamingState];
    } else {
        [parameters removeObjectForKey:SDLNameAudioStreamingState];
    }
}

- (SDLAudioStreamingState *)audioStreamingState {
    NSObject *obj = [parameters objectForKey:SDLNameAudioStreamingState];
    if (obj == nil || [obj isKindOfClass:SDLAudioStreamingState.class]) {
        return (SDLAudioStreamingState *)obj;
    } else {
        return [SDLAudioStreamingState valueOf:(NSString *)obj];
    }
}

- (void)setSystemContext:(SDLSystemContext *)systemContext {
    if (systemContext != nil) {
        [parameters setObject:systemContext forKey:SDLNameSystemContext];
    } else {
        [parameters removeObjectForKey:SDLNameSystemContext];
    }
}

- (SDLSystemContext *)systemContext {
    NSObject *obj = [parameters objectForKey:SDLNameSystemContext];
    if (obj == nil || [obj isKindOfClass:SDLSystemContext.class]) {
        return (SDLSystemContext *)obj;
    } else {
        return [SDLSystemContext valueOf:(NSString *)obj];
    }
}

@end
