//  SDLOnButtonPress.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"

@interface SDLOnButtonPress : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLButtonName* buttonName;
@property(strong) SDLButtonPressMode* buttonPressMode;
@property(strong) NSNumber* customButtonID;

@end
