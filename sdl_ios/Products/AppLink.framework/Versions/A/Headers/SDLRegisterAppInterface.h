//  SDLRegisterAppInterface.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCRequest.h>

#import <AppLink/SDLSyncMsgVersion.h>
#import <AppLink/SDLLanguage.h>
#import <AppLink/SDLDeviceInfo.h>

@interface SDLRegisterAppInterface : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLSyncMsgVersion* syncMsgVersion;
@property(strong) NSString* appName;
@property(strong) NSMutableArray* ttsName;
@property(strong) NSString* ngnMediaScreenAppName;
@property(strong) NSMutableArray* vrSynonyms;
@property(strong) NSNumber* isMediaApplication;
@property(strong) SDLLanguage* languageDesired;
@property(strong) SDLLanguage* hmiDisplayLanguageDesired;
@property(strong) NSMutableArray* appHMIType;
@property(strong) NSString* hashID;
@property(strong) SDLDeviceInfo* deviceInfo;
@property(strong) NSString* appID;

@end
