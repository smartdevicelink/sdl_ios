Pod::Spec.new do |s|

s.name         = "SmartDeviceLink"
s.version      = "5.2.0"
s.summary      = "Connect your app with cars!"
s.homepage     = "https://github.com/smartdevicelink/SmartDeviceLink-iOS"
s.license      = { :type => "New BSD", :file => "LICENSE" }
s.author       = { "SmartDeviceLink Team" => "developer@smartdevicelink.com" }
s.platform     = :ios, "8.0"
s.dependency     'BiSON', '~> 1.1.1'
s.source       = { :git => "https://github.com/smartdevicelink/sdl_ios.git", :tag => s.version.to_s }
s.requires_arc = true
s.resource_bundles = { 'SmartDeviceLink' => ['SmartDeviceLink/Assets/**/*'] }

s.default_subspec = 'Default'

s.subspec 'Default' do |ss|
ss.source_files = 'SmartDeviceLink/*.{h,m}'

ss.public_header_files = [
'SmartDeviceLink/NSNumber+NumberType.h',
'SmartDeviceLink/SDLAddCommand.h',
'SmartDeviceLink/SDLAddCommandResponse.h',
'SmartDeviceLink/SDLAddSubMenu.h',
'SmartDeviceLink/SDLAddSubMenuResponse.h',
'SmartDeviceLink/SDLAirbagStatus.h',
'SmartDeviceLink/SDLAlert.h',
'SmartDeviceLink/SDLAlertManeuver.h',
'SmartDeviceLink/SDLAlertManeuverResponse.h',
'SmartDeviceLink/SDLAlertResponse.h',
'SmartDeviceLink/SDLButtonPressResponse.h',
'SmartDeviceLink/SDLAmbientLightStatus.h',
'SmartDeviceLink/SDLAppHMIType.h',
'SmartDeviceLink/SDLAppInfo.h',
'SmartDeviceLink/SDLAppInterfaceUnregisteredReason.h',
'SmartDeviceLink/SDLArtwork.h',
'SmartDeviceLink/SDLAudioPassThruCapabilities.h',
'SmartDeviceLink/SDLAudioStreamingState.h',
'SmartDeviceLink/SDLAudioStreamManager.h',
'SmartDeviceLink/SDLAudioStreamManagerDelegate.h',
'SmartDeviceLink/SDLStreamingAudioManagerType.h',
'SmartDeviceLink/SDLAudioType.h',
'SmartDeviceLink/SDLBeltStatus.h',
'SmartDeviceLink/SDLBitsPerSample.h',
'SmartDeviceLink/SDLBodyInformation.h',
'SmartDeviceLink/SDLButtonCapabilities.h',
'SmartDeviceLink/SDLButtonEventMode.h',
'SmartDeviceLink/SDLButtonName.h',
'SmartDeviceLink/SDLButtonPress.h',
'SmartDeviceLink/SDLButtonPressMode.h',
'SmartDeviceLink/SDLCarModeStatus.h',
'SmartDeviceLink/SDLCarWindowViewController.h',
'SmartDeviceLink/SDLChangeRegistration.h',
'SmartDeviceLink/SDLChangeRegistrationResponse.h',
'SmartDeviceLink/SDLCharacterSet.h',
'SmartDeviceLink/SDLChoice.h',
'SmartDeviceLink/SDLClimateControlCapabilities.h',
'SmartDeviceLink/SDLClimateControlData.h',
'SmartDeviceLink/SDLClusterModeStatus.h',
'SmartDeviceLink/SDLCompassDirection.h',
'SmartDeviceLink/SDLComponentVolumeStatus.h',
'SmartDeviceLink/SDLConfiguration.h',
'SmartDeviceLink/SDLCreateInteractionChoiceSet.h',
'SmartDeviceLink/SDLCreateInteractionChoiceSetResponse.h',
'SmartDeviceLink/SDLDateTime.h',
'SmartDeviceLink/SDLDefrostZone.h',
'SmartDeviceLink/SDLDeleteCommand.h',
'SmartDeviceLink/SDLDeleteCommandResponse.h',
'SmartDeviceLink/SDLDeleteFile.h',
'SmartDeviceLink/SDLDeleteFileResponse.h',
'SmartDeviceLink/SDLDeleteInteractionChoiceSet.h',
'SmartDeviceLink/SDLDeleteInteractionChoiceSetResponse.h',
'SmartDeviceLink/SDLDeleteSubMenu.h',
'SmartDeviceLink/SDLDeleteSubMenuResponse.h',
'SmartDeviceLink/SDLDeliveryMode.h',
'SmartDeviceLink/SDLDeviceInfo.h',
'SmartDeviceLink/SDLDeviceLevelStatus.h',
'SmartDeviceLink/SDLDeviceStatus.h',
'SmartDeviceLink/SDLDiagnosticMessage.h',
'SmartDeviceLink/SDLDiagnosticMessageResponse.h',
'SmartDeviceLink/SDLDialNumber.h',
'SmartDeviceLink/SDLDialNumberResponse.h',
'SmartDeviceLink/SDLDIDResult.h',
'SmartDeviceLink/SDLDimension.h',
'SmartDeviceLink/SDLDisplayCapabilities.h',
'SmartDeviceLink/SDLDisplayType.h',
'SmartDeviceLink/SDLDriverDistractionState.h',
'SmartDeviceLink/SDLECallConfirmationStatus.h',
'SmartDeviceLink/SDLECallInfo.h',
'SmartDeviceLink/SDLEmergencyEvent.h',
'SmartDeviceLink/SDLEmergencyEventType.h',
'SmartDeviceLink/SDLEncodedSyncPData.h',
'SmartDeviceLink/SDLEncodedSyncPDataResponse.h',
'SmartDeviceLink/SDLEndAudioPassThru.h',
'SmartDeviceLink/SDLEndAudioPassThruResponse.h',
'SmartDeviceLink/SDLEnum.h',
'SmartDeviceLink/SDLErrorConstants.h',
'SmartDeviceLink/SDLFile.h',
'SmartDeviceLink/SDLFileManager.h',
'SmartDeviceLink/SDLFileManagerConstants.h',
'SmartDeviceLink/SDLFileType.h',
'SmartDeviceLink/SDLFuelCutoffStatus.h',
'SmartDeviceLink/SDLFuelRange.h',
'SmartDeviceLink/SDLFuelType.h',
'SmartDeviceLink/SDLGenericResponse.h',
'SmartDeviceLink/SDLGetDTCs.h',
'SmartDeviceLink/SDLGetInteriorVehicleData.h',
'SmartDeviceLink/SDLGetDTCsResponse.h',
'SmartDeviceLink/SDLGetInteriorVehicleDataResponse.h',
'SmartDeviceLink/SDLGetSystemCapability.h',
'SmartDeviceLink/SDLGetSystemCapabilityResponse.h',
'SmartDeviceLink/SDLGetVehicleData.h',
'SmartDeviceLink/SDLGetVehicleDataResponse.h',
'SmartDeviceLink/SDLGetWaypoints.h',
'SmartDeviceLink/SDLGetWaypointsResponse.h',
'SmartDeviceLink/SDLGlobalProperty.h',
'SmartDeviceLink/SDLGPSData.h',
'SmartDeviceLink/SDLHapticRect.h',
'SmartDeviceLink/SDLHeadLampStatus.h',
'SmartDeviceLink/SDLHMICapabilities.h',
'SmartDeviceLink/SDLHMILevel.h',
'SmartDeviceLink/SDLHMIPermissions.h',
'SmartDeviceLink/SDLHMIZoneCapabilities.h',
'SmartDeviceLink/SDLIgnitionStableStatus.h',
'SmartDeviceLink/SDLIgnitionStatus.h',
'SmartDeviceLink/SDLImage.h',
'SmartDeviceLink/SDLImageField.h',
'SmartDeviceLink/SDLImageFieldName.h',
'SmartDeviceLink/SDLImageResolution.h',
'SmartDeviceLink/SDLImageType.h',
'SmartDeviceLink/SDLInteractionMode.h',
'SmartDeviceLink/SDLKeyboardEvent.h',
'SmartDeviceLink/SDLKeyboardLayout.h',
'SmartDeviceLink/SDLKeyboardProperties.h',
'SmartDeviceLink/SDLKeypressMode.h',
'SmartDeviceLink/SDLLanguage.h',
'SmartDeviceLink/SDLLayoutMode.h',
'SmartDeviceLink/SDLLifecycleConfiguration.h',
'SmartDeviceLink/SDLLifecycleConfigurationUpdate.h',
'SmartDeviceLink/SDLListFiles.h',
'SmartDeviceLink/SDLListFilesResponse.h',
'SmartDeviceLink/SDLLocationCoordinate.h',
'SmartDeviceLink/SDLLocationDetails.h',
'SmartDeviceLink/SDLLockScreenConfiguration.h',
'SmartDeviceLink/SDLLockScreenStatus.h',
'SmartDeviceLink/SDLLockScreenViewController.h',
'SmartDeviceLink/SDLLogConfiguration.h',
'SmartDeviceLink/SDLLogConstants.h',
'SmartDeviceLink/SDLLogFileModule.h',
'SmartDeviceLink/SDLLogFilter.h',
'SmartDeviceLink/SDLLogMacros.h',
'SmartDeviceLink/SDLLogManager.h',
'SmartDeviceLink/SDLLogTarget.h',
'SmartDeviceLink/SDLLogTargetAppleSystemLog.h',
'SmartDeviceLink/SDLLogTargetFile.h',
'SmartDeviceLink/SDLLogTargetOSLog.h',
'SmartDeviceLink/SDLMacros.h',
'SmartDeviceLink/SDLMaintenanceModeStatus.h',
'SmartDeviceLink/SDLManager.h',
'SmartDeviceLink/SDLManagerDelegate.h',
'SmartDeviceLink/SDLMediaClockFormat.h',
'SmartDeviceLink/SDLMenuCell.h',
'SmartDeviceLink/SDLMenuManager.h',
'SmartDeviceLink/SDLMenuParams.h',
'SmartDeviceLink/SDLMetadataTags.h',
'SmartDeviceLink/SDLMetadataType.h',
'SmartDeviceLink/SDLModuleData.h',
'SmartDeviceLink/SDLModuleType.h',
'SmartDeviceLink/SDLMyKey.h',
'SmartDeviceLink/SDLNavigationCapability.h',
'SmartDeviceLink/SDLNotificationConstants.h',
'SmartDeviceLink/SDLOasisAddress.h',
'SmartDeviceLink/SDLOnAppInterfaceUnregistered.h',
'SmartDeviceLink/SDLOnAudioPassThru.h',
'SmartDeviceLink/SDLOnButtonEvent.h',
'SmartDeviceLink/SDLOnButtonPress.h',
'SmartDeviceLink/SDLOnCommand.h',
'SmartDeviceLink/SDLOnDriverDistraction.h',
'SmartDeviceLink/SDLOnEncodedSyncPData.h',
'SmartDeviceLink/SDLOnHashChange.h',
'SmartDeviceLink/SDLOnInteriorVehicleData.h',
'SmartDeviceLink/SDLOnHMIStatus.h',
'SmartDeviceLink/SDLOnKeyboardInput.h',
'SmartDeviceLink/SDLOnLanguageChange.h',
'SmartDeviceLink/SDLOnLockScreenStatus.h',
'SmartDeviceLink/SDLOnPermissionsChange.h',
'SmartDeviceLink/SDLOnSyncPData.h',
'SmartDeviceLink/SDLOnSystemRequest.h',
'SmartDeviceLink/SDLOnTBTClientState.h',
'SmartDeviceLink/SDLOnTouchEvent.h',
'SmartDeviceLink/SDLOnVehicleData.h',
'SmartDeviceLink/SDLOnWayPointChange.h',
'SmartDeviceLink/SDLParameterPermissions.h',
'SmartDeviceLink/SDLPerformAudioPassThru.h',
'SmartDeviceLink/SDLPerformAudioPassThruResponse.h',
'SmartDeviceLink/SDLPerformInteraction.h',
'SmartDeviceLink/SDLPerformInteractionResponse.h',
'SmartDeviceLink/SDLPermissionConstants.h',
'SmartDeviceLink/SDLPermissionItem.h',
'SmartDeviceLink/SDLPermissionManager.h',
'SmartDeviceLink/SDLPermissionStatus.h',
'SmartDeviceLink/SDLPhoneCapability.h',
'SmartDeviceLink/SDLPinchGesture.h',
'SmartDeviceLink/SDLPowerModeQualificationStatus.h',
'SmartDeviceLink/SDLPowerModeStatus.h',
'SmartDeviceLink/SDLPredefinedLayout.h',
'SmartDeviceLink/SDLPrerecordedSpeech.h',
'SmartDeviceLink/SDLPresetBankCapabilities.h',
'SmartDeviceLink/SDLPrimaryAudioSource.h',
'SmartDeviceLink/SDLPRNDL.h',
'SmartDeviceLink/SDLPutFile.h',
'SmartDeviceLink/SDLPutFileResponse.h',
'SmartDeviceLink/SDLRadioBand.h',
'SmartDeviceLink/SDLRadioControlCapabilities.h',
'SmartDeviceLink/SDLRadioControlData.h',
'SmartDeviceLink/SDLRadioState.h',
'SmartDeviceLink/SDLReadDID.h',
'SmartDeviceLink/SDLRectangle.h',
'SmartDeviceLink/SDLReadDIDResponse.h',
'SmartDeviceLink/SDLRectangle.h',
'SmartDeviceLink/SDLRegisterAppInterface.h',
'SmartDeviceLink/SDLRegisterAppInterfaceResponse.h',
'SmartDeviceLink/SDLRemoteControlCapabilities.h',
'SmartDeviceLink/SDLRequestType.h',
'SmartDeviceLink/SDLResetGlobalProperties.h',
'SmartDeviceLink/SDLResetGlobalPropertiesResponse.h',
'SmartDeviceLink/SDLResult.h',
'SmartDeviceLink/SDLRDSData.h',
'SmartDeviceLink/SDLRPCMessage.h',
'SmartDeviceLink/SDLRPCMessageType.h',
'SmartDeviceLink/SDLRPCNotification.h',
'SmartDeviceLink/SDLRPCNotificationNotification.h',
'SmartDeviceLink/SDLRPCRequest.h',
'SmartDeviceLink/SDLRPCResponse.h',
'SmartDeviceLink/SDLRPCResponseNotification.h',
'SmartDeviceLink/SDLRPCStruct.h',
'SmartDeviceLink/SDLSamplingRate.h',
'SmartDeviceLink/SDLScreenParams.h',
'SmartDeviceLink/SDLScreenManager.h',
'SmartDeviceLink/SDLScrollableMessage.h',
'SmartDeviceLink/SDLScrollableMessageResponse.h',
'SmartDeviceLink/SDLSecurityType.h',
'SmartDeviceLink/SDLSendHapticData.h',
'SmartDeviceLink/SDLSendHapticDataResponse.h',
'SmartDeviceLink/SDLSendLocation.h',
'SmartDeviceLink/SDLSendLocationResponse.h',
'SmartDeviceLink/SDLSetAppIcon.h',
'SmartDeviceLink/SDLSetAppIconResponse.h',
'SmartDeviceLink/SDLSetDisplayLayout.h',
'SmartDeviceLink/SDLSetDisplayLayoutResponse.h',
'SmartDeviceLink/SDLSetGlobalProperties.h',
'SmartDeviceLink/SDLSetInteriorVehicleData.h',
'SmartDeviceLink/SDLSetGlobalPropertiesResponse.h',
'SmartDeviceLink/SDLSetInteriorVehicleDataResponse.h',
'SmartDeviceLink/SDLSetMediaClockTimer.h',
'SmartDeviceLink/SDLSetMediaClockTimerResponse.h',
'SmartDeviceLink/SDLShow.h',
'SmartDeviceLink/SDLShowConstantTBT.h',
'SmartDeviceLink/SDLShowConstantTBTResponse.h',
'SmartDeviceLink/SDLShowResponse.h',
'SmartDeviceLink/SDLSingleTireStatus.h',
'SmartDeviceLink/SDLSlider.h',
'SmartDeviceLink/SDLSliderResponse.h',
'SmartDeviceLink/SDLSoftButton.h',
'SmartDeviceLink/SDLSoftButtonCapabilities.h',
'SmartDeviceLink/SDLSoftButtonObject.h',
'SmartDeviceLink/SDLSoftButtonState.h',
'SmartDeviceLink/SDLSoftButtonType.h',
'SmartDeviceLink/SDLSpeak.h',
'SmartDeviceLink/SDLSpeakResponse.h',
'SmartDeviceLink/SDLSpeechCapabilities.h',
'SmartDeviceLink/SDLStartTime.h',
'SmartDeviceLink/SDLStreamingMediaConfiguration.h',
'SmartDeviceLink/SDLStreamingMediaManager.h',
'SmartDeviceLink/SDLStreamingMediaManagerConstants.h',
'SmartDeviceLink/SDLStreamingMediaManagerDataSource.h',
'SmartDeviceLink/SDLSubscribeButton.h',
'SmartDeviceLink/SDLSubscribeButtonResponse.h',
'SmartDeviceLink/SDLSubscribeVehicleData.h',
'SmartDeviceLink/SDLSubscribeVehicleDataResponse.h',
'SmartDeviceLink/SDLSubscribeWaypoints.h',
'SmartDeviceLink/SDLSubscribeWaypointsResponse.h',
'SmartDeviceLink/SDLSyncMsgVersion.h',
'SmartDeviceLink/SDLSyncPData.h',
'SmartDeviceLink/SDLSyncPDataResponse.h',
'SmartDeviceLink/SDLSystemAction.h',
'SmartDeviceLink/SDLSystemCapability.h',
'SmartDeviceLink/SDLSystemCapabilityManager.h',
'SmartDeviceLink/SDLSystemCapabilityType.h',
'SmartDeviceLink/SDLSystemContext.h',
'SmartDeviceLink/SDLTBTState.h',
'SmartDeviceLink/SDLTemperature.h',
'SmartDeviceLink/SDLTemperatureUnit.h',
'SmartDeviceLink/SDLTextAlignment.h',
'SmartDeviceLink/SDLTextField.h',
'SmartDeviceLink/SDLTextFieldName.h',
'SmartDeviceLink/SDLTimerMode.h',
'SmartDeviceLink/SDLTireStatus.h',
'SmartDeviceLink/SDLTouch.h',
'SmartDeviceLink/SDLTouchCoord.h',
'SmartDeviceLink/SDLTouchEvent.h',
'SmartDeviceLink/SDLTouchEventCapabilities.h',
'SmartDeviceLink/SDLTouchManager.h',
'SmartDeviceLink/SDLTouchManagerDelegate.h',
'SmartDeviceLink/SDLTouchType.h',
'SmartDeviceLink/SDLTriggerSource.h',
'SmartDeviceLink/SDLTTSChunk.h',
'SmartDeviceLink/SDLTurn.h',
'SmartDeviceLink/SDLUnregisterAppInterface.h',
'SmartDeviceLink/SDLUnregisterAppInterfaceResponse.h',
'SmartDeviceLink/SDLUnsubscribeButton.h',
'SmartDeviceLink/SDLUnsubscribeButtonResponse.h',
'SmartDeviceLink/SDLUnsubscribeVehicleData.h',
'SmartDeviceLink/SDLUnsubscribeVehicleDataResponse.h',
'SmartDeviceLink/SDLUnsubscribeWaypoints.h',
'SmartDeviceLink/SDLUnsubscribeWaypointsResponse.h',
'SmartDeviceLink/SDLUpdateMode.h',
'SmartDeviceLink/SDLUpdateTurnList.h',
'SmartDeviceLink/SDLUpdateTurnListResponse.h',
'SmartDeviceLink/SDLVehicleDataActiveStatus.h',
'SmartDeviceLink/SDLVehicleDataEventStatus.h',
'SmartDeviceLink/SDLVehicleDataNotificationStatus.h',
'SmartDeviceLink/SDLVehicleDataResult.h',
'SmartDeviceLink/SDLVehicleDataResultCode.h',
'SmartDeviceLink/SDLVehicleDataStatus.h',
'SmartDeviceLink/SDLVehicleDataType.h',
'SmartDeviceLink/SDLVentilationMode.h',
'SmartDeviceLink/SDLVehicleType.h',
'SmartDeviceLink/SDLVideoStreamingCapability.h',
'SmartDeviceLink/SDLVideoStreamingCodec.h',
'SmartDeviceLink/SDLVideoStreamingFormat.h',
'SmartDeviceLink/SDLVideoStreamingProtocol.h',
'SmartDeviceLink/SDLVoiceCommand.h',
'SmartDeviceLink/SDLVrCapabilities.h',
'SmartDeviceLink/SDLVrHelpItem.h',
'SmartDeviceLink/SDLWarningLightStatus.h',
'SmartDeviceLink/SDLWayPointType.h',
'SmartDeviceLink/SDLWiperStatus.h',
'SmartDeviceLink/SmartDeviceLink.h',
]
end

s.subspec 'Swift' do |ss|
ss.dependency 'SmartDeviceLink/Default'
ss.source_files = 'SmartDeviceLinkSwift/*.swift'
end

end
