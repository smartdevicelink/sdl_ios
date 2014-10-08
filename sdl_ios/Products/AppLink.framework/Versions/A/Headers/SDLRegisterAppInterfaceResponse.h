//  SDLRegisterAppInterfaceResponse.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCResponse.h>

#import <AppLink/SDLSyncMsgVersion.h>
#import <AppLink/SDLLanguage.h>
#import <AppLink/SDLDisplayCapabilities.h>
#import <AppLink/SDLPresetBankCapabilities.h>
#import <AppLink/SDLVehicleType.h>

@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLSyncMsgVersion* syncMsgVersion;
@property(strong) SDLLanguage* language;
@property(strong) SDLLanguage* hmiDisplayLanguage;
@property(strong) SDLDisplayCapabilities* displayCapabilities;
@property(strong) NSMutableArray* buttonCapabilities;
@property(strong) NSMutableArray* softButtonCapabilities;
@property(strong) SDLPresetBankCapabilities* presetBankCapabilities;
@property(strong) NSMutableArray* hmiZoneCapabilities;
@property(strong) NSMutableArray* speechCapabilities;
@property(strong) NSMutableArray* prerecordedSpeech;
@property(strong) NSMutableArray* vrCapabilities;
@property(strong) NSMutableArray* audioPassThruCapabilities;
@property(strong) SDLVehicleType* vehicleType;
@property(strong) NSMutableArray* supportedDiagModes;

@end
