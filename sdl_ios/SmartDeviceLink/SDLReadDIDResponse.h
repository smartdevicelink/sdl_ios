//  SDLReadDIDResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCResponse.h"

@interface SDLReadDIDResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* didResult;

@end
