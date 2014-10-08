//  SDLScrollableMessageResponse.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCResponse.h>

@interface SDLScrollableMessageResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
