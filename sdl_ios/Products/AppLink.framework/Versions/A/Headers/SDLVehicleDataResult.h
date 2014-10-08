//  SDLVehicleDataResult.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLVehicleDataType.h>
#import <AppLink/SDLVehicleDataResultCode.h>

@interface SDLVehicleDataResult : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataType* dataType;
@property(strong) SDLVehicleDataResultCode* resultCode;

@end
