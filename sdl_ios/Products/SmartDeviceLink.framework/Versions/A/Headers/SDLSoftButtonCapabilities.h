//  SDLSoftButtonCapabilities.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLSoftButtonCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* shortPressAvailable;
@property(strong) NSNumber* longPressAvailable;
@property(strong) NSNumber* upDownAvailable;
@property(strong) NSNumber* imageSupported;

@end
