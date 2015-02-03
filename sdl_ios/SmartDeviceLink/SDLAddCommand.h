//  SDLAddCommand.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

#import <SmartDeviceLink/SDLMenuParams.h>
#import <SmartDeviceLink/SDLImage.h>

@interface SDLAddCommand : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* cmdID;
@property(strong) SDLMenuParams* menuParams;
@property(strong) NSMutableArray* vrCommands;
@property(strong) SDLImage* cmdIcon;

@end
