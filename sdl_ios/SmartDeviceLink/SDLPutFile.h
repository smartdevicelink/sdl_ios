//  SDLPutFile.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

#import "SDLFileType.h"

@interface SDLPutFile : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* syncFileName;
@property(strong) SDLFileType* fileType;
@property(strong) NSNumber* persistentFile;
@property(strong) NSNumber* systemFile;
@property(strong) NSNumber* offset;
@property(strong) NSNumber* length;

@end
