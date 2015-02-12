//
//  SmartDeviceLink.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for SmartDeviceLink.
FOUNDATION_EXPORT double SmartDeviceLinkVersionNumber;

//! Project version string for SmartDeviceLink.
FOUNDATION_EXPORT const unsigned char SmartDeviceLinkVersionString[];

/**** Utilities *****/
#import <SmartDeviceLink/SDLJingle.h>

/***** Proxy *****/
#import <SmartDeviceLink/SDLProxy.h>
#import <SmartDeviceLink/SDLProxyListener.h>
#import <SmartDeviceLink/SDLProxyFactory.h>
#import <SmartDeviceLink/SDLTTSChunkFactory.h>

/***** Debug *****/
#import <SmartDeviceLink/SDLConsoleController.h>
#import <SmartDeviceLink/SDLDebugTool.h>
#import <SmartDeviceLink/SDLSiphonServer.h>

/***** Transport *****/
#import <SmartDeviceLink/SDLAbstractTransport.h>
#import <SmartDeviceLink/SDLIAPTransport.h>
#import <SmartDeviceLink/SDLTCPTransport.h>
#import <SmartDeviceLink/SDLTransport.h>
#import <SmartDeviceLink/SDLTransportDelegate.h>
#import <SmartDeviceLink/SDLInterfaceProtocol.h>

/***** Protocol *****/
#import <SmartDeviceLink/SDLProtocolListener.h>
#import <SmartDeviceLink/SDLAbstractProtocol.h>
#import <SmartDeviceLink/SDLProtocol.h>

// Header
#import <SmartDeviceLink/SDLProtocolHeader.h>

// Message
#import <SmartDeviceLink/SDLProtocolMessage.h>

/***** RPCs *****/
// Superclasses
#import <SmartDeviceLink/SDLEnum.h>
#import <SmartDeviceLink/SDLRPCMessage.h>
#import <SmartDeviceLink/SDLRPCNotification.h>
#import <SmartDeviceLink/SDLRPCRequest.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

// Factories
#import <SmartDeviceLink/SDLRPCRequestFactory.h>

// Requests
#import <SmartDeviceLink/SDLAddCommand.h>
#import <SmartDeviceLink/SDLAddSubMenu.h>
#import <SmartDeviceLink/SDLAlert.h>
#import <SmartDeviceLink/SDLAlertManeuver.h>
#import <SmartDeviceLink/SDLChangeRegistration.h>
#import <SmartDeviceLink/SDLCreateInteractionChoiceSet.h>
#import <SmartDeviceLink/SDLDeleteCommand.h>
#import <SmartDeviceLink/SDLDeleteFile.h>
#import <SmartDeviceLink/SDLDeleteInteractionChoiceSet.h>
#import <SmartDeviceLink/SDLDeleteSubMenu.h>
#import <SmartDeviceLink/SDLDiagnosticMessage.h>
#import <SmartDeviceLink/SDLEncodedSyncPData.h>
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
#import <SmartDeviceLink/SDLShowConstantTBT.h>
#import <SmartDeviceLink/SDLSlider.h>
#import <SmartDeviceLink/SDLSpeak.h>
#import <SmartDeviceLink/SDLSubscribeButton.h>
#import <SmartDeviceLink/SDLSubscribeVehicleData.h>
#import <SmartDeviceLink/SDLSyncPData.h>
#import <SmartDeviceLink/SDLUnregisterAppInterface.h>
#import <SmartDeviceLink/SDLUnsubscribeButton.h>
#import <SmartDeviceLink/SDLUnsubscribeVehicleData.h>
#import <SmartDeviceLink/SDLUpdateTurnList.h>

// Responses
#import <SmartDeviceLink/SDLAddCommandResponse.h>
#import <SmartDeviceLink/SDLAddSubMenuResponse.h>
#import <SmartDeviceLink/SDLAlertManeuverResponse.h>
#import <SmartDeviceLink/SDLAlertResponse.h>
#import <SmartDeviceLink/SDLChangeRegistrationResponse.h>
#import <SmartDeviceLink/SDLCreateInteractionChoiceSetResponse.h>
#import <SmartDeviceLink/SDLDeleteCommandResponse.h>
#import <SmartDeviceLink/SDLDeleteFileResponse.h>
#import <SmartDeviceLink/SDLDeleteInteractionChoiceSetResponse.h>
#import <SmartDeviceLink/SDLDeleteSubMenuResponse.h>
#import <SmartDeviceLink/SDLDiagnosticMessageResponse.h>
#import <SmartDeviceLink/SDLEncodedSyncPDataResponse.h>
#import <SmartDeviceLink/SDLEndAudioPassThruResponse.h>
#import <SmartDeviceLink/SDLGenericResponse.h>
#import <SmartDeviceLink/SDLGetDTCsResponse.h>
#import <SmartDeviceLink/SDLGetVehicleDataResponse.h>
#import <SmartDeviceLink/SDLListFilesResponse.h>
#import <SmartDeviceLink/SDLPerformAudioPassThruResponse.h>
#import <SmartDeviceLink/SDLPerformInteractionResponse.h>
#import <SmartDeviceLink/SDLPutFileResponse.h>
#import <SmartDeviceLink/SDLReadDIDResponse.h>
#import <SmartDeviceLink/SDLRegisterAppInterfaceResponse.h>
#import <SmartDeviceLink/SDLResetGlobalPropertiesResponse.h>
#import <SmartDeviceLink/SDLScrollableMessageResponse.h>
#import <SmartDeviceLink/SDLSetAppIconResponse.h>
#import <SmartDeviceLink/SDLSetDisplayLayoutResponse.h>
#import <SmartDeviceLink/SDLSetGlobalPropertiesResponse.h>
#import <SmartDeviceLink/SDLSetMediaClockTimerResponse.h>
#import <SmartDeviceLink/SDLShowConstantTBTResponse.h>
#import <SmartDeviceLink/SDLShowResponse.h>
#import <SmartDeviceLink/SDLSliderResponse.h>
#import <SmartDeviceLink/SDLSpeakResponse.h>
#import <SmartDeviceLink/SDLSubscribeButtonResponse.h>
#import <SmartDeviceLink/SDLSubscribeVehicleDataResponse.h>
#import <SmartDeviceLink/SDLSyncPDataResponse.h>
#import <SmartDeviceLink/SDLUnregisterAppInterfaceResponse.h>
#import <SmartDeviceLink/SDLUnsubscribeButtonResponse.h>
#import <SmartDeviceLink/SDLUnsubscribeVehicleDataResponse.h>
#import <SmartDeviceLink/SDLUpdateTurnListResponse.h>

// Notifications
#import <SmartDeviceLink/SDLOnAppInterfaceUnregistered.h>
#import <SmartDeviceLink/SDLOnAudioPassThru.h>
#import <SmartDeviceLink/SDLOnButtonEvent.h>
#import <SmartDeviceLink/SDLOnButtonPress.h>
#import <SmartDeviceLink/SDLOnCommand.h>
#import <SmartDeviceLink/SDLOnDriverDistraction.h>
#import <SmartDeviceLink/SDLOnEncodedSyncPData.h>
#import <SmartDeviceLink/SDLOnHashChange.h>
#import <SmartDeviceLink/SDLOnHMIStatus.h>
#import <SmartDeviceLink/SDLOnKeyboardInput.h>
#import <SmartDeviceLink/SDLOnLanguageChange.h>
#import <SmartDeviceLink/SDLOnLockScreenStatus.h>
#import <SmartDeviceLink/SDLOnPermissionsChange.h>
#import <SmartDeviceLink/SDLOnSyncPData.h>
#import <SmartDeviceLink/SDLOnSystemRequest.h>
#import <SmartDeviceLink/SDLOnTBTClientState.h>
#import <SmartDeviceLink/SDLOnTouchEvent.h>
#import <SmartDeviceLink/SDLOnVehicleData.h>

// Structs
#import <SmartDeviceLink/SDLAirbagStatus.h>
#import <SmartDeviceLink/SDLAudioPassThruCapabilities.h>
#import <SmartDeviceLink/SDLBeltStatus.h>
#import <SmartDeviceLink/SDLBodyInformation.h>
#import <SmartDeviceLink/SDLButtonCapabilities.h>
#import <SmartDeviceLink/SDLChoice.h>
#import <SmartDeviceLink/SDLClusterModeStatus.h>
#import <SmartDeviceLink/SDLDeviceInfo.h>
#import <SmartDeviceLink/SDLDeviceStatus.h>
#import <SmartDeviceLink/SDLDIDResult.h>
#import <SmartDeviceLink/SDLDisplayCapabilities.h>
#import <SmartDeviceLink/SDLECallInfo.h>
#import <SmartDeviceLink/SDLEmergencyEvent.h>
#import <SmartDeviceLink/SDLGPSData.h>
#import <SmartDeviceLink/SDLHeadLampStatus.h>
#import <SmartDeviceLink/SDLHMIPermissions.h>
#import <SmartDeviceLink/SDLImage.h>
#import <SmartDeviceLink/SDLImageField.h>
#import <SmartDeviceLink/SDLImageResolution.h>
#import <SmartDeviceLink/SDLKeyboardProperties.h>
#import <SmartDeviceLink/SDLMenuParams.h>
#import <SmartDeviceLink/SDLMyKey.h>
#import <SmartDeviceLink/SDLParameterPermissions.h>
#import <SmartDeviceLink/SDLPermissionItem.h>
#import <SmartDeviceLink/SDLPresetBankCapabilities.h>
#import <SmartDeviceLink/SDLScreenParams.h>
#import <SmartDeviceLink/SDLSingleTireStatus.h>
#import <SmartDeviceLink/SDLSoftButton.h>
#import <SmartDeviceLink/SDLSoftButtonCapabilities.h>
#import <SmartDeviceLink/SDLSyncMsgVersion.h>
#import <SmartDeviceLink/SDLTextField.h>
#import <SmartDeviceLink/SDLTireStatus.h>
#import <SmartDeviceLink/SDLTouchCoord.h>
#import <SmartDeviceLink/SDLTouchEvent.h>
#import <SmartDeviceLink/SDLTouchEventCapabilities.h>
#import <SmartDeviceLink/SDLTTSChunk.h>
#import <SmartDeviceLink/SDLTurn.h>
#import <SmartDeviceLink/SDLVehicleDataResult.h>
#import <SmartDeviceLink/SDLVehicleType.h>
#import <SmartDeviceLink/SDLVrHelpItem.h>

// Enums
#import <SmartDeviceLink/SDLAmbientLightStatus.h>
#import <SmartDeviceLink/SDLAppHMIType.h>
#import <SmartDeviceLink/SDLAppInterfaceUnregisteredReason.h>
#import <SmartDeviceLink/SDLAudioStreamingState.h>
#import <SmartDeviceLink/SDLAudioType.h>
#import <SmartDeviceLink/SDLBitsPerSample.h>
#import <SmartDeviceLink/SDLButtonEventMode.h>
#import <SmartDeviceLink/SDLButtonName.h>
#import <SmartDeviceLink/SDLButtonPressMode.h>
#import <SmartDeviceLink/SDLCarModeStatus.h>
#import <SmartDeviceLink/SDLCharacterSet.h>
#import <SmartDeviceLink/SDLCompassDirection.h>
#import <SmartDeviceLink/SDLComponentVolumeStatus.h>
#import <SmartDeviceLink/SDLDeviceLevelStatus.h>
#import <SmartDeviceLink/SDLDimension.h>
#import <SmartDeviceLink/SDLDisplayType.h>
#import <SmartDeviceLink/SDLDriverDistractionState.h>
#import <SmartDeviceLink/SDLECallConfirmationStatus.h>
#import <SmartDeviceLink/SDLEmergencyEventType.h>
#import <SmartDeviceLink/SDLFileType.h>
#import <SmartDeviceLink/SDLFuelCutoffStatus.h>
#import <SmartDeviceLink/SDLGlobalProperty.h>
#import <SmartDeviceLink/SDLHMILevel.h>
#import <SmartDeviceLink/SDLHMIZoneCapabilities.h>
#import <SmartDeviceLink/SDLIgnitionStableStatus.h>
#import <SmartDeviceLink/SDLIgnitionStatus.h>
#import <SmartDeviceLink/SDLImageFieldName.h>
#import <SmartDeviceLink/SDLImageType.h>
#import <SmartDeviceLink/SDLInteractionMode.h>
#import <SmartDeviceLink/SDLKeyboardEvent.h>
#import <SmartDeviceLink/SDLKeyboardLayout.h>
#import <SmartDeviceLink/SDLKeypressMode.h>
#import <SmartDeviceLink/SDLLanguage.h>
#import <SmartDeviceLink/SDLLayoutMode.h>
#import <SmartDeviceLink/SDLLockScreenStatus.h>
#import <SmartDeviceLink/SDLMaintenanceModeStatus.h>
#import <SmartDeviceLink/SDLMediaClockFormat.h>
#import <SmartDeviceLink/SDLPermissionStatus.h>
#import <SmartDeviceLink/SDLPowerModeQualificationStatus.h>
#import <SmartDeviceLink/SDLPowerModeStatus.h>
#import <SmartDeviceLink/SDLPredefinedLayout.h>
#import <SmartDeviceLink/SDLPrerecordedSpeech.h>
#import <SmartDeviceLink/SDLPrimaryAudioSource.h>
#import <SmartDeviceLink/SDLPRNDL.h>
#import <SmartDeviceLink/SDLRequestType.h>
#import <SmartDeviceLink/SDLResult.h>
#import <SmartDeviceLink/SDLRPCMessageType.h>
#import <SmartDeviceLink/SDLSamplingRate.h>
#import <SmartDeviceLink/SDLSoftButtonType.h>
#import <SmartDeviceLink/SDLSpeechCapabilities.h>
#import <SmartDeviceLink/SDLStartTime.h>
#import <SmartDeviceLink/SDLSystemAction.h>
#import <SmartDeviceLink/SDLSystemContext.h>
#import <SmartDeviceLink/SDLTBTState.h>
#import <SmartDeviceLink/SDLTextAlignment.h>
#import <SmartDeviceLink/SDLTextFieldName.h>
#import <SmartDeviceLink/SDLTimerMode.h>
#import <SmartDeviceLink/SDLTouchType.h>
#import <SmartDeviceLink/SDLTriggerSource.h>
#import <SmartDeviceLink/SDLUpdateMode.h>
#import <SmartDeviceLink/SDLVehicleDataActiveStatus.h>
#import <SmartDeviceLink/SDLVehicleDataEventStatus.h>
#import <SmartDeviceLink/SDLVehicleDataNotificationStatus.h>
#import <SmartDeviceLink/SDLVehicleDataResultCode.h>
#import <SmartDeviceLink/SDLVehicleDataStatus.h>
#import <SmartDeviceLink/SDLVehicleDataType.h>
#import <SmartDeviceLink/SDLVrCapabilities.h>
#import <SmartDeviceLink/SDLWarningLightStatus.h>
#import <SmartDeviceLink/SDLWiperStatus.h>
