//  SDLSyncMsgVersion.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

@interface SDLSyncMsgVersion : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* majorVersion;
@property(strong) NSNumber* minorVersion;

@end
