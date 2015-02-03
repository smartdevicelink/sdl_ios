//  SDLMenuParams.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLMenuParams : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* parentID;
@property(strong) NSNumber* position;
@property(strong) NSString* menuName;

@end
