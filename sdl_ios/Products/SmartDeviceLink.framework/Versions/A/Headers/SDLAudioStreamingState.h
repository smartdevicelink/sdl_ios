//  SDLAudioStreamingState.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLAudioStreamingState : SDLEnum {}

+(SDLAudioStreamingState*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLAudioStreamingState*) AUDIBLE;
+(SDLAudioStreamingState*) ATTENUATED;
+(SDLAudioStreamingState*) NOT_AUDIBLE;

@end
