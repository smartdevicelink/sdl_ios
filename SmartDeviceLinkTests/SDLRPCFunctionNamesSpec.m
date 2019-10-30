//
//  SDLRPCFunctionNamesSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 3/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLRPCFunctionNamesSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLRPCFunctionNameAddSubMenu).to(equal(@"AddSubMenu"));
        expect(SDLRPCFunctionNameAlert).to(equal(@"Alert"));
        expect(SDLRPCFunctionNameAlertManeuver).to(equal(@"AlertManeuver"));
        expect(SDLRPCFunctionNameButtonPress).to(equal(@"ButtonPress"));
        expect(SDLRPCFunctionNameCancelInteraction).to(equal(@"CancelInteraction"));
        expect(SDLRPCFunctionNameChangeRegistration).to(equal(@"ChangeRegistration"));
        expect(SDLRPCFunctionNameCloseApplication).to(equal(@"CloseApplication"));
        expect(SDLRPCFunctionNameCreateInteractionChoiceSet).to(equal(@"CreateInteractionChoiceSet"));
        expect(SDLRPCFunctionNameDeleteCommand).to(equal(@"DeleteCommand"));
        expect(SDLRPCFunctionNameDeleteFile).to(equal(@"DeleteFile"));
        expect(SDLRPCFunctionNameDeleteInteractionChoiceSet).to(equal(@"DeleteInteractionChoiceSet"));
        expect(SDLRPCFunctionNameDeleteSubMenu).to(equal(@"DeleteSubMenu"));
        expect(SDLRPCFunctionNameDiagnosticMessage).to(equal(@"DiagnosticMessage"));
        expect(SDLRPCFunctionNameDialNumber).to(equal(@"DialNumber"));
        expect(SDLRPCFunctionNameEncodedSyncPData).to(equal(@"EncodedSyncPData"));
        expect(SDLRPCFunctionNameEndAudioPassThru).to(equal(@"EndAudioPassThru"));
        expect(SDLRPCFunctionNameGenericResponse).to(equal(@"GenericResponse"));
        expect(SDLRPCFunctionNameGetAppServiceData).to(equal(@"GetAppServiceData"));
        expect(SDLRPCFunctionNameGetDTCs).to(equal(@"GetDTCs"));
        expect(SDLRPCFunctionNameGetFile).to(equal(@"GetFile"));
        expect(SDLRPCFunctionNameGetInteriorVehicleData).to(equal(@"GetInteriorVehicleData"));
        expect(SDLRPCFunctionNameGetSystemCapability).to(equal(@"GetSystemCapability"));
        expect(SDLRPCFunctionNameGetVehicleData).to(equal(@"GetVehicleData"));
        expect(SDLRPCFunctionNameGetWayPoints).to(equal(@"GetWayPoints"));
        expect(SDLRPCFunctionNameListFiles).to(equal(@"ListFiles"));
        expect(SDLRPCFunctionNameOnAppInterfaceUnregistered).to(equal(@"OnAppInterfaceUnregistered"));
        expect(SDLRPCFunctionNameOnAppServiceData).to(equal(@"OnAppServiceData"));
        expect(SDLRPCFunctionNameOnAudioPassThru).to(equal(@"OnAudioPassThru"));
        expect(SDLRPCFunctionNameOnButtonEvent).to(equal(@"OnButtonEvent"));
        expect(SDLRPCFunctionNameOnButtonPress).to(equal(@"OnButtonPress"));
        expect(SDLRPCFunctionNameOnCommand).to(equal(@"OnCommand"));
        expect(SDLRPCFunctionNameOnDriverDistraction).to(equal(@"OnDriverDistraction"));
        expect(SDLRPCFunctionNameOnEncodedSyncPData).to(equal(@"OnEncodedSyncPData"));
        expect(SDLRPCFunctionNameOnHashChange).to(equal(@"OnHashChange"));
        expect(SDLRPCFunctionNameOnHMIStatus).to(equal(@"OnHMIStatus"));
        expect(SDLRPCFunctionNameOnInteriorVehicleData).to(equal(@"OnInteriorVehicleData"));
        expect(SDLRPCFunctionNameOnKeyboardInput).to(equal(@"OnKeyboardInput"));
        expect(SDLRPCFunctionNameOnLanguageChange).to(equal(@"OnLanguageChange"));
        expect(SDLRPCFunctionNameOnPermissionsChange).to(equal(@"OnPermissionsChange"));
        expect(SDLRPCFunctionNameOnRCStatus).to(equal(@"OnRCStatus"));
        expect(SDLRPCFunctionNameOnSyncPData).to(equal(@"OnSyncPData"));
        expect(SDLRPCFunctionNameOnSystemCapabilityUpdated).to(equal(@"OnSystemCapabilityUpdated"));
        expect(SDLRPCFunctionNameOnSystemRequest).to(equal(@"OnSystemRequest"));
        expect(SDLRPCFunctionNameOnTBTClientState).to(equal(@"OnTBTClientState"));
        expect(SDLRPCFunctionNameOnTouchEvent).to(equal(@"OnTouchEvent"));
        expect(SDLRPCFunctionNameOnVehicleData).to(equal(@"OnVehicleData"));
        expect(SDLRPCFunctionNameOnWayPointChange).to(equal(@"OnWayPointChange"));
        expect(SDLRPCFunctionNamePerformAppServiceInteraction).to(equal(@"PerformAppServiceInteraction"));
        expect(SDLRPCFunctionNamePerformAudioPassThru).to(equal(@"PerformAudioPassThru"));
        expect(SDLRPCFunctionNamePerformInteraction).to(equal(@"PerformInteraction"));
        expect(SDLRPCFunctionNamePublishAppService).to(equal(@"PublishAppService"));
        expect(SDLRPCFunctionNamePutFile).to(equal(@"PutFile"));
        expect(SDLRPCFunctionNameReadDID).to(equal(@"ReadDID"));
        expect(SDLRPCFunctionNameRegisterAppInterface).to(equal(@"RegisterAppInterface"));
        expect(SDLRPCFunctionNameReserved).to(equal(@"reserved"));
        expect(SDLRPCFunctionNameResetGlobalProperties).to(equal(@"ResetGlobalProperties"));
        expect(SDLRPCFunctionNameScrollableMessage).to(equal(@"ScrollableMessage"));
        expect(SDLRPCFunctionNameSendHapticData).to(equal(@"SendHapticData"));
        expect(SDLRPCFunctionNameSendLocation).to(equal(@"SendLocation"));
        expect(SDLRPCFunctionNameSetAppIcon).to(equal(@"SetAppIcon"));
        expect(SDLRPCFunctionNameSetDisplayLayout).to(equal(@"SetDisplayLayout"));
        expect(SDLRPCFunctionNameSetGlobalProperties).to(equal(@"SetGlobalProperties"));
        expect(SDLRPCFunctionNameSetInteriorVehicleData).to(equal(@"SetInteriorVehicleData"));
        expect(SDLRPCFunctionNameSetMediaClockTimer).to(equal(@"SetMediaClockTimer"));
        expect(SDLRPCFunctionNameShow).to(equal(@"Show"));
        expect(SDLRPCFunctionNameShowConstantTBT).to(equal(@"ShowConstantTBT"));
        expect(SDLRPCFunctionNameSlider).to(equal(@"Slider"));
        expect(SDLRPCFunctionNameSpeak).to(equal(@"Speak"));
        expect(SDLRPCFunctionNameSubscribeButton).to(equal(@"SubscribeButton"));
        expect(SDLRPCFunctionNameSubscribeVehicleData).to(equal(@"SubscribeVehicleData"));
        expect(SDLRPCFunctionNameSubscribeWayPoints).to(equal(@"SubscribeWayPoints"));
        expect(SDLRPCFunctionNameSyncPData).to(equal(@"SyncPData"));
        expect(SDLRPCFunctionNameSystemRequest).to(equal(@"SystemRequest"));
        expect(SDLRPCFunctionNameUnpublishAppService).to(equal(@"UnpublishAppService"));
        expect(SDLRPCFunctionNameUnregisterAppInterface).to(equal(@"UnregisterAppInterface"));
        expect(SDLRPCFunctionNameUnsubscribeButton).to(equal(@"UnsubscribeButton"));
        expect(SDLRPCFunctionNameUnsubscribeVehicleData).to(equal(@"UnsubscribeVehicleData"));
        expect(SDLRPCFunctionNameUnsubscribeWayPoints).to(equal(@"UnsubscribeWayPoints"));
        expect(SDLRPCFunctionNameUpdateTurnList).to(equal(@"UpdateTurnList"));
    });
});

QuickSpecEnd
