//  SDLKeyboardLayout.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLKeyboardLayout : SDLEnum {}

+(SDLKeyboardLayout*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLKeyboardLayout*) QWERTY;
+(SDLKeyboardLayout*) QWERTZ;
+(SDLKeyboardLayout*) AZERTY;

@end
