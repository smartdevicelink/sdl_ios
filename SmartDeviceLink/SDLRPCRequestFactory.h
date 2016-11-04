//  SDLRPCRequestFactory.h
//

#import <Foundation/Foundation.h>

#import "SDLNotificationConstants.h"

@class SDLAddCommand;
@class SDLAddSubMenu;
@class SDLAlert;
@class SDLAlertManeuver;
@class SDLAppHMIType;
@class SDLAudioType;
@class SDLBitsPerSample;
@class SDLButtonName;
@class SDLChangeRegistration;
@class SDLCreateInteractionChoiceSet;
@class SDLDeleteCommand;
@class SDLDeleteFile;
@class SDLDeleteInteractionChoiceSet;
@class SDLDeleteSubMenu;
@class SDLDialNumber;
@class SDLEndAudioPassThru;
@class SDLFileType;
@class SDLGetDTCs;
@class SDLGetVehicleData;
@class SDLImage;
@class SDLImageType;
@class SDLInteractionMode;
@class SDLLanguage;
@class SDLListFiles;
@class SDLPerformAudioPassThru;
@class SDLPerformInteraction;
@class SDLPutFile;
@class SDLReadDID;
@class SDLRegisterAppInterface;
@class SDLResetGlobalProperties;
@class SDLSamplingRate;
@class SDLScrollableMessage;
@class SDLSendLocation;
@class SDLSetAppIcon;
@class SDLSetDisplayLayout;
@class SDLSetGlobalProperties;
@class SDLSetMediaClockTimer;
@class SDLShow;
@class SDLShowConstantTBT;
@class SDLSlider;
@class SDLSoftButton;
@class SDLSoftButtonType;
@class SDLSpeak;
@class SDLSubscribeButton;
@class SDLSubscribeVehicleData;
@class SDLSystemAction;
@class SDLTextAlignment;
@class SDLTTSChunk;
@class SDLUnregisterAppInterface;
@class SDLUnsubscribeButton;
@class SDLUnsubscribeVehicleData;
@class SDLUpdateMode;
@class SDLUpdateTurnList;


__deprecated_msg("use class's initializers instead") @interface SDLRPCRequestFactory : NSObject {
}

//***** AddCommand *****
+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber *)cmdID menuName:(NSString *)menuName parentID:(NSNumber *)parentID position:(NSNumber *)position vrCommands:(NSArray *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType *)iconType correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAddCommand's buildAddCommandWithID:vrCommands:menuName:parentID:position:iconValue:iconType:handler: instead");
;

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber *)cmdID menuName:(NSString *)menuName vrCommands:(NSArray *)vrCommands correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAddCommands's initWithId:vrCommands:menuName:handler: instead");

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber *)cmdID vrCommands:(NSArray *)vrCommands correlationID:(NSNumber *)correlationID __deprecated_msg("use buildAddCommandWithID:vrCommands:handler: with SDLManager instead");

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber *)cmdID menuName:(NSString *)menuName parentID:(NSNumber *)parentID position:(NSNumber *)position vrCommands:(NSArray *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType *)iconType handler:(SDLRPCNotificationHandler)handler __deprecated_msg("use SDLAddCommand's initWithId:vrCommands:menuName:parentId:position:iconValue:iconType:handler: instead");

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber *)cmdID menuName:(NSString *)menuName vrCommands:(NSArray *)vrCommands handler:(SDLRPCNotificationHandler)handler __deprecated_msg("use SDLAddCommand's initWithId:vrCommands:menuName:handler: instead");

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber *)cmdID vrCommands:(NSArray *)vrCommands handler:(SDLRPCNotificationHandler)handler __deprecated_msg("use SDLAddCommand's initWithId:vrCommands:handler: instead");
//*****


//***** AddSubMenu *****
+ (SDLAddSubMenu *)buildAddSubMenuWithID:(NSNumber *)menuID menuName:(NSString *)menuName position:(NSNumber *)position correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAddSubMenu's initWithId:menuName:position: instead");

+ (SDLAddSubMenu *)buildAddSubMenuWithID:(NSNumber *)menuID menuName:(NSString *)menuName correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAddSubMenu's initWithId:menuName: instead");
//*****


//***** Alert *****
+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(NSNumber *)playTone duration:(NSNumber *)duration correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithTTS:alertText1:alertText2:alertText3:playTone:duration: instead");

+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 playTone:(NSNumber *)playTone duration:(NSNumber *)duration correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithTTS:alertText1:alertText2:playTone:duration: instead");

+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText playTone:(NSNumber *)playTone correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithTTS:playTone:duration: instead");

//***
+ (SDLAlert *)buildAlertWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(NSNumber *)playTone duration:(NSNumber *)duration softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithTTSChunks:alertText1:alertText2:alertText3:playTone:duration:softButtons: instead");

+ (SDLAlert *)buildAlertWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks playTone:(NSNumber *)playTone correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithTTSChunks:playTone: instead");

//***
+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(NSNumber *)duration softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithAlertText1:alertText2:alertText3:duration:softButtons: instead");

+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(NSNumber *)duration correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithAlertText1:alertText2:alertText3:duration: instead");

+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 duration:(NSNumber *)duration correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlert's initWithAlertText1:alertText2:duration: instead");
//*****

+ (SDLAlertManeuver *)buildAlertManeuverwithTTSchunks:(NSMutableArray *)ttsChunks softButtons:(NSMutableArray *)softButtons correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLAlertManeuver's initWithTTSChunks:softButtons: instead");

+ (SDLChangeRegistration *)buildChangeRegistrationWithLanguage:(SDLLanguage *)language hmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLChangeRegistration's initWithLanguage:hmiDisplayLanguage: instead");

+ (SDLCreateInteractionChoiceSet *)buildCreateInteractionChoiceSetWithID:(NSNumber *)interactionChoiceSetID choiceSet:(NSArray *)choices correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLCreateInteractionChoiceSet's initWithId:choiceSet: instead");

+ (SDLDeleteCommand *)buildDeleteCommandWithID:(NSNumber *)cmdID correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLDeleteCommand's initWithId: instead");

+ (SDLDeleteFile *)buildDeleteFileWithName:(NSString *)syncFileName correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLDeleteFile's initWithFileName: instead");

+ (SDLDialNumber *)buildDialNumberWithNumber:(NSString *)phoneNumber __deprecated_msg("use SDLDialNumber's initWithNumber: instead");

+ (SDLListFiles *)buildListFilesWithCorrelationID:(NSNumber *)correlationID __deprecated_msg("use SDLListFiles's default initializer instead");

+ (SDLDeleteInteractionChoiceSet *)buildDeleteInteractionChoiceSetWithID:(NSNumber *)interactionChoiceSetID correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLDeleteInteractionChoiceSet's initWithId: instead");

+ (SDLDeleteSubMenu *)buildDeleteSubMenuWithID:(NSNumber *)menuID correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLDeleteSubMenu's initWithId: instead");

+ (SDLEndAudioPassThru *)buildEndAudioPassThruWithCorrelationID:(NSNumber *)correlationID __deprecated_msg("use SDLEndAudioPassThru's default initializer instead");

+ (SDLGetDTCs *)buildGetDTCsWithECUName:(NSNumber *)ecuName correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLGetDTCs's initWithECUName: instead");

+ (SDLGetVehicleData *)buildGetVehicleDataWithGPS:(NSNumber *)gps speed:(NSNumber *)speed rpm:(NSNumber *)rpm fuelLevel:(NSNumber *)fuelLevel fuelLevelState:(NSNumber *)fuelLevelState instantFuelConsumption:(NSNumber *)instantFuelConsumption externalTemperature:(NSNumber *)externalTemperature vin:(NSNumber *)vin prndl:(NSNumber *)prndl tirePressure:(NSNumber *)tirePressure odometer:(NSNumber *)odometer beltStatus:(NSNumber *)beltStatus bodyInformation:(NSNumber *)bodyInformation deviceStatus:(NSNumber *)deviceStatus driverBraking:(NSNumber *)driverBraking wiperStatus:(NSNumber *)wiperStatus headLampStatus:(NSNumber *)headLampStatus engineTorque:(NSNumber *)engineTorque accPedalPosition:(NSNumber *)accPedalPosition steeringWheelAngle:(NSNumber *)steeringWheelAngle correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLGetVehicleData's initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:vin:wiperStatus: instead");

+ (SDLPerformAudioPassThru *)buildPerformAudioPassThruWithInitialPrompt:(NSString *)initialPrompt audioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate *)samplingRate maxDuration:(NSNumber *)maxDuration bitsPerSample:(SDLBitsPerSample *)bitsPerSample audioType:(SDLAudioType *)audioType muteAudio:(NSNumber *)muteAudio correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLPerformAudioPassThru's initWithInitialPrompt:audioPassThruDisplayText1:audioPassThruDisplayText2:samplingRate:bitsPerSample:audioType:maxDuration:muteAudio: instead");


//***** PerformInteraction *****
+ (SDLPerformInteraction *)buildPerformInteractionWithInitialChunks:(NSArray *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray *)interactionChoiceSetIDList helpChunks:(NSArray *)helpChunks timeoutChunks:(NSArray *)timeoutChunks interactionMode:(SDLInteractionMode *)interactionMode timeout:(NSNumber *)timeout vrHelp:(NSArray *)vrHelp correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLPerformInteraction's initWithInitialChunks:initialText:interactionChoiceSetIDList:helpChunks:timeoutChunks:interactionMode:timeout:vrHelp: instead");

//***
+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode *)interactionMode timeout:(NSNumber *)timeout vrHelp:(NSArray *)vrHelp correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLPerformInteraction's initWithInitialPrompt:initialText:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:interactionMode:timeout:vrHelp: instead");

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(NSNumber *)interactionChoiceSetID vrHelp:(NSArray *)vrHelp correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLPerformInteraction's initWithInitialPrompt:initialText:interactionChoiceSetID:vrHelp: instead");

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode *)interactionMode timeout:(NSNumber *)timeout correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLPerformInteraction's initWithInitialPrompt:initialText:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:interactionMode:timeout: instead");

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(NSNumber *)interactionChoiceSetID correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLPerformInteraction's  initWithInitialPrompt:initialText:interactionChoiceSetID: instead");
//*****

+ (SDLPutFile *)buildPutFileWithFileName:(NSString *)fileName fileType:(SDLFileType *)fileType persistentFile:(NSNumber *)persistentFile correlationId:(NSNumber *)correlationID __deprecated_msg("use SDLPutFile's initWithFileName:fileType: instead");
+ (SDLPutFile *)buildPutFileWithFileName:(NSString *)syncFileName fileType:(SDLFileType *)fileType persisistentFile:(NSNumber *)persistentFile correlationID:(NSNumber *)correlationID __deprecated_msg("use buildPutFileWithFileName:fileType:persistentFile:correlationID: instead");

+ (SDLReadDID *)buildReadDIDWithECUName:(NSNumber *)ecuName didLocation:(NSArray *)didLocation correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLReadDID's initWithECUName:didLocation: instead");

//***** RegisterAppInterface *****
+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName ttsName:(NSMutableArray *)ttsName vrSynonyms:(NSMutableArray *)vrSynonyms isMediaApp:(NSNumber *)isMediaApp languageDesired:(SDLLanguage *)languageDesired hmiDisplayLanguageDesired:(SDLLanguage *)hmiDisplayLanguageDesired appID:(NSString *)appID __deprecated_msg("use SDLRegisterAppInterface's initWithAppName:appId:languageDesired:isMediaApp:appType:shortAppName:ttsName:vrSynonyms:hmiDisplayLanguageDesired:resumeHash: instead");

+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName isMediaApp:(NSNumber *)isMediaApp languageDesired:(SDLLanguage *)languageDesired appID:(NSString *)appID __deprecated_msg("use SDLRegisterAppInterface's initWithAppName:appId:lanaugeDesired:isMediaApp:appType:shortAppName: instead");

+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName languageDesired:(SDLLanguage *)laguageDesired appID:(NSString *)appID __deprecated_msg("use SDLRegisterAppInterface's initWithAppName:appId:lanaugeDesired: instead");
//*****

+ (SDLResetGlobalProperties *)buildResetGlobalPropertiesWithProperties:(NSArray *)properties correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLResetGlobalProperties's initWithProperties: instead");

+ (SDLSendLocation *)buildSendLocationWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription address:(NSArray *)address phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image __deprecated_msg("use SDLSendLocation's initWithLongitude:latitude:locationName:locationDescription:address:phoneNumber:image: instead");

+ (SDLScrollableMessage *)buildScrollableMessage:(NSString *)scrollableMessageBody timeout:(NSNumber *)timeout softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLScrollableMessage's initWithMessage:timeout:softButtons: instead");

+ (SDLSetAppIcon *)buildSetAppIconWithFileName:(NSString *)syncFileName correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSetAppIcon's initWithFileName: instead");

+ (SDLSetDisplayLayout *)buildSetDisplayLayout:(NSString *)displayLayout correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSetAppIcon's initWithLayout: instead");


//***** SetGlobalProperties *****
+ (SDLSetGlobalProperties *)buildSetGlobalPropertiesWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray *)vrHelp correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSetGlobalProperties's initWithHelpText:timeoutText:vrHelpTitle:vrHelp: instead");

+ (SDLSetGlobalProperties *)buildSetGlobalPropertiesWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSetGlobalProperties's initWithHelpText:timeoutText: instead");
//*****


//***** SetMediaClockTimer *****
+ (SDLSetMediaClockTimer *)buildSetMediaClockTimerWithHours:(NSNumber *)hours minutes:(NSNumber *)minutes seconds:(NSNumber *)seconds updateMode:(SDLUpdateMode *)updateMode correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSetMediaClockTimer's initWithHours:minutes:seconds:updateMode: instead");

+ (SDLSetMediaClockTimer *)buildSetMediaClockTimerWithUpdateMode:(SDLUpdateMode *)updateMode correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSetMediaClockTimer's initWithUpdateMode: instead");
//*****


//***** Show *****
+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack alignment:(SDLTextAlignment *)textAlignment graphic:(SDLImage *)graphic softButtons:(NSArray<SDLSoftButton *> *)softButtons customPresets:(NSArray *)customPresets correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLShow's initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaClock:mediaTrack:graphic:softButtons:customPresets: instead");

+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack alignment:(SDLTextAlignment *)textAlignment correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLShow's initWithMainField1:mainField2:alignment:statusBar:mediaClock:mediaTrack: instead");

+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 alignment:(SDLTextAlignment *)alignment correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLShow's initWithMainField1:mainField2:alignment: instead");
//*****


//***** Slider *****
+ (SDLSlider *)buildSliderDynamicFooterWithNumTicks:(NSNumber *)numTicks position:(NSNumber *)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSArray *)sliderFooter timeout:(NSNumber *)timeout correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSlider's initWithNumTicks:position:sliderHeader:sliderFooter:timeout: instead");

+ (SDLSlider *)buildSliderStaticFooterWithNumTicks:(NSNumber *)numTicks position:(NSNumber *)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSString *)sliderFooter timeout:(NSNumber *)timeout correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSlider's initWithNumTicks:position:sliderHeader:sliderFooters:timeout: instead");
//*****

+ (SDLSoftButton *)buildSoftButtonWithType:(SDLSoftButtonType *)type text:(NSString *)text image:(SDLImage *)image highlighted:(BOOL)highlighted buttonID:(UInt16)buttonID systemAction:(SDLSystemAction *)systemAction handler:(SDLRPCNotificationHandler)handler __deprecated_msg("use SDLSoftButton's initWithType:text:image:highlighted:buttonId:systemAction:handler: instead");

//***** Speak *****
+ (SDLSpeak *)buildSpeakWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSpeak's initWithTTSChunks: instead");

//***
+ (SDLSpeak *)buildSpeakWithTTS:(NSString *)ttsText correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSpeak's initWithTTS: instead");
//*****

+ (SDLSubscribeButton *)buildSubscribeButtonWithName:(SDLButtonName *)buttonName correlationID:(NSNumber *)correlationID __deprecated_msg("use buildSubscribeButtonWithName:handler: with SDLManager instead");

+ (SDLSubscribeButton *)buildSubscribeButtonWithName:(SDLButtonName *)buttonName handler:(SDLRPCNotificationHandler)handler __deprecated_msg("use SDLSubscribeButton's initWithButtonName:handler: instead");

+ (SDLSubscribeVehicleData *)buildSubscribeVehicleDataWithGPS:(NSNumber *)gps speed:(NSNumber *)speed rpm:(NSNumber *)rpm fuelLevel:(NSNumber *)fuelLevel fuelLevelState:(NSNumber *)fuelLevelState instantFuelConsumption:(NSNumber *)instantFuelConsumption externalTemperature:(NSNumber *)externalTemperature prndl:(NSNumber *)prndl tirePressure:(NSNumber *)tirePressure odometer:(NSNumber *)odometer beltStatus:(NSNumber *)beltStatus bodyInformation:(NSNumber *)bodyInformation deviceStatus:(NSNumber *)deviceStatus driverBraking:(NSNumber *)driverBraking wiperStatus:(NSNumber *)wiperStatus headLampStatus:(NSNumber *)headLampStatus engineTorque:(NSNumber *)engineTorque accPedalPosition:(NSNumber *)accPedalPosition steeringWheelAngle:(NSNumber *)steeringWheelAngle correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSubscribeVehicleData's initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus: instead");

+ (SDLShowConstantTBT *)buildShowConstantTBTWithString:(NSString *)navigationText1 navigationText2:(NSString *)navigationText2 eta:(NSString *)eta timeToDestination:(NSString *)timeToDestination totalDistance:(NSString *)totalDistance turnIcon:(SDLImage *)turnIcon nextTurnIcon:(SDLImage *)nextTurnIcon distanceToManeuver:(NSNumber *)distanceToManeuver distanceToManeuverScale:(NSNumber *)distanceToManeuverScale maneuverComplete:(NSNumber *)maneuverComplete softButtons:(NSMutableArray *)softButtons correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLShowConstantTBT's initWithNavigationText1:navigationText2:eta:timeToDestination:totalDistance:turnIcon:nextTurnIcon:distanceToManeuver:distanceToManeuverScale:maneuverComplete:softButtons: instead");

+ (SDLUnregisterAppInterface *)buildUnregisterAppInterfaceWithCorrelationID:(NSNumber *)correlationID __deprecated_msg("use SDLUnregisterAppInterface's default initializer instead");

+ (SDLUnsubscribeButton *)buildUnsubscribeButtonWithName:(SDLButtonName *)buttonName correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLUnsubscribeButton's initWithButtonName: instead");

+ (SDLUnsubscribeVehicleData *)buildUnsubscribeVehicleDataWithGPS:(NSNumber *)gps speed:(NSNumber *)speed rpm:(NSNumber *)rpm fuelLevel:(NSNumber *)fuelLevel fuelLevelState:(NSNumber *)fuelLevelState instantFuelConsumption:(NSNumber *)instantFuelConsumption externalTemperature:(NSNumber *)externalTemperature prndl:(NSNumber *)prndl tirePressure:(NSNumber *)tirePressure odometer:(NSNumber *)odometer beltStatus:(NSNumber *)beltStatus bodyInformation:(NSNumber *)bodyInformation deviceStatus:(NSNumber *)deviceStatus driverBraking:(NSNumber *)driverBraking wiperStatus:(NSNumber *)wiperStatus headLampStatus:(NSNumber *)headLampStatus engineTorque:(NSNumber *)engineTorque accPedalPosition:(NSNumber *)accPedalPosition steeringWheelAngle:(NSNumber *)steeringWheelAngle correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLSubscribeVehicleData's initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus: instead");

+ (SDLUpdateTurnList *)buildUpdateTurnListWithTurnList:(NSMutableArray *)turnList softButtons:(NSMutableArray *)softButtons correlationID:(NSNumber *)correlationID __deprecated_msg("use SDLUpdateTurnList initWithTurnList:softButtons: instead");
@end
