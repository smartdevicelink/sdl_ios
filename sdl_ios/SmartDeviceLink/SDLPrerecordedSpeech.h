//  SDLPrerecordedSpeech.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLPrerecordedSpeech : SDLEnum {}

+(SDLPrerecordedSpeech*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPrerecordedSpeech*) HELP_JINGLE;
+(SDLPrerecordedSpeech*) INITIAL_JINGLE;
+(SDLPrerecordedSpeech*) LISTEN_JINGLE;
+(SDLPrerecordedSpeech*) POSITIVE_JINGLE;
+(SDLPrerecordedSpeech*) NEGATIVE_JINGLE;

@end
