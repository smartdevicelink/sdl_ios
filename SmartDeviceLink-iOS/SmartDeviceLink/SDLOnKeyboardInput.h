//  SDLOnKeyboardInput.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLKeyboardEvent.h"

@interface SDLOnKeyboardInput : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLKeyboardEvent* event;
@property(strong) NSString* data;

@end
