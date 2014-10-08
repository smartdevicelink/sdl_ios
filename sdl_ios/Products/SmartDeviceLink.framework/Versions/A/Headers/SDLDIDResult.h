//  SDLDIDResult.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLVehicleDataResultCode.h>

@interface SDLDIDResult : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataResultCode* resultCode;
@property(strong) NSNumber* didLocation;
@property(strong) NSString* data;

@end
