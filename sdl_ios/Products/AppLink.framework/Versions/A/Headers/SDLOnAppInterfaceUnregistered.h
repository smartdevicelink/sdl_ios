//  SDLOnAppInterfaceUnregistered.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCNotification.h>

#import <AppLink/SDLAppInterfaceUnregisteredReason.h>

@interface SDLOnAppInterfaceUnregistered : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLAppInterfaceUnregisteredReason* reason;

@end
