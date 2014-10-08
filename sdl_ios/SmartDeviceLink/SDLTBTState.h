//  SDLTBTState.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLTBTState : SDLEnum {}

+(SDLTBTState*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLTBTState*) ROUTE_UPDATE_REQUEST;
+(SDLTBTState*) ROUTE_ACCEPTED;
+(SDLTBTState*) ROUTE_REFUSED;
+(SDLTBTState*) ROUTE_CANCELLED;
+(SDLTBTState*) ETA_REQUEST;
+(SDLTBTState*) NEXT_TURN_REQUEST;
+(SDLTBTState*) ROUTE_STATUS_REQUEST;
+(SDLTBTState*) ROUTE_SUMMARY_REQUEST;
+(SDLTBTState*) TRIP_STATUS_REQUEST;
+(SDLTBTState*) ROUTE_UPDATE_REQUEST_TIMEOUT;

@end
