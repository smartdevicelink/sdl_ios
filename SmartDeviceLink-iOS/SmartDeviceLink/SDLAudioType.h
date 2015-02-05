//  SDLAudioType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLAudioType : SDLEnum {}

+(SDLAudioType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLAudioType*) PCM;

@end
