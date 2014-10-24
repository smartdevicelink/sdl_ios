//  SDLTouchEvent.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLTouchEvent : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* touchEventId;
@property(strong) NSMutableArray* timeStamp;
@property(strong) NSMutableArray* coord;

@end
