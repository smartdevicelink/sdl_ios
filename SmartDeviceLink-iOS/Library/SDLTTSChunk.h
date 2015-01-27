//  SDLTTSChunk.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLSpeechCapabilities.h"

@interface SDLTTSChunk : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* text;
@property(strong) SDLSpeechCapabilities* type;

@end
