//  SDLRPCRequestFactory.h
//

#import <Foundation/Foundation.h>

#import "SDLAppHMIType.h"
#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLButtonName.h"
#import "SDLFileType.h"
#import "SDLGlobalProperty.h"
#import "SDLImageType.h"
#import "SDLInteractionMode.h"
#import "SDLLanguage.h"
#import "SDLNotificationConstants.h"
#import "SDLSamplingRate.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"
#import "SDLTextAlignment.h"
#import "SDLUpdateMode.h"
#import "SDLVRHelpItem.h"

@class SDLAddCommand;
@class SDLAddSubMenu;
@class SDLAlert;
@class SDLAlertManeuver;
@class SDLChangeRegistration;
@class SDLChoice;
@class SDLCreateInteractionChoiceSet;
@class SDLDeleteCommand;
@class SDLDeleteFile;
@class SDLDeleteInteractionChoiceSet;
@class SDLDeleteSubMenu;
@class SDLDialNumber;
@class SDLEndAudioPassThru;
@class SDLGetDTCs;
@class SDLGetVehicleData;
@class SDLImage;
@class SDLListFiles;
@class SDLPerformAudioPassThru;
@class SDLPerformInteraction;
@class SDLPutFile;
@class SDLReadDID;
@class SDLRegisterAppInterface;
@class SDLResetGlobalProperties;
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
@class SDLSpeak;
@class SDLSubscribeButton;
@class SDLSubscribeVehicleData;
@class SDLTTSChunk;
@class SDLTurn;
@class SDLUnregisterAppInterface;
@class SDLUnsubscribeButton;
@class SDLUnsubscribeVehicleData;
@class SDLUpdateTurnList;

@interface SDLRPCRequestFactory : NSObject {
}

//***** AddCommand *****
+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName parentID:(NSNumber<SDLInt> *)parentID position:(NSNumber<SDLInt> *)position vrCommands:(NSArray<NSString *> *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType)iconType correlationID:(NSNumber<SDLInt> *)correlationID __deprecated_msg("use buildAddCommandWithID:menuName:parentID:position:vrCommands:iconValue:iconType:handler: with SDLManager instead");
;

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands correlationID:(NSNumber<SDLInt> *)correlationID __deprecated_msg("use buildAddCommandWithID:menuName:vrCommands:handler: with SDLManager instead");

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID vrCommands:(NSArray<NSString *> *)vrCommands correlationID:(NSNumber<SDLInt> *)correlationID __deprecated_msg("use buildAddCommandWithID:vrCommands:handler: with SDLManager instead");

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName parentID:(NSNumber<SDLInt> *)parentID position:(NSNumber<SDLInt> *)position vrCommands:(NSArray<NSString *> *)vrCommands iconValue:(NSString *)iconValue iconType:(SDLImageType)iconType handler:(SDLRPCNotificationHandler)handler;

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands handler:(SDLRPCNotificationHandler)handler;

+ (SDLAddCommand *)buildAddCommandWithID:(NSNumber<SDLInt> *)cmdID vrCommands:(NSArray<NSString *> *)vrCommands handler:(SDLRPCNotificationHandler)handler;
//*****


//***** AddSubMenu *****
+ (SDLAddSubMenu *)buildAddSubMenuWithID:(NSNumber<SDLInt> *)menuID menuName:(NSString *)menuName position:(NSNumber<SDLInt> *)position correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLAddSubMenu *)buildAddSubMenuWithID:(NSNumber<SDLInt> *)menuID menuName:(NSString *)menuName correlationID:(NSNumber<SDLInt> *)correlationID;
//*****


//***** Alert *****
+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(NSNumber<SDLBool> *)playTone duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 playTone:(NSNumber<SDLBool> *)playTone duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLAlert *)buildAlertWithTTS:(NSString *)ttsText playTone:(NSNumber<SDLBool> *)playTone correlationID:(NSNumber<SDLInt> *)
                                                                                                    correlationID;

//***
+ (SDLAlert *)buildAlertWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 playTone:(NSNumber<SDLBool> *)playTone duration:(NSNumber<SDLInt> *)duration softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLAlert *)buildAlertWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks playTone:(NSNumber<SDLBool> *)playTone correlationID:(NSNumber<SDLInt> *)correlationID;

//***
+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(NSNumber<SDLInt> *)duration softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 alertText3:(NSString *)alertText3 duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLAlert *)buildAlertWithAlertText1:(NSString *)alertText1 alertText2:(NSString *)alertText2 duration:(NSNumber<SDLInt> *)duration correlationID:(NSNumber<SDLInt> *)correlationID;
//*****

+ (SDLAlertManeuver *)buildAlertManeuverwithTTSchunks:(NSMutableArray<SDLTTSChunk *> *)ttsChunks softButtons:(NSMutableArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLChangeRegistration *)buildChangeRegistrationWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLCreateInteractionChoiceSet *)buildCreateInteractionChoiceSetWithID:(NSNumber<SDLInt> *)interactionChoiceSetID choiceSet:(NSArray<SDLChoice *> *)choices correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLDeleteCommand *)buildDeleteCommandWithID:(NSNumber<SDLInt> *)cmdID correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLDeleteFile *)buildDeleteFileWithName:(NSString *)syncFileName correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLDialNumber *)buildDialNumberWithNumber:(NSString *)phoneNumber;

+ (SDLListFiles *)buildListFilesWithCorrelationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLDeleteInteractionChoiceSet *)buildDeleteInteractionChoiceSetWithID:(NSNumber<SDLInt> *)interactionChoiceSetID correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLDeleteSubMenu *)buildDeleteSubMenuWithID:(NSNumber<SDLInt> *)menuID correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLEndAudioPassThru *)buildEndAudioPassThruWithCorrelationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLGetDTCs *)buildGetDTCsWithECUName:(NSNumber<SDLInt> *)ecuName correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLGetVehicleData *)buildGetVehicleDataWithGPS:(NSNumber<SDLBool> *)gps speed:(NSNumber<SDLBool> *)speed rpm:(NSNumber<SDLBool> *)rpm fuelLevel:(NSNumber<SDLBool> *)fuelLevel fuelLevelState:(NSNumber<SDLBool> *)fuelLevelState instantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption externalTemperature:(NSNumber<SDLBool> *)externalTemperature vin:(NSNumber<SDLBool> *)vin prndl:(NSNumber<SDLBool> *)prndl tirePressure:(NSNumber<SDLBool> *)tirePressure odometer:(NSNumber<SDLBool> *)odometer beltStatus:(NSNumber<SDLBool> *)beltStatus bodyInformation:(NSNumber<SDLBool> *)bodyInformation deviceStatus:(NSNumber<SDLBool> *)deviceStatus driverBraking:(NSNumber<SDLBool> *)driverBraking wiperStatus:(NSNumber<SDLBool> *)wiperStatus headLampStatus:(NSNumber<SDLBool> *)headLampStatus engineTorque:(NSNumber<SDLBool> *)engineTorque accPedalPosition:(NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLPerformAudioPassThru *)buildPerformAudioPassThruWithInitialPrompt:(NSString *)initialPrompt audioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate maxDuration:(NSNumber<SDLInt> *)maxDuration bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType muteAudio:(NSNumber<SDLBool> *)muteAudio correlationID:(NSNumber<SDLInt> *)correlationID;


//***** PerformInteraction *****
+ (SDLPerformInteraction *)buildPerformInteractionWithInitialChunks:(NSArray<SDLTTSChunk *> *)initialChunks initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber *> *)interactionChoiceSetIDList helpChunks:(NSArray<SDLTTSChunk *> *)helpChunks timeoutChunks:(NSArray<SDLTTSChunk *> *)timeoutChunks interactionMode:(SDLInteractionMode)interactionMode timeout:(NSNumber<SDLInt> *)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID;

//***
+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(NSNumber<SDLInt> *)timeout vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(NSNumber<SDLInt> *)interactionChoiceSetID vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetIDList:(NSArray<NSNumber<SDLInt> *> *)interactionChoiceSetIDList helpPrompt:(NSString *)helpPrompt timeoutPrompt:(NSString *)timeoutPrompt interactionMode:(SDLInteractionMode)interactionMode timeout:(NSNumber<SDLInt> *)timeout correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLPerformInteraction *)buildPerformInteractionWithInitialPrompt:(NSString *)initialPrompt initialText:(NSString *)initialText interactionChoiceSetID:(NSNumber<SDLInt> *)interactionChoiceSetID correlationID:(NSNumber<SDLInt> *)correlationID;
//*****

+ (SDLPutFile *)buildPutFileWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(NSNumber<SDLBool> *)persistentFile correlationID:(NSNumber<SDLInt> *)correlationID;
+ (SDLPutFile *)buildPutFileWithFileName:(NSString *)syncFileName fileType:(SDLFileType)fileType persisistentFile:(NSNumber<SDLBool> *)persistentFile correlationID:(NSNumber<SDLInt> *)correlationID __deprecated_msg("use buildPutFileWithFileName:fileType:persistentFile:correlationID: instead");

+ (SDLReadDID *)buildReadDIDWithECUName:(NSNumber<SDLInt> *)ecuName didLocation:(NSArray<NSNumber<SDLInt> *> *)didLocation correlationID:(NSNumber<SDLInt> *)correlationID;

//***** RegisterAppInterface *****
+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName ttsName:(NSMutableArray<SDLTTSChunk *> *)ttsName vrSynonyms:(NSMutableArray<NSString *> *)vrSynonyms isMediaApp:(NSNumber<SDLBool> *)isMediaApp languageDesired:(SDLLanguage)languageDesired hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired appID:(NSString *)appID;

+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName isMediaApp:(NSNumber<SDLBool> *)isMediaApp languageDesired:(SDLLanguage)languageDesired appID:(NSString *)appID;

+ (SDLRegisterAppInterface *)buildRegisterAppInterfaceWithAppName:(NSString *)appName languageDesired:(SDLLanguage)languageDesired appID:(NSString *)appID;
//*****

+ (SDLResetGlobalProperties *)buildResetGlobalPropertiesWithProperties:(NSArray<SDLGlobalProperty> *)properties correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLSendLocation *)buildSendLocationWithLongitude:(NSNumber<SDLFloat> *)longitude latitude:(NSNumber<SDLFloat> *)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription address:(NSArray<NSString *> *)address phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image;

+ (SDLScrollableMessage *)buildScrollableMessage:(NSString *)scrollableMessageBody timeout:(NSNumber<SDLInt> *)timeout softButtons:(NSArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLSetAppIcon *)buildSetAppIconWithFileName:(NSString *)syncFileName correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLSetDisplayLayout *)buildSetDisplayLayout:(NSString *)displayLayout correlationID:(NSNumber<SDLInt> *)correlationID;


//***** SetGlobalProperties *****
+ (SDLSetGlobalProperties *)buildSetGlobalPropertiesWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLSetGlobalProperties *)buildSetGlobalPropertiesWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText correlationID:(NSNumber<SDLInt> *)correlationID;
//*****


//***** SetMediaClockTimer *****
+ (SDLSetMediaClockTimer *)buildSetMediaClockTimerWithHours:(NSNumber<SDLInt> *)hours minutes:(NSNumber<SDLInt> *)minutes seconds:(NSNumber<SDLInt> *)seconds updateMode:(SDLUpdateMode)updateMode correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLSetMediaClockTimer *)buildSetMediaClockTimerWithUpdateMode:(SDLUpdateMode)updateMode correlationID:(NSNumber<SDLInt> *)correlationID;
//*****


//***** Show *****
+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 mainField3:(NSString *)mainField3 mainField4:(NSString *)mainField4 statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack alignment:(SDLTextAlignment)textAlignment graphic:(SDLImage *)graphic softButtons:(NSArray<SDLSoftButton *> *)softButtons customPresets:(NSArray<NSString *> *)customPresets correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 statusBar:(NSString *)statusBar mediaClock:(NSString *)mediaClock mediaTrack:(NSString *)mediaTrack alignment:(SDLTextAlignment)textAlignment correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLShow *)buildShowWithMainField1:(NSString *)mainField1 mainField2:(NSString *)mainField2 alignment:(SDLTextAlignment)alignment correlationID:(NSNumber<SDLInt> *)correlationID;
//*****


//***** Slider *****
+ (SDLSlider *)buildSliderDynamicFooterWithNumTicks:(NSNumber<SDLInt> *)numTicks position:(NSNumber<SDLInt> *)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSArray<NSString *> *)sliderFooter timeout:(NSNumber<SDLInt> *)timeout correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLSlider *)buildSliderStaticFooterWithNumTicks:(NSNumber<SDLInt> *)numTicks position:(NSNumber<SDLInt> *)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSString *)sliderFooter timeout:(NSNumber<SDLInt> *)timeout correlationID:(NSNumber<SDLInt> *)correlationID;
//*****

+ (SDLSoftButton *)buildSoftButtonWithType:(SDLSoftButtonType)type text:(NSString *)text image:(SDLImage *)image highlighted:(BOOL)highlighted buttonID:(UInt16)buttonID systemAction:(SDLSystemAction)systemAction handler:(SDLRPCNotificationHandler)handler;

//***** Speak *****
+ (SDLSpeak *)buildSpeakWithTTSChunks:(NSArray<SDLTTSChunk *> *)ttsChunks correlationID:(NSNumber<SDLInt> *)correlationID;

//***
+ (SDLSpeak *)buildSpeakWithTTS:(NSString *)ttsText correlationID:(NSNumber<SDLInt> *)correlationID;
//*****

+ (SDLSubscribeButton *)buildSubscribeButtonWithName:(SDLButtonName)buttonName correlationID:(NSNumber<SDLInt> *)correlationID __deprecated_msg("use buildSubscribeButtonWithName:handler: with SDLManager instead");

+ (SDLSubscribeButton *)buildSubscribeButtonWithName:(SDLButtonName)buttonName handler:(SDLRPCNotificationHandler)handler;

+ (SDLSubscribeVehicleData *)buildSubscribeVehicleDataWithGPS:(NSNumber<SDLBool> *)gps speed:(NSNumber<SDLBool> *)speed rpm:(NSNumber<SDLBool> *)rpm fuelLevel:(NSNumber<SDLBool> *)fuelLevel fuelLevelState:(NSNumber<SDLBool> *)fuelLevelState instantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption externalTemperature:(NSNumber<SDLBool> *)externalTemperature prndl:(NSNumber<SDLBool> *)prndl tirePressure:(NSNumber<SDLBool> *)tirePressure odometer:(NSNumber<SDLBool> *)odometer beltStatus:(NSNumber<SDLBool> *)beltStatus bodyInformation:(NSNumber<SDLBool> *)bodyInformation deviceStatus:(NSNumber<SDLBool> *)deviceStatus driverBraking:(NSNumber<SDLBool> *)driverBraking wiperStatus:(NSNumber<SDLBool> *)wiperStatus headLampStatus:(NSNumber<SDLBool> *)headLampStatus engineTorque:(NSNumber<SDLBool> *)engineTorque accPedalPosition:(NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLShowConstantTBT *)buildShowConstantTBTWithString:(NSString *)navigationText1 navigationText2:(NSString *)navigationText2 eta:(NSString *)eta timeToDestination:(NSString *)timeToDestination totalDistance:(NSString *)totalDistance turnIcon:(SDLImage *)turnIcon nextTurnIcon:(SDLImage *)nextTurnIcon distanceToManeuver:(NSNumber<SDLFloat> *)distanceToManeuver distanceToManeuverScale:(NSNumber<SDLFloat> *)distanceToManeuverScale maneuverComplete:(NSNumber<SDLBool> *)maneuverComplete softButtons:(NSMutableArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLUnregisterAppInterface *)buildUnregisterAppInterfaceWithCorrelationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLUnsubscribeButton *)buildUnsubscribeButtonWithName:(SDLButtonName)buttonName correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLUnsubscribeVehicleData *)buildUnsubscribeVehicleDataWithGPS:(NSNumber<SDLBool> *)gps speed:(NSNumber<SDLBool> *)speed rpm:(NSNumber<SDLBool> *)rpm fuelLevel:(NSNumber<SDLBool> *)fuelLevel fuelLevelState:(NSNumber<SDLBool> *)fuelLevelState instantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption externalTemperature:(NSNumber<SDLBool> *)externalTemperature prndl:(NSNumber<SDLBool> *)prndl tirePressure:(NSNumber<SDLBool> *)tirePressure odometer:(NSNumber<SDLBool> *)odometer beltStatus:(NSNumber<SDLBool> *)beltStatus bodyInformation:(NSNumber<SDLBool> *)bodyInformation deviceStatus:(NSNumber<SDLBool> *)deviceStatus driverBraking:(NSNumber<SDLBool> *)driverBraking wiperStatus:(NSNumber<SDLBool> *)wiperStatus headLampStatus:(NSNumber<SDLBool> *)headLampStatus engineTorque:(NSNumber<SDLBool> *)engineTorque accPedalPosition:(NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle correlationID:(NSNumber<SDLInt> *)correlationID;

+ (SDLUpdateTurnList *)buildUpdateTurnListWithTurnList:(NSMutableArray<SDLTurn *> *)turnList softButtons:(NSMutableArray<SDLSoftButton *> *)softButtons correlationID:(NSNumber<SDLInt> *)correlationID;
@end
