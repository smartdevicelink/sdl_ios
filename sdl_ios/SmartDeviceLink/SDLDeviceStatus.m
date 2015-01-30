//  SDLDeviceStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeviceStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeviceStatus

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setVoiceRecOn:(NSNumber*) voiceRecOn {
    [store setOrRemoveObject:voiceRecOn forKey:NAMES_voiceRecOn];
}

-(NSNumber*) voiceRecOn {
    return [store objectForKey:NAMES_voiceRecOn];
}

-(void) setBtIconOn:(NSNumber*) btIconOn {
    [store setOrRemoveObject:btIconOn forKey:NAMES_btIconOn];
}

-(NSNumber*) btIconOn {
    return [store objectForKey:NAMES_btIconOn];
}

-(void) setCallActive:(NSNumber*) callActive {
    [store setOrRemoveObject:callActive forKey:NAMES_callActive];
}

-(NSNumber*) callActive {
    return [store objectForKey:NAMES_callActive];
}

-(void) setPhoneRoaming:(NSNumber*) phoneRoaming {
    [store setOrRemoveObject:phoneRoaming forKey:NAMES_phoneRoaming];
}

-(NSNumber*) phoneRoaming {
    return [store objectForKey:NAMES_phoneRoaming];
}

-(void) setTextMsgAvailable:(NSNumber*) textMsgAvailable {
    [store setOrRemoveObject:textMsgAvailable forKey:NAMES_textMsgAvailable];
}

-(NSNumber*) textMsgAvailable {
    return [store objectForKey:NAMES_textMsgAvailable];
}

-(void) setBattLevelStatus:(SDLDeviceLevelStatus*) battLevelStatus {
    [store setOrRemoveObject:battLevelStatus forKey:NAMES_battLevelStatus];
}

-(SDLDeviceLevelStatus*) battLevelStatus {
    NSObject* obj = [store objectForKey:NAMES_battLevelStatus];
    if ([obj isKindOfClass:SDLDeviceLevelStatus.class]) {
        return (SDLDeviceLevelStatus*)obj;
    } else {
        return [SDLDeviceLevelStatus valueOf:(NSString*)obj];
    }
}

-(void) setStereoAudioOutputMuted:(NSNumber*) stereoAudioOutputMuted {
    [store setOrRemoveObject:stereoAudioOutputMuted forKey:NAMES_stereoAudioOutputMuted];
}

-(NSNumber*) stereoAudioOutputMuted {
    return [store objectForKey:NAMES_stereoAudioOutputMuted];
}

-(void) setMonoAudioOutputMuted:(NSNumber*) monoAudioOutputMuted {
    [store setOrRemoveObject:monoAudioOutputMuted forKey:NAMES_monoAudioOutputMuted];
}

-(NSNumber*) monoAudioOutputMuted {
    return [store objectForKey:NAMES_monoAudioOutputMuted];
}

-(void) setSignalLevelStatus:(SDLDeviceLevelStatus*) signalLevelStatus {
    [store setOrRemoveObject:signalLevelStatus forKey:NAMES_signalLevelStatus];
}

-(SDLDeviceLevelStatus*) signalLevelStatus {
    NSObject* obj = [store objectForKey:NAMES_signalLevelStatus];
    if ([obj isKindOfClass:SDLDeviceLevelStatus.class]) {
        return (SDLDeviceLevelStatus*)obj;
    } else {
        return [SDLDeviceLevelStatus valueOf:(NSString*)obj];
    }
}

-(void) setPrimaryAudioSource:(SDLPrimaryAudioSource*) primaryAudioSource {
    [store setOrRemoveObject:primaryAudioSource forKey:NAMES_primaryAudioSource];
}

-(SDLPrimaryAudioSource*) primaryAudioSource {
    NSObject* obj = [store objectForKey:NAMES_primaryAudioSource];
    if ([obj isKindOfClass:SDLPrimaryAudioSource.class]) {
        return (SDLPrimaryAudioSource*)obj;
    } else {
        return [SDLPrimaryAudioSource valueOf:(NSString*)obj];
    }
}

-(void) setECallEventActive:(NSNumber*) eCallEventActive {
    [store setOrRemoveObject:eCallEventActive forKey:NAMES_eCallEventActive];
}

-(NSNumber*) eCallEventActive {
    return [store objectForKey:NAMES_eCallEventActive];
}

@end
