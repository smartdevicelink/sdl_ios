//  SDLSetDisplayLayoutResponse.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

#import <SmartDeviceLink/SDLDisplayCapabilities.h>
#import <SmartDeviceLink/SDLPresetBankCapabilities.h>

@interface SDLSetDisplayLayoutResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLDisplayCapabilities* displayCapabilities;
@property(strong) NSMutableArray* buttonCapabilities;
@property(strong) NSMutableArray* softButtonCapabilities;
@property(strong) SDLPresetBankCapabilities* presetBankCapabilities;

@end
