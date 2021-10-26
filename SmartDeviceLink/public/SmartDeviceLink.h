//  SmartDeviceLink.h
//

#import <UIKit/UIKit.h>

/// Project version number for SmartDeviceLink.
FOUNDATION_EXPORT double SmartDeviceLinkVersionNumber;

/// Project version string for SmartDeviceLink.
FOUNDATION_EXPORT const unsigned char SmartDeviceLinkVersionString[];

#pragma mark - RPCs
#pragma mark Superclasses
#import "SDLEnum.h"
#import "SDLRPCMessage.h"
#import "SDLRPCNotification.h"
#import "SDLRPCRequest.h"
#import "SDLRPCResponse.h"
#import "SDLRPCStruct.h"

#pragma mark Requests
#import "SDLAddCommand.h"
#import "SDLAddSubMenu.h"
#import "SDLAlert.h"
#import "SDLAlertManeuver.h"
#import "SDLButtonPress.h"
#import "SDLCancelInteraction.h"
#import "SDLChangeRegistration.h"
#import "SDLCloseApplication.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateWindow.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteFile.h"
#import "SDLDeleteInteractionChoiceSet.h"
#import "SDLDeleteSubMenu.h"
#import "SDLDeleteWindow.h"
#import "SDLDiagnosticMessage.h"
#import "SDLDialNumber.h"
#import "SDLEncodedSyncPData.h"
#import "SDLEndAudioPassThru.h"
#import "SDLGetAppServiceData.h"
#import "SDLGetCloudAppProperties.h"
#import "SDLGetDTCs.h"
#import "SDLGetFile.h"
#import "SDLGetInteriorVehicleData.h"
#import "SDLGetInteriorVehicleDataConsent.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetVehicleData.h"
#import "SDLGetWayPoints.h"
#import "SDLListFiles.h"
#import "SDLPerformAppServiceInteraction.h"
#import "SDLPerformAudioPassThru.h"
#import "SDLPerformInteraction.h"
#import "SDLPublishAppService.h"
#import "SDLPutFile.h"
#import "SDLReadDID.h"
#import "SDLRegisterAppInterface.h"
#import "SDLReleaseInteriorVehicleDataModule.h"
#import "SDLResetGlobalProperties.h"
#import "SDLScrollableMessage.h"
#import "SDLSendHapticData.h"
#import "SDLSendLocation.h"
#import "SDLSetAppIcon.h"
#import "SDLSetCloudAppProperties.h"
#import "SDLSetDisplayLayout.h"
#import "SDLSetGlobalProperties.h"
#import "SDLSetInteriorVehicleData.h"
#import "SDLSetMediaClockTimer.h"
#import "SDLShow.h"
#import "SDLShowAppMenu.h"
#import "SDLShowConstantTBT.h"
#import "SDLSlider.h"
#import "SDLSpeak.h"
#import "SDLSubscribeButton.h"
#import "SDLSubscribeVehicleData.h"
#import "SDLSubscribeWayPoints.h"
#import "SDLSubtleAlert.h"
#import "SDLSyncPData.h"
#import "SDLSystemRequest.h"
#import "SDLUnpublishAppService.h"
#import "SDLUnregisterAppInterface.h"
#import "SDLUnsubscribeButton.h"
#import "SDLUnsubscribeVehicleData.h"
#import "SDLUnsubscribeWayPoints.h"
#import "SDLUpdateTurnList.h"

#pragma mark Responses
#import "SDLAddCommandResponse.h"
#import "SDLAddSubMenuResponse.h"
#import "SDLAlertManeuverResponse.h"
#import "SDLAlertResponse.h"
#import "SDLButtonPressResponse.h"
#import "SDLCancelInteractionResponse.h"
#import "SDLChangeRegistrationResponse.h"
#import "SDLCloseApplicationResponse.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLCreateWindowResponse.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLDeleteFileResponse.h"
#import "SDLDeleteInteractionChoiceSetResponse.h"
#import "SDLDeleteSubMenuResponse.h"
#import "SDLDeleteWindowResponse.h"
#import "SDLDiagnosticMessageResponse.h"
#import "SDLDialNumberResponse.h"
#import "SDLEncodedSyncPDataResponse.h"
#import "SDLEndAudioPassThruResponse.h"
#import "SDLGenericResponse.h"
#import "SDLGetAppServiceDataResponse.h"
#import "SDLGetCloudAppPropertiesResponse.h"
#import "SDLGetDTCsResponse.h"
#import "SDLGetFileResponse.h"
#import "SDLGetInteriorVehicleDataConsentResponse.h"
#import "SDLGetInteriorVehicleDataResponse.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGetVehicleDataResponse.h"
#import "SDLGetWayPointsResponse.h"
#import "SDLListFilesResponse.h"
#import "SDLPerformAppServiceInteractionResponse.h"
#import "SDLPerformAudioPassThruResponse.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLPublishAppServiceResponse.h"
#import "SDLPutFileResponse.h"
#import "SDLReadDIDResponse.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLReleaseInteriorVehicleDataModuleResponse.h"
#import "SDLResetGlobalPropertiesResponse.h"
#import "SDLScrollableMessageResponse.h"
#import "SDLSendHapticDataResponse.h"
#import "SDLSendLocationResponse.h"
#import "SDLSetAppIconResponse.h"
#import "SDLSetCloudAppPropertiesResponse.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSetGlobalPropertiesResponse.h"
#import "SDLSetInteriorVehicleDataResponse.h"
#import "SDLSetMediaClockTimerResponse.h"
#import "SDLShowAppMenuResponse.h"
#import "SDLShowConstantTBTResponse.h"
#import "SDLShowResponse.h"
#import "SDLSliderResponse.h"
#import "SDLSpeakResponse.h"
#import "SDLSubscribeButtonResponse.h"
#import "SDLSubscribeVehicleDataResponse.h"
#import "SDLSubscribeWayPointsResponse.h"
#import "SDLSubtleAlertResponse.h"
#import "SDLSyncPDataResponse.h"
#import "SDLSystemRequestResponse.h"
#import "SDLUnpublishAppServiceResponse.h"
#import "SDLUnregisterAppInterfaceResponse.h"
#import "SDLUnsubscribeButtonResponse.h"
#import "SDLUnsubscribeVehicleDataResponse.h"
#import "SDLUnsubscribeWayPointsResponse.h"
#import "SDLUpdateTurnListResponse.h"

#pragma mark Notifications
#import "SDLOnAppCapabilityUpdated.h"
#import "SDLOnAppInterfaceUnregistered.h"
#import "SDLOnAppServiceData.h"
#import "SDLOnAudioPassThru.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLOnCommand.h"
#import "SDLOnDriverDistraction.h"
#import "SDLOnEncodedSyncPData.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnHashChange.h"
#import "SDLOnInteriorVehicleData.h"
#import "SDLOnKeyboardInput.h"
#import "SDLOnLanguageChange.h"
#import "SDLOnPermissionsChange.h"
#import "SDLOnRCStatus.h"
#import "SDLOnSubtleAlertPressed.h"
#import "SDLOnSyncPData.h"
#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLOnSystemRequest.h"
#import "SDLOnTBTClientState.h"
#import "SDLOnTouchEvent.h"
#import "SDLOnUpdateFile.h"
#import "SDLOnUpdateSubMenu.h"
#import "SDLOnVehicleData.h"
#import "SDLOnWayPointChange.h"

#pragma mark Structs
#import "SDLAirbagStatus.h"
#import "SDLAppCapability.h"
#import "SDLAppInfo.h"
#import "SDLAppServiceCapability.h"
#import "SDLAppServiceData.h"
#import "SDLAppServiceManifest.h"
#import "SDLAppServiceRecord.h"
#import "SDLAppServicesCapabilities.h"
#import "SDLAudioControlCapabilities.h"
#import "SDLAudioControlData.h"
#import "SDLAudioPassThruCapabilities.h"
#import "SDLBeltStatus.h"
#import "SDLBodyInformation.h"
#import "SDLButtonCapabilities.h"
#import "SDLChoice.h"
#import "SDLClimateControlCapabilities.h"
#import "SDLClimateControlData.h"
#import "SDLClimateData.h"
#import "SDLCloudAppProperties.h"
#import "SDLClusterModeStatus.h"
#import "SDLDateTime.h"
#import "SDLDeviceInfo.h"
#import "SDLDeviceStatus.h"
#import "SDLDIDResult.h"
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapability.h"
#import "SDLDoorStatus.h"
#import "SDLDoorStatusType.h"
#import "SDLDynamicUpdateCapabilities.h"
#import "SDLDriverDistractionCapability.h"
#import "SDLDynamicUpdateCapabilities.h"
#import "SDLECallInfo.h"
#import "SDLEmergencyEvent.h"
#import "SDLEqualizerSettings.h"
#import "SDLFuelRange.h"
#import "SDLGateStatus.h"
#import "SDLGearStatus.h"
#import "SDLGPSData.h"
#import "SDLGrid.h"
#import "SDLHapticRect.h"
#import "SDLHeadLampStatus.h"
#import "SDLHMICapabilities.h"
#import "SDLHMIPermissions.h"
#import "SDLHMISettingsControlCapabilities.h"
#import "SDLHMISettingsControlData.h"
#import "SDLImage.h"
#import "SDLImageField.h"
#import "SDLImageResolution.h"
#import "SDLKeyboardCapabilities.h"
#import "SDLKeyboardLayoutCapability.h"
#import "SDLKeyboardProperties.h"
#import "SDLLightCapabilities.h"
#import "SDLLightControlCapabilities.h"
#import "SDLLightControlData.h"
#import "SDLLightState.h"
#import "SDLLocationCoordinate.h"
#import "SDLLocationDetails.h"
#import "SDLMassageCushionFirmness.h"
#import "SDLMassageModeData.h"
#import "SDLMediaServiceData.h"
#import "SDLMediaServiceManifest.h"
#import "SDLMenuParams.h"
#import "SDLMetadataTags.h"
#import "SDLModuleData.h"
#import "SDLModuleInfo.h"
#import "SDLMyKey.h"
#import "SDLNavigationCapability.h"
#import "SDLNavigationInstruction.h"
#import "SDLNavigationServiceData.h"
#import "SDLNavigationServiceManifest.h"
#import "SDLOasisAddress.h"
#import "SDLParameterPermissions.h"
#import "SDLPermissionItem.h"
#import "SDLPhoneCapability.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLRadioControlCapabilities.h"
#import "SDLRadioControlData.h"
#import "SDLRDSData.h"
#import "SDLRectangle.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRGBColor.h"
#import "SDLRoofStatus.h"
#import "SDLScreenParams.h"
#import "SDLSeatControlCapabilities.h"
#import "SDLSeatControlData.h"
#import "SDLSeatLocation.h"
#import "SDLSeatLocationCapability.h"
#import "SDLSeatMemoryAction.h"
#import "SDLSeatOccupancy.h"
#import "SDLSeatStatus.h"
#import "SDLSingleTireStatus.h"
#import "SDLSISData.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLStabilityControlsStatus.h"
#import "SDLStartTime.h"
#import "SDLStationIDNumber.h"
#import "SDLMsgVersion.h"
#import "SDLSystemCapability.h"
#import "SDLTemperature.h"
#import "SDLTemplateColorScheme.h"
#import "SDLTemplateConfiguration.h"
#import "SDLTextField.h"
#import "SDLTireStatus.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouchEventCapabilities.h"
#import "SDLTransmissionType.h"
#import "SDLTTSChunk.h"
#import "SDLTurn.h"
#import "SDLVehicleDataResult.h"
#import "SDLVehicleType.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVrHelpItem.h"
#import "SDLWeatherAlert.h"
#import "SDLWeatherData.h"
#import "SDLWeatherServiceData.h"
#import "SDLWeatherServiceManifest.h"
#import "SDLWindowCapability.h"
#import "SDLWindowStatus.h"
#import "SDLWindowState.h"
#import "SDLWindowTypeCapabilities.h"

#pragma mark Enums
#import "SDLAmbientLightStatus.h"
#import "SDLAppCapabilityType.h"
#import "SDLAppHMIType.h"
#import "SDLAppInterfaceUnregisteredReason.h"
#import "SDLAppServiceType.h"
#import "SDLAudioStreamingIndicator.h"
#import "SDLAudioStreamingState.h"
#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLButtonEventMode.h"
#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"
#import "SDLCarModeStatus.h"
#import "SDLCharacterSet.h"
#import "SDLCompassDirection.h"
#import "SDLComponentVolumeStatus.h"
#import "SDLDefrostZone.h"
#import "SDLDeliveryMode.h"
#import "SDLDeviceLevelStatus.h"
#import "SDLDimension.h"
#import "SDLDirection.h"
#import "SDLDisplayMode.h"
#import "SDLDisplayType.h"
#import "SDLDistanceUnit.h"
#import "SDLDriverDistractionState.h"
#import "SDLECallConfirmationStatus.h"
#import "SDLElectronicParkBrakeStatus.h"
#import "SDLEmergencyEventType.h"
#import "SDLFileType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLFuelType.h"
#import "SDLGlobalProperty.h"
#import "SDLHMILevel.h"
#import "SDLHMIZoneCapabilities.h"
#import "SDLHybridAppPreference.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLImageFieldName.h"
#import "SDLImageType.h"
#import "SDLInteractionMode.h"
#import "SDLKeyboardEvent.h"
#import "SDLKeyboardInputMask.h"
#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLLanguage.h"
#import "SDLLayoutMode.h"
#import "SDLLightName.h"
#import "SDLLightStatus.h"
#import "SDLMaintenanceModeStatus.h"
#import "SDLMassageCushion.h"
#import "SDLMassageMode.h"
#import "SDLMassageZone.h"
#import "SDLMediaClockFormat.h"
#import "SDLMediaType.h"
#import "SDLMenuLayout.h"
#import "SDLMenuManagerConstants.h"
#import "SDLMetadataType.h"
#import "SDLModuleType.h"
#import "SDLNavigationAction.h"
#import "SDLNavigationJunction.h"
#import "SDLNextFunction.h"
#import "SDLPRNDL.h"
#import "SDLPermissionStatus.h"
#import "SDLPowerModeQualificationStatus.h"
#import "SDLPowerModeStatus.h"
#import "SDLPredefinedLayout.h"
#import "SDLPredefinedWindows.h"
#import "SDLPrerecordedSpeech.h"
#import "SDLPrimaryAudioSource.h"
#import "SDLRPCMessageType.h"
#import "SDLRadioBand.h"
#import "SDLRadioState.h"
#import "SDLRequestType.h"
#import "SDLResult.h"
#import "SDLSamplingRate.h"
#import "SDLSeatMemoryActionType.h"
#import "SDLSeekIndicatorType.h"
#import "SDLServiceUpdateReason.h"
#import "SDLSoftButtonType.h"
#import "SDLSpeechCapabilities.h"
#import "SDLStaticIconName.h"
#import "SDLSupportedSeat.h"
#import "SDLSystemAction.h"
#import "SDLSystemCapabilityType.h"
#import "SDLSystemContext.h"
#import "SDLTBTState.h"
#import "SDLTPMS.h"
#import "SDLTemperatureUnit.h"
#import "SDLTextAlignment.h"
#import "SDLTextFieldName.h"
#import "SDLTimerMode.h"
#import "SDLTouchType.h"
#import "SDLTriggerSource.h"
#import "SDLTurnSignal.h"
#import "SDLUpdateMode.h"
#import "SDLVehicleDataActiveStatus.h"
#import "SDLVehicleDataEventStatus.h"
#import "SDLVehicleDataNotificationStatus.h"
#import "SDLVehicleDataResultCode.h"
#import "SDLVehicleDataStatus.h"
#import "SDLVehicleDataType.h"
#import "SDLVentilationMode.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingProtocol.h"
#import "SDLVideoStreamingState.h"
#import "SDLVrCapabilities.h"
#import "SDLWarningLightStatus.h"
#import "SDLWayPointType.h"
#import "SDLWindowType.h"
#import "SDLWiperStatus.h"

#pragma mark - Developer API
#pragma mark Configurations
#import "SDLConfiguration.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLFileManagerConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleConfigurationUpdate.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLStreamingMediaConfiguration.h"

#pragma mark Encryption
#import "SDLProtocolConstants.h"
#import "SDLServiceEncryptionDelegate.h"

#pragma mark Streaming
#import "SDLAudioFile.h"
#import "SDLAudioStreamManager.h"
#import "SDLAudioStreamManagerDelegate.h"
#import "SDLCarWindowViewController.h"
#import "SDLStreamingAudioManagerType.h"
#import "SDLStreamingMediaManager.h"
#import "SDLTouchManager.h"
#import "SDLTouchManagerDelegate.h"
#import "SDLSecurityType.h"
#import "SDLStreamingVideoDelegate.h"
#import "SDLSeekStreamingIndicator.h"
#import "SDLStreamingMediaManagerDataSource.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLVideoStreamingRange.h"

#pragma mark Files
#import "SDLArtwork.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLFileManagerConstants.h"

#pragma mark Lockscreen
#import "SDLLockScreenViewController.h"

#pragma mark Lifecycle
#import "SDLManager.h"
#import "SDLManagerDelegate.h"

#pragma mark System Capabilities
#import "SDLSystemCapabilityManager.h"

#pragma mark Permissions
#import "SDLPermissionConstants.h"
#import "SDLPermissionElement.h"
#import "SDLRPCPermissionStatus.h"
#import "SDLPermissionManager.h"

#pragma mark Screen
#import "SDLScreenManager.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

#import "SDLMenuCell.h"
#import "SDLMenuConfiguration.h"
#import "SDLVoiceCommand.h"

#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLKeyboardDelegate.h"

#import "SDLAlertAudioData.h"
#import "SDLAlertView.h"
#import "SDLAudioData.h"

#pragma mark Touches
#import "SDLPinchGesture.h"
#import "SDLTouch.h"

#pragma mark - Utilities
#import "NSNumber+NumberType.h"
#import "SDLErrorConstants.h"
#import "SDLFunctionID.h"
#import "SDLRPCFunctionNames.h"
#import "SDLNotificationConstants.h"
#import "SDLStreamingMediaManagerConstants.h"
#import "SDLVersion.h"

#pragma mark Notifications
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLRPCRequestNotification.h"

#pragma mark Logger
#import "SDLLogConstants.h"
#import "SDLLogConfiguration.h"
#import "SDLLogFileModule.h"
#import "SDLLogFilter.h"
#import "SDLLogManager.h"
#import "SDLLogMacros.h"
#import "SDLLogTarget.h"
#import "SDLLogTargetAppleSystemLog.h"
#import "SDLLogTargetFile.h"
#import "SDLLogTargetOSLog.h"
