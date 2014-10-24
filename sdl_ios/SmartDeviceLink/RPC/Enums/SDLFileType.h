//  SDLFileType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLFileType : SDLEnum {}

+(SDLFileType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLFileType*) GRAPHIC_BMP;
+(SDLFileType*) GRAPHIC_JPEG;
+(SDLFileType*) GRAPHIC_PNG;
+(SDLFileType*) AUDIO_WAVE;
+(SDLFileType*) AUDIO_MP3;
+(SDLFileType*) AUDIO_AAC;
+(SDLFileType*) BINARY;
+(SDLFileType*) JSON;

@end
