//  SDLTTSChunkFactory.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.



#import "SDLJingle.h"
#import "SDLTTSChunk.h"

@interface SDLTTSChunkFactory : NSObject {}

+(SDLTTSChunk*) buildTTSChunkForString:(NSString*) text type:(SDLSpeechCapabilities*)type;
+(NSMutableArray*) buildTTSChunksFromSimple:(NSString*) simple;

@end
