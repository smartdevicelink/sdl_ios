//  SDLScrollableMessage.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

@interface SDLScrollableMessage : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* scrollableMessageBody;
@property(strong) NSNumber* timeout;
@property(strong) NSMutableArray* softButtons;

@end
