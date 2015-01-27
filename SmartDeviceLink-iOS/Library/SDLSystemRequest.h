//  SDLSystemRequest.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

#import "SDLRequestType.h"

@interface SDLSystemRequest : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLRequestType* requestType;
@property(strong) NSString* fileName;

@end
