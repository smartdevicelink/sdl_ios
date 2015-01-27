//  SDLRPCResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLResult.h"

@interface SDLRPCResponse : SDLRPCMessage {}

@property(strong) NSNumber* correlationID;
@property(strong) NSNumber* success;
@property(strong) SDLResult* resultCode;
@property(strong) NSString* info;

@end
