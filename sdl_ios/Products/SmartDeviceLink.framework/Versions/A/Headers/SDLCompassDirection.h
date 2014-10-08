//  SDLCompassDirection.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLCompassDirection : SDLEnum {}

+(SDLCompassDirection*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLCompassDirection*) NORTH;
+(SDLCompassDirection*) NORTHWEST;
+(SDLCompassDirection*) WEST;
+(SDLCompassDirection*) SOUTHWEST;
+(SDLCompassDirection*) SOUTH;
+(SDLCompassDirection*) SOUTHEAST;
+(SDLCompassDirection*) EAST;
+(SDLCompassDirection*) NORTHEAST;

@end
