//  SDLPrerecordedSpeech.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLPrerecordedSpeech : SDLEnum {}

+(SDLPrerecordedSpeech*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPrerecordedSpeech*) HELP_JINGLE;
+(SDLPrerecordedSpeech*) INITIAL_JINGLE;
+(SDLPrerecordedSpeech*) LISTEN_JINGLE;
+(SDLPrerecordedSpeech*) POSITIVE_JINGLE;
+(SDLPrerecordedSpeech*) NEGATIVE_JINGLE;

@end
