//  SDLKeyboardEvent.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLKeyboardEvent : SDLEnum {}

+(SDLKeyboardEvent*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLKeyboardEvent*) KEYPRESS;
+(SDLKeyboardEvent*) ENTRY_SUBMITTED;
+(SDLKeyboardEvent*) ENTRY_CANCELLED;
+(SDLKeyboardEvent*) ENTRY_ABORTED;

@end
