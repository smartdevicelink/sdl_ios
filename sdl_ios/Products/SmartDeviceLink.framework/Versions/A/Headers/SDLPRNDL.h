//  SDLPRNDL.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLPRNDL : SDLEnum {}

+(SDLPRNDL*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPRNDL*) PARK;
+(SDLPRNDL*) REVERSE;
+(SDLPRNDL*) NEUTRAL;
+(SDLPRNDL*) DRIVE;
+(SDLPRNDL*) SPORT;
+(SDLPRNDL*) LOWGEAR;
+(SDLPRNDL*) FIRST;
+(SDLPRNDL*) SECOND;
+(SDLPRNDL*) THIRD;
+(SDLPRNDL*) FOURTH;
+(SDLPRNDL*) FIFTH;
+(SDLPRNDL*) SIXTH;
+(SDLPRNDL*) SEVENTH;
+(SDLPRNDL*) EIGHTH;
+(SDLPRNDL*) UNKNOWN;
+(SDLPRNDL*) FAULT;

@end
