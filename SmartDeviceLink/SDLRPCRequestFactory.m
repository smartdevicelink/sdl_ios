//  SDLRPCRequestFactory.m
//

#import "SDLRPCRequestFactory.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

#import "SDLAddCommand.h"
#import "SDLAddSubMenu.h"
#import "SDLAlert.h"
#import "SDLAlertManeuver.h"
#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLChangeRegistration.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLDebugTool.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteFile.h"
#import "SDLDeleteInteractionChoiceSet.h"
#import "SDLDeleteSubMenu.h"
#import "SDLDeviceInfo.h"
#import "SDLDialNumber.h"
#import "SDLEndAudioPassThru.h"
#import "SDLGetDTCs.h"
#import "SDLGetVehicleData.h"
#import "SDLImage.h"
#import "SDLListFiles.h"
#import "SDLMenuParams.h"
#import "SDLPerformAudioPassThru.h"
#import "SDLPerformInteraction.h"
#import "SDLPutFile.h"
#import "SDLReadDID.h"
#import "SDLRegisterAppInterface.h"
#import "SDLResetGlobalProperties.h"
#import "SDLScrollableMessage.h"
#import "SDLSendLocation.h"
#import "SDLSetAppIcon.h"
#import "SDLSetDisplayLayout.h"
#import "SDLSetGlobalProperties.h"
#import "SDLSetMediaClockTimer.h"
#import "SDLShow.h"
#import "SDLShowConstantTBT.h"
#import "SDLSlider.h"
#import "SDLSoftButton.h"
#import "SDLSpeak.h"
#import "SDLSpeechCapabilities.h"
#import "SDLStartTime.h"
#import "SDLSubscribeButton.h"
#import "SDLSubscribeVehicleData.h"
#import "SDLSyncMsgVersion.h"
#import "SDLTTSChunk.h"
#import "SDLUnregisterAppInterface.h"
#import "SDLUnsubscribeButton.h"
#import "SDLUnsubscribeVehicleData.h"
#import "SDLUpdateTurnList.h"

static NSString *const SDLBundleShortVersionStringKey = @"CFBundleShortVersionString";

@implementation SDLRPCRequestFactory

//***** AddCommand *****
+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName parentID:(NSNumber<SDLInt> *)parentID position:(NSNumber<SDLInt> *)position vrCommands:(NSArray<NSString *> *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType)iconType correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLAddCommand *msg = [[SDLAddCommand alloc] init];

    msg.cmdID = cmdID;

    if (menuName != nil || parentID != nil || position != nil) {
        SDLMenuParams *menuParams = [[SDLMenuParams alloc] init];
        menuParams.menuName = menuName;
        menuParams.parentID = parentID;
        menuParams.position = position;
        msg.menuParams = menuParams;
    }
    msg.vrCommands = [vrCommands mutableCopy];

    if (iconValue != nil || iconType != nil) {
        SDLImage *icon = [[SDLImage alloc] init];
        icon.value = iconValue;
        icon.imageType = iconType;
        msg.cmdIcon = icon;
    }

    msg.correlationID = correlationID;

    return msg;
}

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName parentID:(NSNumber<SDLInt> *)parentID position:(NSNumber<SDLInt> *)position vrCommands:(NSArray<NSString *> *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType)iconType handler:(SDLRPCNotificationHandler)handler {
    SDLAddCommand *msg = [[SDLAddCommand alloc] initWithHandler:handler];

    msg.cmdID = cmdID;

    if (menuName != nil || parentID != nil || position != nil) {
        SDLMenuParams *menuParams = [[SDLMenuParams alloc] init];
        menuParams.menuName = menuName;
        menuParams.parentID = parentID;
        menuParams.position = position;
        msg.menuParams = menuParams;
    }
    msg.vrCommands = [vrCommands mutableCopy];

    if (iconValue != nil || iconType != nil) {
        SDLImage *icon = [[SDLImage alloc] init];
        icon.value = iconValue;
        icon.imageType = iconType;
        msg.cmdIcon = icon;
    }

    return msg;
}

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAddCommandWithID:cmdID menuName:menuName parentID:nil position:nil vrCommands:vrCommands iconValue:nil iconType:nil correlationID:correlationID];
}

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands handler:(SDLRPCNotificationHandler)handler {
    return [SDLRPCRequestFactory buildAddCommandWithID:cmdID menuName:menuName parentID:nil position:nil vrCommands:vrCommands iconValue:nil iconType:nil handler:handler];
}

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID vrCommands:(NSArray<NSString *> *)vrCommands correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAddCommandWithID:cmdID menuName:nil vrCommands:vrCommands correlationID:correlationID];
}

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID vrCommands:(NSArray<NSString *> *)vrCommands handler:(SDLRPCNotificationHandler)handler {
    return [SDLRPCRequestFactory buildAddCommandWithID:cmdID menuName:nil vrCommands:vrCommands handler:handler];
}
//*****


//***** AddSubMenu *****
+ (SDLAddSubMenu *)buildAddSubMenuWithID:(NSNumber<SDLInt> *)menuID menuName:(NSString *)menuName position:(NSNumber<SDLInt> *)position correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLAddSubMenu *msg = [[SDLAddSubMenu alloc] init];
    msg.correlationID = correlationID;
    msg.menuID = menuID;
    msg.menuName = menuName;
    msg.position = position;
    return msg;
}

+ (SDLAddSubMenu *)buildAddSubMenuWithID:(NSNumber<SDLInt> *)menuID menuName:(NSString *)menuName correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAddSubMenuWithID:menuID menuName:menuName position:nil correlationID:correlationID];
}
//*****


//***** Alert *****
+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(NSNumber<SDLBool> *)playTone duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLTTSChunk *simpleChunk = [[SDLTTSChunk alloc] init];
    simpleChunk.text = ttsText;
    simpleChunk.type = SDLSpeechCapabilitiesText;
    NSArray<SDLTTSChunk *> *ttsChunks = [NSArray arrayWithObject:simpleChunk];

    return [SDLRPCRequestFactory buildAlertWithTTSChunks:ttsChunks alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:playTone duration:duration softButtons:nil correlationID:correlationID];
}

+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 playTone:(NSNumber<SDLBool> *)playTone duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAlertWithTTS:ttsText alertText1:alertText1 alertText2:alertText2 alertText3:nil playTone:playTone duration:duration correlationID:correlationID];
}

+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText playTone:(NSNumber<SDLBool> *)playTone correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAlertWithTTS:ttsText alertText1:nil alertText2:nil alertText3:nil playTone:playTone duration:nil correlationID:correlationID];
}

//***
+ (SDLAlert *)buildAlertWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(NSNumber<SDLBool> *)playTone duration:(NSNumber<SDLInt> *)duration softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLAlert *msg = [[SDLAlert alloc] init];
    msg.correlationID = correlationID;
    msg.alertText1 = alertText1;
    msg.alertText2 = alertText2;
    msg.alertText3 = alertText3;
    msg.ttsChunks = [ttsChunks mutableCopy];
    msg.playTone = playTone;
    msg.duration = duration;
    msg.softButtons = [softButtons mutableCopy];
    return msg;
}

+ (SDLAlert *)buildAlertWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks playTone:(NSNumber<SDLBool> *)playTone correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAlertWithTTSChunks:ttsChunks alertText1:nil alertText2:nil alertText3:nil playTone:playTone duration:nil softButtons:nil correlationID:correlationID];
}

//***
+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(NSNumber<SDLInt> *)duration softButtons:(NSMutableArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAlertWithTTSChunks:nil alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:nil duration:duration softButtons:softButtons correlationID:correlationID];
}

+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAlertWithTTSChunks:nil alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:nil duration:duration softButtons:nil correlationID:correlationID];
}

+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildAlertWithTTSChunks:nil alertText1:alertText1 alertText2:alertText2 alertText3:nil playTone:nil duration:duration softButtons:nil correlationID:correlationID];
}
//*****


+ (SDLAlertManeuver *)buildAlertManeuverwithTTSchunks:(NSMutableArray<SDLTTSChunk *> *)ttsChunks softButtons:(NSMutableArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLAlertManeuver *msg = [[SDLAlertManeuver alloc] init];
    msg.ttsChunks = ttsChunks;
    msg.softButtons = softButtons;
    msg.correlationID = correlationID;
    return msg;
}

+ (SDLChangeRegistration *)buildChangeRegistrationWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLChangeRegistration *msg = [[SDLChangeRegistration alloc] init];
    msg.language = language;
    msg.hmiDisplayLanguage = hmiDisplayLanguage;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLCreateInteractionChoiceSet *)buildCreateInteractionChoiceSetWithID:(NSNumber<SDLInt> *)interactionChoiceSetID choiceSet:(NSArray<SDLChoice *> *)choices correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLCreateInteractionChoiceSet *msg = [[SDLCreateInteractionChoiceSet alloc] init];
    msg.interactionChoiceSetID = interactionChoiceSetID;
    msg.choiceSet = [choices mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLDeleteCommand *)buildDeleteCommandWithID:(NSNumber<SDLInt> *)cmdID correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLDeleteCommand *msg = [[SDLDeleteCommand alloc] init];
    msg.cmdID = cmdID;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLDeleteFile *)buildDeleteFileWithName:(NSString *)syncFileName correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLDeleteFile *msg = [[SDLDeleteFile alloc] init];
    msg.syncFileName = syncFileName;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLDialNumber *)buildDialNumberWithNumber:(NSString *)phoneNumber {
    SDLDialNumber *msg = [[SDLDialNumber alloc] init];
    msg.number = phoneNumber;

    return msg;
}

+ (SDLListFiles *)buildListFilesWithCorrelationID:(NSNumber<SDLInt> *)correlationID {
    SDLListFiles *msg = [[SDLListFiles alloc] init];
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLDeleteInteractionChoiceSet *)buildDeleteInteractionChoiceSetWithID:(NSNumber<SDLInt> *)interactionChoiceSetID correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLDeleteInteractionChoiceSet *msg = [[SDLDeleteInteractionChoiceSet alloc] init];
    msg.interactionChoiceSetID = interactionChoiceSetID;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLDeleteSubMenu *)buildDeleteSubMenuWithID:(NSNumber<SDLInt> *)menuID correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLDeleteSubMenu *msg = [[SDLDeleteSubMenu alloc] init];
    msg.menuID = menuID;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLEndAudioPassThru *)buildEndAudioPassThruWithCorrelationID:(NSNumber<SDLInt> *)correlationID {
    SDLEndAudioPassThru *msg = [[SDLEndAudioPassThru alloc] init];
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLGetDTCs *)buildGetDTCsWithECUName:(NSNumber<SDLInt> *)ecuName correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLGetDTCs *msg = [[SDLGetDTCs alloc] init];
    msg.ecuName = ecuName;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLGetVehicleData *)buildGetVehicleDataWithGPS:(NSNumber<SDLBool> *)gps speed:(NSNumber<SDLBool> *)speed rpm:(NSNumber<SDLBool> *)rpm fuelLevel:(NSNumber<SDLBool> *)fuelLevel fuelLevelState:(NSNumber<SDLBool> *)fuelLevelState instantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption externalTemperature:(NSNumber<SDLBool> *)externalTemperature vin:(NSNumber<SDLBool> *)vin prndl:(NSNumber<SDLBool> *)prndl tirePressure:(NSNumber<SDLBool> *)tirePressure odometer:(NSNumber<SDLBool> *)odometer beltStatus:(NSNumber<SDLBool> *)beltStatus bodyInformation:(NSNumber<SDLBool> *)bodyInformation deviceStatus:(NSNumber<SDLBool> *)deviceStatus driverBraking:(NSNumber<SDLBool> *)driverBraking wiperStatus:(NSNumber<SDLBool> *)wiperStatus headLampStatus:(NSNumber<SDLBool> *)headLampStatus engineTorque:(NSNumber<SDLBool> *)engineTorque accPedalPosition:(NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLGetVehicleData *msg = [[SDLGetVehicleData alloc] init];
    msg.gps = gps;
    msg.speed = speed;
    msg.rpm = rpm;
    msg.fuelLevel = fuelLevel;
    msg.fuelLevel_State = fuelLevelState;
    msg.instantFuelConsumption = instantFuelConsumption;
    msg.externalTemperature = externalTemperature;
    msg.vin = vin;
    msg.prndl = prndl;
    msg.tirePressure = tirePressure;
    msg.odometer = odometer;
    msg.beltStatus = beltStatus;
    msg.bodyInformation = bodyInformation;
    msg.deviceStatus = deviceStatus;
    msg.driverBraking = driverBraking;
    msg.wiperStatus = wiperStatus;
    msg.headLampStatus = headLampStatus;
    msg.engineTorque = engineTorque;
    msg.accPedalPosition = accPedalPosition;
    msg.steeringWheelAngle = steeringWheelAngle;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLPerformAudioPassThru *)buildPerformAudioPassThruWithInitialPrompt:(NSString *)initialPrompt audioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate maxDuration:(NSNumber<SDLInt> *)maxDuration bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType muteAudio:(NSNumber<SDLBool> *)muteAudio correlationID:(NSNumber<SDLInt> *)correlationID {
    NSArray<SDLTTSChunk *> *initialChunks = [SDLTTSChunk textChunksFromString:initialPrompt];

    SDLPerformAudioPassThru *msg = [[SDLPerformAudioPassThru alloc] init];
    msg.initialPrompt = [initialChunks mutableCopy];
    msg.audioPassThruDisplayText1 = audioPassThruDisplayText1;
    msg.audioPassThruDisplayText2 = audioPassThruDisplayText2;
    msg.samplingRate = samplingRate;
    msg.maxDuration = maxDuration;
    msg.bitsPerSample = bitsPerSample;
    msg.audioType = audioType;
    msg.muteAudio = muteAudio;
    msg.correlationID = correlationID;

    return msg;
}


//***** PerformInteraction *****
+ (SDLPerformInteraction *)buildPerformInteractionWithInitialChunks:(NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber *> *)interactionChoiceSetIDList helpChunks:(NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(NSNumber<SDLInt> *)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLPerformInteraction *msg = [[SDLPerformInteraction alloc] init];
    msg.initialPrompt = [initialChunks mutableCopy];
    msg.initialText = initialText;
    msg.interactionChoiceSetIDList = [interactionChoiceSetIDList mutableCopy];
    msg.helpPrompt = [helpChunks mutableCopy];
    msg.timeoutPrompt = [timeoutChunks mutableCopy];
    msg.interactionMode = interactionMode;
    msg.timeout = timeout;
    msg.vrHelp = [vrHelp mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}

//***
+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(NSNumber<SDLInt> *)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID {
    NSArray<SDLTTSChunk *> *initialChunks = [SDLTTSChunk textChunksFromString:initialPrompt];
    NSArray<SDLTTSChunk *> *helpChunks = [SDLTTSChunk textChunksFromString:helpPrompt];
    NSArray<SDLTTSChunk *> *timeoutChunks = [SDLTTSChunk textChunksFromString:timeoutPrompt];

    return [SDLRPCRequestFactory buildPerformInteractionWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:interactionMode timeout:timeout vrHelp:vrHelp correlationID:correlationID];
}

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(NSNumber<SDLInt> *)interactionChoiceSetID vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID {
    NSArray<NSNumber *> *interactionChoiceSetIDList = [NSArray arrayWithObject:interactionChoiceSetID];
    NSArray<SDLTTSChunk *> *initialChunks = [SDLTTSChunk textChunksFromString:initialPrompt];

    return [SDLRPCRequestFactory buildPerformInteractionWithInitialChunks:initialChunks initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpChunks:nil timeoutChunks:nil interactionMode:SDLInteractionModeBoth timeout:nil vrHelp:vrHelp correlationID:correlationID];
}

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(NSNumber<SDLInt> *)timeout correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildPerformInteractionWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetIDList:interactionChoiceSetIDList helpPrompt:helpPrompt timeoutPrompt:timeoutPrompt interactionMode:interactionMode timeout:timeout vrHelp:nil correlationID:(NSNumber<SDLInt> *)correlationID];
}

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(NSNumber<SDLInt> *)interactionChoiceSetID correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildPerformInteractionWithInitialPrompt:initialPrompt initialText:initialText interactionChoiceSetID:interactionChoiceSetID vrHelp:nil correlationID:correlationID];
}
//*****

+ (SDLPutFile *)buildPutFileWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(NSNumber<SDLBool> *)persistentFile correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLPutFile *msg = [[SDLPutFile alloc] init];
    msg.syncFileName = fileName;

    msg.fileType = fileType;
    msg.persistentFile = persistentFile;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLPutFile *)buildPutFileWithFileName:(NSString *)syncFileName fileType:(SDLFileType)fileType persisistentFile:(NSNumber<SDLBool> *)persistentFile correlationID:(NSNumber<SDLInt> *)correlationID {
    return [self buildPutFileWithFileName:syncFileName fileType:fileType persistentFile:persistentFile correlationID:correlationID];
}

+ (SDLReadDID *)buildReadDIDWithECUName:(NSNumber<SDLInt> *)ecuName didLocation:(NSArray<NSNumber *> *)didLocation correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLReadDID *msg = [[SDLReadDID alloc] init];
    msg.ecuName = ecuName;
    msg.didLocation = [didLocation mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}

//***** RegisterAppInterface *****
+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName ttsName:(NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(NSArray<NSString *> *)vrSynonyms isMediaApp:(NSNumber<SDLFloat> *)isMediaApp languageDesired:(SDLLanguage)languageDesired hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired appID:(NSString *)appID {
    SDLRegisterAppInterface *msg = [[SDLRegisterAppInterface alloc] init];
    SDLSyncMsgVersion *version = [[SDLSyncMsgVersion alloc] init];
    version.majorVersion = [NSNumber numberWithInt:1];
    version.minorVersion = [NSNumber numberWithInt:0];
    msg.syncMsgVersion = version;
    msg.appName = appName;
    msg.ttsName = [ttsName mutableCopy];
    msg.ngnMediaScreenAppName = appName;
    msg.vrSynonyms = [vrSynonyms mutableCopy];
    msg.isMediaApplication = isMediaApp;
    msg.languageDesired = languageDesired;
    msg.hmiDisplayLanguageDesired = hmiDisplayLanguageDesired;
    msg.appID = appID;
    msg.deviceInfo = [self sdl_buildDeviceInfo];
    msg.correlationID = [NSNumber numberWithInt:1];
    SDLAppInfo *appInfo = [self sdl_buildAppInfo];
    appInfo.appDisplayName = appName;
    msg.appInfo = appInfo;
    return msg;
}

+ (SDLDeviceInfo *)sdl_buildDeviceInfo {
    SDLDeviceInfo *deviceInfo = [[SDLDeviceInfo alloc] init];
    deviceInfo.hardware = [UIDevice currentDevice].model;
    deviceInfo.os = [UIDevice currentDevice].systemName;
    deviceInfo.osVersion = [UIDevice currentDevice].systemVersion;
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = netinfo.subscriberCellularProvider;
    NSString *carrierName = carrier.carrierName;
    deviceInfo.carrier = carrierName;

    return deviceInfo;
}

+ (SDLAppInfo *)sdl_buildAppInfo {
    SDLAppInfo *appInfo = [[SDLAppInfo alloc] init];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSDictionary *bundleDictionary = mainBundle.infoDictionary;
    appInfo.appVersion = bundleDictionary[SDLBundleShortVersionStringKey];
    appInfo.appBundleID = mainBundle.bundleIdentifier;
    return appInfo;
}

+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName isMediaApp:(NSNumber<SDLFloat> *)isMediaApp languageDesired:(SDLLanguage)languageDesired appID:(NSString *)appID {
    NSMutableArray<NSString *> *syns = [NSMutableArray arrayWithObject:appName];
    return [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:appName ttsName:nil vrSynonyms:syns isMediaApp:isMediaApp languageDesired:languageDesired hmiDisplayLanguageDesired:languageDesired appID:appID];
}

+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName languageDesired:(SDLLanguage)languageDesired appID:(NSString *)appID {
    return [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:appName isMediaApp:@NO languageDesired:languageDesired appID:appID];
}
//*****


+ (SDLResetGlobalProperties *)buildResetGlobalPropertiesWithProperties:(NSArray<SDLGlobalProperty> *)properties correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLResetGlobalProperties *msg = [[SDLResetGlobalProperties alloc] init];
    msg.properties = [properties mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLScrollableMessage *)buildScrollableMessage:(NSString *)scrollableMessageBody timeout:(NSNumber<SDLInt> *)timeout softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLScrollableMessage *msg = [[SDLScrollableMessage alloc] init];
    msg.scrollableMessageBody = scrollableMessageBody;
    msg.timeout = timeout;
    msg.softButtons = [softButtons mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLSendLocation *)buildSendLocationWithLongitude:(NSNumber<SDLFloat> *)longitude latitude:(NSNumber<SDLFloat> *)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription address:(NSArray<NSString *> *)address phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image {
    SDLSendLocation *msg = [[SDLSendLocation alloc] init];
    msg.longitudeDegrees = longitude;
    msg.latitudeDegrees = latitude;
    msg.locationName = locationName;
    msg.locationDescription = locationDescription;
    msg.addressLines = address;
    msg.phoneNumber = phoneNumber;
    msg.locationImage = image;

    return msg;
}

+ (SDLSetAppIcon *)buildSetAppIconWithFileName:(NSString *)syncFileName correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSetAppIcon *msg = [[SDLSetAppIcon alloc] init];
    msg.syncFileName = syncFileName;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLSetDisplayLayout *)buildSetDisplayLayout:(NSString *)displayLayout correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSetDisplayLayout *msg = [[SDLSetDisplayLayout alloc] init];
    msg.displayLayout = displayLayout;
    msg.correlationID = correlationID;

    return msg;
}


//***** SetGlobalProperties *****
+ (SDLSetGlobalProperties *)buildSetGlobalPropertiesWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSetGlobalProperties *msg = [[SDLSetGlobalProperties alloc] init];
    msg.helpPrompt = [SDLTTSChunk textChunksFromString:helpText];
    msg.timeoutPrompt = [SDLTTSChunk textChunksFromString:timeoutText];
    msg.vrHelpTitle = vrHelpTitle;
    msg.vrHelp = [vrHelp mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLSetGlobalProperties *)buildSetGlobalPropertiesWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSetGlobalProperties *msg = [[SDLSetGlobalProperties alloc] init];
    msg.helpPrompt = [SDLTTSChunk textChunksFromString:helpText];
    msg.timeoutPrompt = [SDLTTSChunk textChunksFromString:timeoutText];
    msg.correlationID = correlationID;

    return msg;
}
//*****


//***** SetMediaClockTimer *****
+ (SDLSetMediaClockTimer *)buildSetMediaClockTimerWithHours:(NSNumber<SDLInt> *)hours minutes:(NSNumber<SDLInt> *)minutes seconds:(NSNumber<SDLInt> *)seconds updateMode:(SDLUpdateMode)updateMode correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSetMediaClockTimer *msg = [[SDLSetMediaClockTimer alloc] init];
    SDLStartTime *startTime = [[SDLStartTime alloc] init];
    startTime.hours = hours;
    startTime.minutes = minutes;
    startTime.seconds = seconds;
    msg.startTime = startTime;
    msg.updateMode = updateMode;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLSetMediaClockTimer *)buildSetMediaClockTimerWithUpdateMode:(SDLUpdateMode)updateMode correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSetMediaClockTimer *msg = [[SDLSetMediaClockTimer alloc] init];
    msg.updateMode = updateMode;
    msg.correlationID = correlationID;

    return msg;
}
//*****


//***** Show *****
+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack alignment:(SDLTextAlignment)textAlignment graphic:(SDLImage *)graphic softButtons:(NSArray<SDLSoftButton *> *)softButtons customPresets:(NSArray<NSString *> *)customPresets correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLShow *msg = [[SDLShow alloc] init];
    msg.correlationID = correlationID;
    msg.mainField1 = mainField1;
    msg.mainField2 = mainField2;
    msg.mainField3 = mainField3;
    msg.mainField4 = mainField4;
    msg.statusBar = statusBar;
    msg.mediaClock = mediaClock;
    msg.mediaTrack = mediaTrack;
    msg.alignment = textAlignment;
    msg.graphic = graphic;
    msg.softButtons = [softButtons mutableCopy];
    msg.customPresets = [customPresets mutableCopy];

    return msg;
}

+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack alignment:(SDLTextAlignment)textAlignment correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLShow *msg = [[SDLShow alloc] init];
    msg.correlationID = correlationID;
    msg.mainField1 = mainField1;
    msg.mainField2 = mainField2;
    msg.statusBar = statusBar;
    msg.mediaClock = mediaClock;
    msg.mediaTrack = mediaTrack;
    msg.alignment = textAlignment;

    return msg;
}

+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 alignment:(SDLTextAlignment)alignment correlationID:(NSNumber<SDLInt> *)correlationID {
    return [SDLRPCRequestFactory buildShowWithMainField1:mainField1 mainField2:mainField2 statusBar:nil mediaClock:nil mediaTrack:nil alignment:alignment correlationID:correlationID];
}

+ (SDLShowConstantTBT *)buildShowConstantTBTWithString:(NSString *)navigationText1 navigationText2:(NSString *)navigationText2 eta:(NSString *)eta timeToDestination:(NSString *)timeToDestination totalDistance:(NSString *)totalDistance turnIcon:(SDLImage *)turnIcon nextTurnIcon:(SDLImage *)nextTurnIcon distanceToManeuver:(NSNumber<SDLFloat> *)distanceToManeuver distanceToManeuverScale:(NSNumber<SDLFloat> *)distanceToManeuverScale maneuverComplete:(NSNumber<SDLBool> *)maneuverComplete softButtons:(NSMutableArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLShowConstantTBT *msg = [[SDLShowConstantTBT alloc] init];
    msg.navigationText1 = navigationText1;
    msg.navigationText2 = navigationText2;
    msg.eta = eta;
    msg.timeToDestination = timeToDestination;
    msg.totalDistance = totalDistance;
    msg.turnIcon = turnIcon;
    msg.nextTurnIcon = nextTurnIcon;
    msg.distanceToManeuver = distanceToManeuver;
    msg.distanceToManeuverScale = distanceToManeuverScale;
    msg.maneuverComplete = maneuverComplete;
    msg.softButtons = [softButtons mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}
//*****


//***** Slider *****
+ (SDLSlider *)buildSliderDynamicFooterWithNumTicks:(NSNumber<SDLInt> *)numTicks position:(NSNumber<SDLInt> *)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSArray<NSString *> *)sliderFooter timeout:(NSNumber<SDLInt> *)timeout correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSlider *msg = [[SDLSlider alloc] init];
    msg.correlationID = correlationID;
    msg.numTicks = numTicks;
    msg.position = position;
    msg.sliderHeader = sliderHeader;
    msg.sliderFooter = [sliderFooter mutableCopy];
    msg.timeout = timeout;

    return msg;
}

+ (SDLSlider *)buildSliderStaticFooterWithNumTicks:(NSNumber<SDLInt> *)numTicks position:(NSNumber<SDLInt> *)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSString *)sliderFooter timeout:(NSNumber<SDLInt> *)timeout correlationID:(NSNumber<SDLInt> *)correlationID {
    NSArray<NSString *> *sliderFooters = [NSArray arrayWithObject:sliderFooter];

    // Populates array with the same footer value for each position
    for (UInt32 i = 1; i < numTicks.unsignedIntegerValue; i++) {
        sliderFooters = [sliderFooters arrayByAddingObject:sliderFooter];
    }

    return [SDLRPCRequestFactory buildSliderDynamicFooterWithNumTicks:numTicks position:position sliderHeader:sliderHeader sliderFooter:sliderFooters timeout:timeout correlationID:correlationID];
}
//*****

+ (SDLSoftButton *)buildSoftButtonWithType:(SDLSoftButtonType)type text:(NSString *)text image:(SDLImage *)image highlighted:(BOOL)highlighted buttonID:(UInt16)buttonID systemAction:(SDLSystemAction)systemAction handler:(SDLRPCNotificationHandler)handler {
    SDLSoftButton *button = [[SDLSoftButton alloc] initWithHandler:handler];
    button.type = type;
    button.text = text;
    button.image = image;
    button.isHighlighted = @(highlighted);
    button.softButtonID = @(buttonID);
    button.systemAction = systemAction;

    return button;
}


//***** Speak *****
+ (SDLSpeak *)buildSpeakWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSpeak *msg = [[SDLSpeak alloc] init];
    msg.correlationID = correlationID;
    msg.ttsChunks = [ttsChunks mutableCopy];

    return msg;
}

//***
+ (SDLSpeak *)buildSpeakWithTTS:(NSString *)ttsText correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLTTSChunk *simpleChunk = [[SDLTTSChunk alloc] init];
    simpleChunk.text = ttsText;
    simpleChunk.type = SDLSpeechCapabilitiesText;
    NSArray<SDLTTSChunk *> *ttsChunks = [NSMutableArray arrayWithObject:simpleChunk];

    return [SDLRPCRequestFactory buildSpeakWithTTSChunks:ttsChunks correlationID:correlationID];
}
//*****

+ (SDLSubscribeButton *)buildSubscribeButtonWithName:(SDLButtonName)buttonName correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSubscribeButton *msg = [[SDLSubscribeButton alloc] init];
    msg.buttonName = buttonName;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLSubscribeButton *)buildSubscribeButtonWithName:(SDLButtonName)buttonName handler:(SDLRPCNotificationHandler)handler {
    SDLSubscribeButton *msg = [[SDLSubscribeButton alloc] initWithHandler:handler];
    msg.buttonName = buttonName;

    return msg;
}

+ (SDLSubscribeVehicleData *)buildSubscribeVehicleDataWithGPS:(NSNumber<SDLBool> *)gps speed:(NSNumber<SDLBool> *)speed rpm:(NSNumber<SDLBool> *)rpm fuelLevel:(NSNumber<SDLBool> *)fuelLevel fuelLevelState:(NSNumber<SDLBool> *)fuelLevelState instantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption externalTemperature:(NSNumber<SDLBool> *)externalTemperature prndl:(NSNumber<SDLBool> *)prndl tirePressure:(NSNumber<SDLBool> *)tirePressure odometer:(NSNumber<SDLBool> *)odometer beltStatus:(NSNumber<SDLBool> *)beltStatus bodyInformation:(NSNumber<SDLBool> *)bodyInformation deviceStatus:(NSNumber<SDLBool> *)deviceStatus driverBraking:(NSNumber<SDLBool> *)driverBraking wiperStatus:(NSNumber<SDLBool> *)wiperStatus headLampStatus:(NSNumber<SDLBool> *)headLampStatus engineTorque:(NSNumber<SDLBool> *)engineTorque accPedalPosition:(NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLSubscribeVehicleData *msg = [[SDLSubscribeVehicleData alloc] init];
    msg.gps = gps;
    msg.speed = speed;
    msg.rpm = rpm;
    msg.fuelLevel = fuelLevel;
    msg.fuelLevel_State = fuelLevelState;
    msg.instantFuelConsumption = instantFuelConsumption;
    msg.externalTemperature = externalTemperature;
    msg.prndl = prndl;
    msg.tirePressure = tirePressure;
    msg.odometer = odometer;
    msg.beltStatus = beltStatus;
    msg.bodyInformation = bodyInformation;
    msg.deviceStatus = deviceStatus;
    msg.driverBraking = driverBraking;
    msg.wiperStatus = wiperStatus;
    msg.headLampStatus = headLampStatus;
    msg.engineTorque = engineTorque;
    msg.accPedalPosition = accPedalPosition;
    msg.steeringWheelAngle = steeringWheelAngle;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLUnregisterAppInterface *)buildUnregisterAppInterfaceWithCorrelationID:(NSNumber<SDLInt> *)correlationID {
    SDLUnregisterAppInterface *msg = [[SDLUnregisterAppInterface alloc] init];
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLUnsubscribeButton *)buildUnsubscribeButtonWithName:(SDLButtonName)buttonName correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLUnsubscribeButton *msg = [[SDLUnsubscribeButton alloc] init];
    msg.buttonName = buttonName;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLUnsubscribeVehicleData *)buildUnsubscribeVehicleDataWithGPS:(NSNumber<SDLBool> *)gps speed:(NSNumber<SDLBool> *)speed rpm:(NSNumber<SDLBool> *)rpm fuelLevel:(NSNumber<SDLBool> *)fuelLevel fuelLevelState:(NSNumber<SDLBool> *)fuelLevelState instantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption externalTemperature:(NSNumber<SDLBool> *)externalTemperature prndl:(NSNumber<SDLBool> *)prndl tirePressure:(NSNumber<SDLBool> *)tirePressure odometer:(NSNumber<SDLBool> *)odometer beltStatus:(NSNumber<SDLBool> *)beltStatus bodyInformation:(NSNumber<SDLBool> *)bodyInformation deviceStatus:(NSNumber<SDLBool> *)deviceStatus driverBraking:(NSNumber<SDLBool> *)driverBraking wiperStatus:(NSNumber<SDLBool> *)wiperStatus headLampStatus:(NSNumber<SDLBool> *)headLampStatus engineTorque:(NSNumber<SDLBool> *)engineTorque accPedalPosition:(NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLUnsubscribeVehicleData *msg = [[SDLUnsubscribeVehicleData alloc] init];
    msg.gps = gps;
    msg.speed = speed;
    msg.rpm = rpm;
    msg.fuelLevel = fuelLevel;
    msg.fuelLevel_State = fuelLevelState;
    msg.instantFuelConsumption = instantFuelConsumption;
    msg.externalTemperature = externalTemperature;
    msg.prndl = prndl;
    msg.tirePressure = tirePressure;
    msg.odometer = odometer;
    msg.beltStatus = beltStatus;
    msg.bodyInformation = bodyInformation;
    msg.deviceStatus = deviceStatus;
    msg.driverBraking = driverBraking;
    msg.wiperStatus = wiperStatus;
    msg.headLampStatus = headLampStatus;
    msg.engineTorque = engineTorque;
    msg.accPedalPosition = accPedalPosition;
    msg.steeringWheelAngle = steeringWheelAngle;
    msg.correlationID = correlationID;

    return msg;
}

+ (SDLUpdateTurnList *)buildUpdateTurnListWithTurnList:(NSMutableArray<SDLTurn *> *)turnList softButtons:(NSMutableArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID {
    SDLUpdateTurnList *msg = [[SDLUpdateTurnList alloc] init];
    msg.turnList = [turnList mutableCopy];
    msg.softButtons = [softButtons mutableCopy];
    msg.correlationID = correlationID;

    return msg;
}

@end
