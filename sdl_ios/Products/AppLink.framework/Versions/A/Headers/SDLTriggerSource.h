//  SDLTriggerSource.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLTriggerSource : SDLEnum {}

+(SDLTriggerSource*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLTriggerSource*) MENU;
+(SDLTriggerSource*) VR;
+(SDLTriggerSource*) KEYBOARD;

@end
