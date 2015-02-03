//  SDLListFiles.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

@interface SDLListFiles : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
