//  SDLOnAppInterfaceUnregistered.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLAppInterfaceUnregisteredReason.h"

@interface SDLOnAppInterfaceUnregistered : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLAppInterfaceUnregisteredReason* reason;

@end
