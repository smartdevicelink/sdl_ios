//
//  SDLProxyALMOptions.h
//  SmartDeviceLink
//
//  Created by Militello, Kevin (K.) on 3/6/15.
//  Copyright (c) 2015 FMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLanguage;
@class SDLSyncMsgVersion;
@class SDLSyncMsgVersion;
@class SDLTTSChunk;
@class SDLBaseTransportConfig;

@interface SDLProxyALMOptions : NSObject

@property (strong, nonatomic) SDLLanguage* languageDesired;
@property (strong, nonatomic) SDLLanguage* hmiDisplayLanguageDesired;
@property (strong, nonatomic) NSString* ngnMediaScreenAppName;
@property (strong, nonatomic) NSArray* vrSynonyms;
@property (strong, nonatomic) SDLSyncMsgVersion* syncMsgVersion;
@property (strong, nonatomic) NSArray* ttsName;
@property (strong, nonatomic) NSString* autoActivateID;
@property (strong, nonatomic) NSNumber* preRegistered;
@property (strong, nonatomic) SDLBaseTransportConfig* transportConfig;
@property (strong, nonatomic) NSArray* appTypes;
@property (strong, nonatomic) NSString* hashID;
@property (strong, nonatomic) NSNumber* appResumeEnabled;

@end