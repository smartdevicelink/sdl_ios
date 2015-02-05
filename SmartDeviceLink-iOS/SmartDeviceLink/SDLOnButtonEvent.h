//  SDLOnButtonEvent.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLButtonName.h"
#import "SDLButtonEventMode.h"

@interface SDLOnButtonEvent : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLButtonName* buttonName;
@property(strong) SDLButtonEventMode* buttonEventMode;
@property(strong) NSNumber* customButtonID;

@end
