//  SDLOnCommand.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLTriggerSource.h"

@interface SDLOnCommand : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* cmdID;
@property(strong) SDLTriggerSource* triggerSource;

@end
