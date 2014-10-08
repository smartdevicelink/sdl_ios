//  SDLGPSData.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLCompassDirection.h>
#import <SmartDeviceLink/SDLDimension.h>

@interface SDLGPSData : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* longitudeDegrees;
@property(strong) NSNumber* latitudeDegrees;
@property(strong) NSNumber* utcYear;
@property(strong) NSNumber* utcMonth;
@property(strong) NSNumber* utcDay;
@property(strong) NSNumber* utcHours;
@property(strong) NSNumber* utcMinutes;
@property(strong) NSNumber* utcSeconds;
@property(strong) SDLCompassDirection* compassDirection;
@property(strong) NSNumber* pdop;
@property(strong) NSNumber* hdop;
@property(strong) NSNumber* vdop;
@property(strong) NSNumber* actual;
@property(strong) NSNumber* satellites;
@property(strong) SDLDimension* dimension;
@property(strong) NSNumber* altitude;
@property(strong) NSNumber* heading;
@property(strong) NSNumber* speed;

@end
