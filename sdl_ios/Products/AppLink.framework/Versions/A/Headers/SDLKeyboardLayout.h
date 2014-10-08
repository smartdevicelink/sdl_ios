//  SDLKeyboardLayout.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLKeyboardLayout : SDLEnum {}

+(SDLKeyboardLayout*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLKeyboardLayout*) QWERTY;
+(SDLKeyboardLayout*) QWERTZ;
+(SDLKeyboardLayout*) AZERTY;

@end
