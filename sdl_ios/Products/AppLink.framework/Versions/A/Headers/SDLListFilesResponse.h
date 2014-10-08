//  SDLListFilesResponse.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCResponse.h>

@interface SDLListFilesResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* filenames;
@property(strong) NSNumber* spaceAvailable;

@end
