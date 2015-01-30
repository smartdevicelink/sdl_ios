//  SDLOnHMIStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnHMIStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnHMIStatus

-(id) init {
    if (self = [super initWithName:NAMES_OnHMIStatus]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setHmiLevel:(SDLHMILevel *)hmiLevel {
    [parameters setOrRemoveObject:hmiLevel forKey:NAMES_hmiLevel];
}

-(SDLHMILevel*) hmiLevel {
    NSObject* obj = [parameters objectForKey:NAMES_hmiLevel];
    if ([obj isKindOfClass:SDLHMILevel.class]) {
        return (SDLHMILevel*)obj;
    } else {
        return [SDLHMILevel valueOf:(NSString*)obj];
    }
}

- (void)setAudioStreamingState:(SDLAudioStreamingState *)audioStreamingState {
    [parameters setOrRemoveObject:audioStreamingState forKey:NAMES_audioStreamingState];
}

-(SDLAudioStreamingState*) audioStreamingState {
    NSObject* obj = [parameters objectForKey:NAMES_audioStreamingState];
    if ([obj isKindOfClass:SDLAudioStreamingState.class]) {
        return (SDLAudioStreamingState*)obj;
    } else {
        return [SDLAudioStreamingState valueOf:(NSString*)obj];
    }
}

- (void)setSystemContext:(SDLSystemContext *)systemContext {
    [parameters setOrRemoveObject:systemContext forKey:NAMES_systemContext];
}

-(SDLSystemContext*) systemContext {
    NSObject* obj = [parameters objectForKey:NAMES_systemContext];
    if ([obj isKindOfClass:SDLSystemContext.class]) {
        return (SDLSystemContext*)obj;
    } else {
        return [SDLSystemContext valueOf:(NSString*)obj];
    }
}

@end
