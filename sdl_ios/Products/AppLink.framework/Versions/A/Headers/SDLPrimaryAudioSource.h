//  SDLPrimaryAudioSource.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLPrimaryAudioSource : SDLEnum {}

+(SDLPrimaryAudioSource*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPrimaryAudioSource*) NO_SOURCE_SELECTED;
+(SDLPrimaryAudioSource*) USB;
+(SDLPrimaryAudioSource*) USB2;
+(SDLPrimaryAudioSource*) BLUETOOTH_STEREO_BTST;
+(SDLPrimaryAudioSource*) LINE_IN;
+(SDLPrimaryAudioSource*) IPOD;
+(SDLPrimaryAudioSource*) MOBILE_APP;

@end
