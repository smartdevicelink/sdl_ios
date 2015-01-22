//  SDLRegisterAppInterface.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLRegisterAppInterface.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTTSChunk.h>
#import <SmartDeviceLink/SDLAppHMIType.h>

@implementation SDLRegisterAppInterface

-(id) init {
    if (self = [super initWithName:NAMES_RegisterAppInterface]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    [parameters setOrRemoveObject:syncMsgVersion forKey:NAMES_syncMsgVersion];
}

-(SDLSyncMsgVersion*) syncMsgVersion {
    NSObject* obj = [parameters objectForKey:NAMES_syncMsgVersion];
    if ([obj isKindOfClass:SDLSyncMsgVersion.class]) {
        return (SDLSyncMsgVersion*)obj;
    } else {
        return [[SDLSyncMsgVersion alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setAppName:(NSString *)appName {
    [parameters setOrRemoveObject:appName forKey:NAMES_appName];
}

-(NSString*) appName {
    return [parameters objectForKey:NAMES_appName];
}

- (void)setTtsName:(NSMutableArray *)ttsName {
    [parameters setOrRemoveObject:ttsName forKey:NAMES_ttsName];
}

-(NSMutableArray*) ttsName {
    NSMutableArray* array = [parameters objectForKey:NAMES_ttsName];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    [parameters setOrRemoveObject:ngnMediaScreenAppName forKey:NAMES_ngnMediaScreenAppName];
}

-(NSString*) ngnMediaScreenAppName {
    return [parameters objectForKey:NAMES_ngnMediaScreenAppName];
}

- (void)setVrSynonyms:(NSMutableArray *)vrSynonyms {
    [parameters setOrRemoveObject:vrSynonyms forKey:NAMES_vrSynonyms];
}

-(NSMutableArray*) vrSynonyms {
    return [parameters objectForKey:NAMES_vrSynonyms];
}

- (void)setIsMediaApplication:(NSNumber *)isMediaApplication {
    [parameters setOrRemoveObject:isMediaApplication forKey:NAMES_isMediaApplication];
}

-(NSNumber*) isMediaApplication {
    return [parameters objectForKey:NAMES_isMediaApplication];
}

- (void)setLanguageDesired:(SDLLanguage *)languageDesired {
    [parameters setOrRemoveObject:languageDesired forKey:NAMES_languageDesired];
}

-(SDLLanguage*) languageDesired {
    NSObject* obj = [parameters objectForKey:NAMES_languageDesired];
    if ([obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage*)obj;
    } else {
        return [SDLLanguage valueOf:(NSString*)obj];
    }
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage *)hmiDisplayLanguageDesired {
    [parameters setOrRemoveObject:hmiDisplayLanguageDesired forKey:NAMES_hmiDisplayLanguageDesired];
}

-(SDLLanguage*) hmiDisplayLanguageDesired {
    NSObject* obj = [parameters objectForKey:NAMES_hmiDisplayLanguageDesired];
    if ([obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage*)obj;
    } else {
        return [SDLLanguage valueOf:(NSString*)obj];
    }
}

- (void)setAppHMIType:(NSMutableArray *)appHMIType {
    [parameters setOrRemoveObject:appHMIType forKey:NAMES_appHMIType];
}

-(NSMutableArray*) appHMIType {
    NSMutableArray* array = [parameters objectForKey:NAMES_appHMIType];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLAppHMIType.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLAppHMIType valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setHashID:(NSString *)hashID {
    [parameters setOrRemoveObject:hashID forKey:NAMES_hashID];
}

-(NSString*) hashID {
    return [parameters objectForKey:NAMES_hashID];
}

- (void)setDeviceInfo:(SDLDeviceInfo *)deviceInfo {
    [parameters setOrRemoveObject:deviceInfo forKey:NAMES_deviceInfo];
}

-(SDLDeviceInfo*) deviceInfo {
    NSObject* obj = [parameters objectForKey:NAMES_deviceInfo];
    if ([obj isKindOfClass:SDLDeviceInfo.class]) {
        return (SDLDeviceInfo*)obj;
    } else {
        return [[SDLDeviceInfo alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setAppID:(NSString *)appID {
    [parameters setOrRemoveObject:appID forKey:NAMES_appID];
}

-(NSString*) appID {
    return [parameters objectForKey:NAMES_appID];
}

@end
