//  SDLWiperStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLWiperStatus : SDLEnum {}

+(SDLWiperStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLWiperStatus*) OFF;
+(SDLWiperStatus*) AUTO_OFF;
+(SDLWiperStatus*) OFF_MOVING;
+(SDLWiperStatus*) MAN_INT_OFF;
+(SDLWiperStatus*) MAN_INT_ON;
+(SDLWiperStatus*) MAN_LOW;
+(SDLWiperStatus*) MAN_HIGH;
+(SDLWiperStatus*) MAN_FLICK;
+(SDLWiperStatus*) WASH;
+(SDLWiperStatus*) AUTO_LOW;
+(SDLWiperStatus*) AUTO_HIGH;
+(SDLWiperStatus*) COURTESYWIPE;
+(SDLWiperStatus*) AUTO_ADJUST;
+(SDLWiperStatus*) STALLED;
+(SDLWiperStatus*) NO_DATA_EXISTS;

@end
