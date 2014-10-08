//  SDLTTSChunkFactory.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>

#import <SmartDeviceLink/SDLJingle.h>
#import <SmartDeviceLink/SDLTTSChunk.h>

@interface SDLTTSChunkFactory : NSObject {}

+(SDLTTSChunk*) buildTTSChunkForString:(NSString*) text type:(SDLSpeechCapabilities*)type;
+(NSMutableArray*) buildTTSChunksFromSimple:(NSString*) simple;

@end
