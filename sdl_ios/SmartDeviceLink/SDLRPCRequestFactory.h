//  SDLRPCRequestFactory.h
//
//  

#import <Foundation/Foundation.h>

#import <SmartDeviceLink/SDLAddCommand.h>
#import <SmartDeviceLink/SDLAddSubMenu.h>
#import <SmartDeviceLink/SDLAlert.h>
#import <SmartDeviceLink/SDLAppHMIType.h>
#import <SmartDeviceLink/SDLChangeRegistration.h>
#import <SmartDeviceLink/SDLCreateInteractionChoiceSet.h>
#import <SmartDeviceLink/SDLDeleteCommand.h>
#import <SmartDeviceLink/SDLDeleteFile.h>
#import <SmartDeviceLink/SDLDeleteInteractionChoiceSet.h>
#import <SmartDeviceLink/SDLDeleteSubMenu.h>
#import <SmartDeviceLink/SDLEndAudioPassThru.h>
#import <SmartDeviceLink/SDLGetDTCs.h>
#import <SmartDeviceLink/SDLGetVehicleData.h>
#import <SmartDeviceLink/SDLListFiles.h>
#import <SmartDeviceLink/SDLPerformAudioPassThru.h>
#import <SmartDeviceLink/SDLPerformInteraction.h>
#import <SmartDeviceLink/SDLPutFile.h>
#import <SmartDeviceLink/SDLReadDID.h>
#import <SmartDeviceLink/SDLRegisterAppInterface.h>
#import <SmartDeviceLink/SDLResetGlobalProperties.h>
#import <SmartDeviceLink/SDLScrollableMessage.h>
#import <SmartDeviceLink/SDLSetAppIcon.h>
#import <SmartDeviceLink/SDLSetDisplayLayout.h>
#import <SmartDeviceLink/SDLSetGlobalProperties.h>
#import <SmartDeviceLink/SDLSetMediaClockTimer.h>
#import <SmartDeviceLink/SDLShow.h>
#import <SmartDeviceLink/SDLSlider.h>
#import <SmartDeviceLink/SDLSpeak.h>
#import <SmartDeviceLink/SDLSubscribeButton.h>
#import <SmartDeviceLink/SDLSubscribeVehicleData.h>
#import <SmartDeviceLink/SDLUnregisterAppInterface.h>
#import <SmartDeviceLink/SDLUnsubscribeButton.h>
#import <SmartDeviceLink/SDLUnsubscribeVehicleData.h>

@interface SDLRPCRequestFactory : NSObject {}

//***** AddCommand *****
+(SDLAddCommand*) buildAddCommandWithID:(NSNumber*) cmdID menuName:(NSString*) menuName parentID:(NSNumber*) parentID position:(NSNumber*) position vrCommands:(NSArray*) vrCommands iconValue:(NSString*) iconValue iconType:(SDLImageType*) iconType correlationID:(NSNumber*) correlationID;

+(SDLAddCommand*) buildAddCommandWithID:(NSNumber*) cmdID menuName:(NSString*) menuName vrCommands:(NSArray*) vrCommands correlationID:(NSNumber*) correlationID;

+(SDLAddCommand*) buildAddCommandWithID:(NSNumber*) cmdID vrCommands:(NSArray*) vrCommands correlationID:(NSNumber*) correlationID;
//*****


//***** AddSubMenu *****
+(SDLAddSubMenu*) buildAddSubMenuWithID:(NSNumber*) menuID menuName:(NSString*) menuName position:(NSNumber*) position correlationID:(NSNumber*) correlationID;

+(SDLAddSubMenu*) buildAddSubMenuWithID:(NSNumber*) menuID menuName:(NSString*) menuName correlationID:(NSNumber*) correlationID;
//*****


//***** Alert *****
+(SDLAlert*) buildAlertWithTTS:(NSString*) ttsText alertText1:(NSString*) alertText1 alertText2:(NSString*) alertText2 alertText3:(NSString*) alertText3 playTone:(NSNumber*) playTone duration:(NSNumber*) duration correlationID:(NSNumber*) correlationID;

+(SDLAlert*) buildAlertWithTTS:(NSString*) ttsText alertText1:(NSString*) alertText1 alertText2:(NSString*) alertText2 playTone:(NSNumber*) playTone duration:(NSNumber*) duration correlationID:(NSNumber*) correlationID;

+(SDLAlert*) buildAlertWithTTS:(NSString*) ttsText playTone:(NSNumber*) playTone correlationID:(NSNumber*)
correlationID;

//***
+(SDLAlert*) buildAlertWithTTSChunks:(NSArray*) ttsChunks alertText1:(NSString*) alertText1 alertText2:(NSString*) alertText2 alertText3:(NSString*) alertText3 playTone:(NSNumber*) playTone duration:(NSNumber*) duration softButtons:(NSArray*) softButtons correlationID:(NSNumber*) correlationID;

+(SDLAlert*) buildAlertWithTTSChunks:(NSArray*) ttsChunks playTone:(NSNumber*) playTone correlationID:(NSNumber*) correlationID;

//***
+(SDLAlert*) buildAlertWithAlertText1:(NSString*) alertText1 alertText2:(NSString*) alertText2 alertText3:(NSString*) alertText3 duration:(NSNumber*) duration softButtons:(NSArray*) softButtons correlationID:(NSNumber*) correlationID;

+(SDLAlert*) buildAlertWithAlertText1:(NSString*) alertText1 alertText2:(NSString*) alertText2 alertText3:(NSString*) alertText3 duration:(NSNumber*) duration correlationID:(NSNumber*) correlationID;

+(SDLAlert*) buildAlertWithAlertText1:(NSString*) alertText1 alertText2:(NSString*) alertText2 duration:(NSNumber*) duration correlationID:(NSNumber*) correlationID;
//*****


+(SDLChangeRegistration*) buildChangeRegistrationWithLanguage:(SDLLanguage*) language hmiDisplayLanguage:(SDLLanguage*) hmiDisplayLanguage correlationID:(NSNumber*) correlationID;

+(SDLCreateInteractionChoiceSet*) buildCreateInteractionChoiceSetWithID:(NSNumber*)interactionChoiceSetID choiceSet:(NSArray*) choices correlationID:(NSNumber*) correlationID;

+(SDLDeleteCommand*) buildDeleteCommandWithID:(NSNumber*) cmdID correlationID:(NSNumber*) correlationID;

+(SDLDeleteFile*) buildDeleteFileWithName:(NSString*) syncFileName correlationID:(NSNumber*) correlationID;

+(SDLListFiles*) buildListFilesWithCorrelationID:(NSNumber*) correlationID;

+(SDLDeleteInteractionChoiceSet*) buildDeleteInteractionChoiceSetWithID:(NSNumber*)interactionChoiceSetID correlationID:(NSNumber*) correlationID;

+(SDLDeleteSubMenu*) buildDeleteSubMenuWithID:(NSNumber*) menuID correlationID:(NSNumber*) correlationID;

+(SDLEndAudioPassThru*) buildEndAudioPassThruWithCorrelationID:(NSNumber*) correlationID;

+(SDLGetDTCs*) buildGetDTCsWithECUName:(NSNumber*) ecuName correlationID:(NSNumber*) correlationID;

+(SDLGetVehicleData*) buildGetVehicleDataWithGPS:(NSNumber*) gps speed:(NSNumber*) speed rpm:(NSNumber*) rpm fuelLevel:(NSNumber*) fuelLevel fuelLevelState:(NSNumber*) fuelLevelState instantFuelConsumption:(NSNumber*) instantFuelConsumption externalTemperature:(NSNumber*) externalTemperature vin:(NSNumber*) vin prndl:(NSNumber*) prndl tirePressure:(NSNumber*) tirePressure odometer:(NSNumber*) odometer beltStatus:(NSNumber*) beltStatus bodyInformation:(NSNumber*) bodyInformation deviceStatus:(NSNumber*) deviceStatus driverBraking:(NSNumber*) driverBraking wiperStatus:(NSNumber*) wiperStatus headLampStatus:(NSNumber*) headLampStatus engineTorque:(NSNumber*) engineTorque accPedalPosition:(NSNumber*) accPedalPosition steeringWheelAngle:(NSNumber*) steeringWheelAngle correlationID:(NSNumber*) correlationID;

+(SDLPerformAudioPassThru*) buildPerformAudioPassThruWithInitialPrompt:(NSString*) initialPrompt audioPassThruDisplayText1:(NSString*) audioPassThruDisplayText1 audioPassThruDisplayText2:(NSString*) audioPassThruDisplayText2 samplingRate:(SDLSamplingRate*)  samplingRate maxDuration:(NSNumber*) maxDuration bitsPerSample:(SDLBitsPerSample*) bitsPerSample audioType:(SDLAudioType*) audioType muteAudio:(NSNumber*) muteAudio correlationID:(NSNumber*) correlationID;


//***** PerformInteraction *****
+(SDLPerformInteraction*) buildPerformInteractionWithInitialChunks:(NSArray*)initialChunks initialText:(NSString*)initialText interactionChoiceSetIDList:(NSArray*) interactionChoiceSetIDList helpChunks:(NSArray*)helpChunks timeoutChunks:(NSArray*)timeoutChunks interactionMode:(SDLInteractionMode*) interactionMode timeout:(NSNumber*)timeout vrHelp:(NSArray*) vrHelp correlationID:(NSNumber*) correlationID;

//***
+(SDLPerformInteraction*) buildPerformInteractionWithInitialPrompt:(NSString*)initialPrompt initialText:(NSString*)initialText interactionChoiceSetIDList:(NSArray*) interactionChoiceSetIDList helpPrompt:(NSString*)helpPrompt timeoutPrompt:(NSString*)timeoutPrompt interactionMode:(SDLInteractionMode*) interactionMode timeout:(NSNumber*)timeout vrHelp:(NSArray*) vrHelp correlationID:(NSNumber*) correlationID;

+(SDLPerformInteraction*) buildPerformInteractionWithInitialPrompt:(NSString*)initialPrompt initialText:(NSString*)initialText interactionChoiceSetID:(NSNumber*) interactionChoiceSetID vrHelp:(NSArray*) vrHelp correlationID:(NSNumber*) correlationID;

+(SDLPerformInteraction*) buildPerformInteractionWithInitialPrompt:(NSString*)initialPrompt initialText:(NSString*)initialText interactionChoiceSetIDList:(NSArray*) interactionChoiceSetIDList helpPrompt:(NSString*)helpPrompt timeoutPrompt:(NSString*)timeoutPrompt interactionMode:(SDLInteractionMode*) interactionMode timeout:(NSNumber*)timeout correlationID:(NSNumber*) correlationID;

+(SDLPerformInteraction*) buildPerformInteractionWithInitialPrompt:(NSString*)initialPrompt initialText:(NSString*)initialText interactionChoiceSetID:(NSNumber*) interactionChoiceSetID correlationID:(NSNumber*) correlationID;
//*****


+(SDLPutFile*) buildPutFileWithFileName:(NSString*) syncFileName fileType:(SDLFileType*) fileType persisistentFile:(NSNumber*) persistentFile correlationID:(NSNumber*) correlationID;

+(SDLReadDID*) buildReadDIDWithECUName:(NSNumber*) ecuName didLocation:(NSArray*) didLocation correlationID:(NSNumber*) correlationID;

//***** RegisterAppInterface *****
+(SDLRegisterAppInterface*) buildRegisterAppInterfaceWithAppName:(NSString*) appName ttsName:(NSMutableArray*) ttsName vrSynonyms:(NSMutableArray*) vrSynonyms isMediaApp:(NSNumber*) isMediaApp languageDesired:(SDLLanguage*) languageDesired hmiDisplayLanguageDesired:(SDLLanguage*) hmiDisplayLanguageDesired appID:(NSString*) appID;

+(SDLRegisterAppInterface*) buildRegisterAppInterfaceWithAppName:(NSString*) appName isMediaApp:(NSNumber*) isMediaApp languageDesired:(SDLLanguage*) languageDesired appID:(NSString*) appID;

+(SDLRegisterAppInterface*) buildRegisterAppInterfaceWithAppName:(NSString*) appName languageDesired:(SDLLanguage*) laguageDesired appID:(NSString*) appID;
//*****


+(SDLResetGlobalProperties*) buildResetGlobalPropertiesWithProperties:(NSArray*) properties correlationID:(NSNumber*) correlationID;

+(SDLScrollableMessage*) buildScrollableMessage:(NSString*) scrollableMessageBody timeout:(NSNumber*) timeout softButtons:(NSArray*) softButtons correlationID:(NSNumber*) correlationID;

+(SDLSetAppIcon*) buildSetAppIconWithFileName:(NSString*) syncFileName correlationID:(NSNumber*) correlationID;

+(SDLSetDisplayLayout*) buildSetDisplayLayout:(NSString*) displayLayout correlationID:(NSNumber*) correlationID;


//***** SetGlobalProperties *****
+(SDLSetGlobalProperties*) buildSetGlobalPropertiesWithHelpText:(NSString*) helpText timeoutText:(NSString*) timeoutText vrHelpTitle:(NSString*) vrHelpTitle vrHelp:(NSArray*) vrHelp correlationID:(NSNumber*) correlationID;

+(SDLSetGlobalProperties*) buildSetGlobalPropertiesWithHelpText:(NSString*) helpText timeoutText:(NSString*) timeoutText correlationID:(NSNumber*) correlationID;
//*****


//***** SetMediaClockTimer *****
+(SDLSetMediaClockTimer*) buildSetMediaClockTimerWithHours:(NSNumber*) hours minutes:(NSNumber*) minutes seconds:(NSNumber*) seconds updateMode:(SDLUpdateMode*) updateMode correlationID:(NSNumber*) correlationID;

+(SDLSetMediaClockTimer*) buildSetMediaClockTimerWithUpdateMode:(SDLUpdateMode*) updateMode correlationID:(NSNumber*) correlationID;
//*****


//***** Show *****
+(SDLShow*) buildShowWithMainField1:(NSString*) mainField1 mainField2: (NSString*) mainField2 mainField3: (NSString*) mainField3 mainField4: (NSString*) mainField4 statusBar:(NSString*) statusBar mediaClock:(NSString*) mediaClock mediaTrack:(NSString*) mediaTrack alignment:(SDLTextAlignment*) textAlignment graphic:(SDLImage*) graphic softButtons:(NSArray*) softButtons customPresets:(NSArray*) customPresets correlationID:(NSNumber*) correlationID;

+(SDLShow*) buildShowWithMainField1:(NSString*) mainField1 mainField2: (NSString*) mainField2 statusBar:(NSString*) statusBar mediaClock:(NSString*) mediaClock mediaTrack:(NSString*) mediaTrack alignment:(SDLTextAlignment*) textAlignment correlationID:(NSNumber*) correlationID;

+(SDLShow*) buildShowWithMainField1:(NSString*) mainField1 mainField2: (NSString*) mainField2 alignment:(SDLTextAlignment*) alignment correlationID:(NSNumber*) correlationID;
//*****


//***** Slider *****
+(SDLSlider*) buildSliderDynamicFooterWithNumTicks:(NSNumber*) numTicks position:(NSNumber*) position sliderHeader:(NSString*) sliderHeader sliderFooter:(NSArray*) sliderFooter timeout:(NSNumber*) timeout correlationID:(NSNumber*) correlationID;

+(SDLSlider*) buildSliderStaticFooterWithNumTicks:(NSNumber*) numTicks position:(NSNumber*) position sliderHeader:(NSString*) sliderHeader sliderFooter:(NSString*) sliderFooter timeout:(NSNumber*) timeout correlationID:(NSNumber*) correlationID;
//*****


//***** Speak *****
+(SDLSpeak*) buildSpeakWithTTSChunks:(NSArray*) ttsChunks correlationID:(NSNumber*) correlationID;

//***
+(SDLSpeak*) buildSpeakWithTTS:(NSString*) ttsText correlationID:(NSNumber*) correlationID;
//*****


+(SDLSubscribeButton*) buildSubscribeButtonWithName:(SDLButtonName*) buttonName correlationID:(NSNumber*) correlationID;

+(SDLSubscribeVehicleData*) buildSubscribeVehicleDataWithGPS:(NSNumber*) gps speed:(NSNumber*) speed rpm:(NSNumber*) rpm fuelLevel:(NSNumber*) fuelLevel fuelLevelState:(NSNumber*) fuelLevelState instantFuelConsumption:(NSNumber*) instantFuelConsumption externalTemperature:(NSNumber*) externalTemperature prndl:(NSNumber*) prndl tirePressure:(NSNumber*) tirePressure odometer:(NSNumber*) odometer beltStatus:(NSNumber*) beltStatus bodyInformation:(NSNumber*) bodyInformation deviceStatus:(NSNumber*) deviceStatus driverBraking:(NSNumber*) driverBraking wiperStatus:(NSNumber*) wiperStatus headLampStatus:(NSNumber*) headLampStatus engineTorque:(NSNumber*) engineTorque accPedalPosition:(NSNumber*) accPedalPosition steeringWheelAngle:(NSNumber*) steeringWheelAngle correlationID:(NSNumber*) correlationID;

+(SDLUnregisterAppInterface*) buildUnregisterAppInterfaceWithCorrelationID:(NSNumber*) correlationID;

+(SDLUnsubscribeButton*) buildUnsubscribeButtonWithName:(SDLButtonName*) buttonName correlationID:(NSNumber*) correlationID;

+(SDLUnsubscribeVehicleData*) buildUnsubscribeVehicleDataWithGPS:(NSNumber*) gps speed:(NSNumber*) speed rpm:(NSNumber*) rpm fuelLevel:(NSNumber*) fuelLevel fuelLevelState:(NSNumber*) fuelLevelState instantFuelConsumption:(NSNumber*) instantFuelConsumption externalTemperature:(NSNumber*) externalTemperature prndl:(NSNumber*) prndl tirePressure:(NSNumber*) tirePressure odometer:(NSNumber*) odometer beltStatus:(NSNumber*) beltStatus bodyInformation:(NSNumber*) bodyInformation deviceStatus:(NSNumber*) deviceStatus driverBraking:(NSNumber*) driverBraking wiperStatus:(NSNumber*) wiperStatus headLampStatus:(NSNumber*) headLampStatus engineTorque:(NSNumber*) engineTorque accPedalPosition:(NSNumber*) accPedalPosition steeringWheelAngle:(NSNumber*) steeringWheelAngle correlationID:(NSNumber*) correlationID;

@end
