//
//  SDLRPCFunctionNames.h
//  SmartDeviceLink
//
//  Created by Nicole on 3/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  All RPC request / response / notification names
 */
typedef SDLEnum SDLRPCFunctionName SDL_SWIFT_ENUM;

/// Function name for an AddCommand RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameAddCommand;

/// Function name for an AddSubMenu RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameAddSubMenu;

/// Function name for an Alert RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameAlert;

/// Function name for an AlertManeuver RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameAlertManeuver;

/// Function name for a ButtonPress RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameButtonPress;

/// Function name for a CancelInteraction RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameCancelInteraction;

/// Function name for a ChangeRegistration RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameChangeRegistration;

/// Function name for a CloseApplication RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameCloseApplication;

/// Function name for a CreateInteractionChoiceSet RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameCreateInteractionChoiceSet;

/// Function name for a DeleteCommand RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameDeleteCommand;

/// Function name for a DeleteFile RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameDeleteFile;

/// Function name for a DeleteInteractionChoiceSet RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameDeleteInteractionChoiceSet;

/// Function name for a DeleteSubMenu RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameDeleteSubMenu;

/// Function name for a DiagnosticMessage RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameDiagnosticMessage;

/// Function name for a DialNumber RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameDialNumber;

/// Function name for an CreateInteractionChoiceSet RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameEncodedSyncPData __deprecated;

/// Function name for an EndAudioPassThru RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameEndAudioPassThru;

/// Function name for an GenricResponse Response RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGenericResponse;

/// Function name for an CreateInteractionChoiceSet RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetAppServiceData;

/// Function name for a GetDTCs RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetDTCs;

/// Function name for a GetFile RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetFile;

/// Function name for a GetCloudAppProperties RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetCloudAppProperties;

/// Function name for a GetInteriorVehicleData RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetInteriorVehicleData;

/// Function name for a GetInteriorVehicleDataConsent RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetInteriorVehicleDataConsent;

/// Function name for a GetSystemCapability RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetSystemCapability;

/// Function name for a GetVehicleData RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetVehicleData;

/// Function name for a GetWayPoints RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameGetWayPoints;

/// Function name for a ListFiles RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameListFiles;

/// Function name for an OnAppCapabilityUpdated notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnAppCapabilityUpdated;

/// Function name for an OnAppInterfaceUnregistered notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnAppInterfaceUnregistered;

/// Function name for an OnAppServiceData notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnAppServiceData;

/// Function name for an OnAudioPassThru notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnAudioPassThru;

/// Function name for an OnButtonEvent notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnButtonEvent;

/// Function name for an OnButtonPress notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnButtonPress;

/// Function name for an OnCommand notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnCommand;

/// Function name for an OnDriverDistraction notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnDriverDistraction;

/// Function name for an OnEncodedSyncPData notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnEncodedSyncPData __deprecated;

/// Function name for an OnHashChange notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnHashChange;

/// Function name for an OnHMIStatus notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnHMIStatus;

/// Function name for an OnInteriorVehicleData notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnInteriorVehicleData;

/// Function name for an OnKeyboardInput notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnKeyboardInput;

/// Function name for an OnLanguageChange notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnLanguageChange;

/// Function name for an OnLockScreenStatus notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnLockScreenStatus;

/// Function name for an OnPermissionsChange notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnPermissionsChange;

/// Function name for an OnRCStatus notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnRCStatus;

/// Function name for an OnSyncPData notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnSyncPData __deprecated;

/// Function name for an OnSystemCapabilityUpdated notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnSystemCapabilityUpdated;

/// Function name for an OnSystemRequest notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnSystemRequest;

/// Function name for an OnTBTClientState notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnTBTClientState;

/// Function name for an OnTouchEvent notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnTouchEvent;

/// Function name for an OnVehicleData notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnVehicleData;

/// Function name for an OnWayPointChange notification RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameOnWayPointChange;

/// Function name for a PerformAppServiceInteraction RPC
extern SDLRPCFunctionName const SDLRPCFunctionNamePerformAppServiceInteraction;

/// Function name for a PerformAppServiceInteraction RPC
extern SDLRPCFunctionName const SDLRPCFunctionNamePerformAudioPassThru;

/// Function name for a PerformInteraction RPC
extern SDLRPCFunctionName const SDLRPCFunctionNamePerformInteraction;

/// Function name for a PublishAppService RPC
extern SDLRPCFunctionName const SDLRPCFunctionNamePublishAppService;

/// Function name for a PutFile RPC
extern SDLRPCFunctionName const SDLRPCFunctionNamePutFile;

/// Function name for a ReadDID RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameReadDID;

/// Function name for a ReleaseInteriorVehicleDataModule RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameReleaseInteriorVehicleDataModule;

/// Function name for a RegisterAppInterface RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameRegisterAppInterface;

/// Function name for a Reserved RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameReserved;

/// Function name for a ResetGlobalProperties RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameResetGlobalProperties;

/// Function name for a ScrollableMessage RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameScrollableMessage;

/// Function name for a SendHapticData RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSendHapticData;

/// Function name for a SendLocation RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSendLocation;

/// Function name for a SetAppIcon RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSetAppIcon;

/// Function name for a SetCloudProperties RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSetCloudAppProperties;

/// Function name for a SetDisplayLayout RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSetDisplayLayout;

/// Function name for a SetGlobalProperties RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSetGlobalProperties;

/// Function name for a SetInteriorVehicleData RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSetInteriorVehicleData;

/// Function name for a SetMediaClockTimer RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSetMediaClockTimer;

/// Function name for a Show RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameShow;

/// Function name for a ShowAppMenu RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameShowAppMenu;

/// Function name for a ShowConstantTBT RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameShowConstantTBT;

/// Function name for a Slider RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSlider;

/// Function name for a Speak RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSpeak;

/// Function name for a SubscribeButton RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSubscribeButton;

/// Function name for a SubscribeVehicleData RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSubscribeVehicleData;

/// Function name for a SubscribeWayPoints RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSubscribeWayPoints;

/// Function name for a SyncPData RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSyncPData __deprecated;

/// Function name for a SystemRequest RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameSystemRequest;

/// Function name for an UnpublishAppService RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameUnpublishAppService;

/// Function name for an UnregisterAppInterface RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameUnregisterAppInterface;

/// Function name for an UnsubscribeButton RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameUnsubscribeButton;

/// Function name for an UnsubscribeVehicleData RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameUnsubscribeVehicleData;

/// Function name for an UnsubscribeWayPoints RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameUnsubscribeWayPoints;

/// Function name for an UpdateTurnList RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameUpdateTurnList;

/// Function name for a CreateWindow RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameCreateWindow;

/// Function name for a DeleteWindow RPC
extern SDLRPCFunctionName const SDLRPCFunctionNameDeleteWindow;


