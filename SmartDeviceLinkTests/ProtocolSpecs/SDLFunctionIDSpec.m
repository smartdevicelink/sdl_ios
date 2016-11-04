//
//  FunctionIDSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFunctionID.h"
#import "SDLNames.h"

QuickSpecBegin(SDLFunctionIDSpec)

SDLFunctionID* functionID = [[SDLFunctionID alloc] init];

describe(@"GetFunctionName Tests", ^ {
    it(@"Should return the correct function name", ^ {
        expect([functionID getFunctionName:1]).to(equal(NAMES_RegisterAppInterface));
        expect([functionID getFunctionName:2]).to(equal(NAMES_UnregisterAppInterface));
        expect([functionID getFunctionName:3]).to(equal(NAMES_SetGlobalProperties));
        expect([functionID getFunctionName:4]).to(equal(NAMES_ResetGlobalProperties));
        expect([functionID getFunctionName:5]).to(equal(NAMES_AddCommand));
        expect([functionID getFunctionName:6]).to(equal(NAMES_DeleteCommand));
        expect([functionID getFunctionName:7]).to(equal(NAMES_AddSubMenu));
        expect([functionID getFunctionName:8]).to(equal(NAMES_DeleteSubMenu));
        expect([functionID getFunctionName:9]).to(equal(NAMES_CreateInteractionChoiceSet));
        expect([functionID getFunctionName:10]).to(equal(NAMES_PerformInteraction));
        expect([functionID getFunctionName:11]).to(equal(NAMES_DeleteInteractionChoiceSet));
        expect([functionID getFunctionName:12]).to(equal(NAMES_Alert));
        expect([functionID getFunctionName:13]).to(equal(NAMES_Show));
        expect([functionID getFunctionName:14]).to(equal(NAMES_Speak));
        expect([functionID getFunctionName:15]).to(equal(NAMES_SetMediaClockTimer));
        expect([functionID getFunctionName:16]).to(equal(NAMES_PerformAudioPassThru));
        expect([functionID getFunctionName:17]).to(equal(NAMES_EndAudioPassThru));
        expect([functionID getFunctionName:18]).to(equal(NAMES_SubscribeButton));
        expect([functionID getFunctionName:19]).to(equal(NAMES_UnsubscribeButton));
        expect([functionID getFunctionName:20]).to(equal(NAMES_SubscribeVehicleData));
        expect([functionID getFunctionName:21]).to(equal(NAMES_UnsubscribeVehicleData));
        expect([functionID getFunctionName:22]).to(equal(NAMES_GetVehicleData));
        expect([functionID getFunctionName:23]).to(equal(NAMES_ReadDID));
        expect([functionID getFunctionName:24]).to(equal(NAMES_GetDTCs));
        expect([functionID getFunctionName:25]).to(equal(NAMES_ScrollableMessage));
        expect([functionID getFunctionName:26]).to(equal(NAMES_Slider));
        expect([functionID getFunctionName:27]).to(equal(NAMES_ShowConstantTBT));
        expect([functionID getFunctionName:28]).to(equal(NAMES_AlertManeuver));
        expect([functionID getFunctionName:29]).to(equal(NAMES_UpdateTurnList));
        expect([functionID getFunctionName:30]).to(equal(NAMES_ChangeRegistration));
        expect([functionID getFunctionName:31]).to(equal(NAMES_GenericResponse));
        expect([functionID getFunctionName:32]).to(equal(NAMES_PutFile));
        expect([functionID getFunctionName:33]).to(equal(NAMES_DeleteFile));
        expect([functionID getFunctionName:34]).to(equal(NAMES_ListFiles));
        expect([functionID getFunctionName:35]).to(equal(NAMES_SetAppIcon));
        expect([functionID getFunctionName:36]).to(equal(NAMES_SetDisplayLayout));
        expect([functionID getFunctionName:37]).to(equal(NAMES_DiagnosticMessage));
        expect([functionID getFunctionName:38]).to(equal(NAMES_SystemRequest));
        expect([functionID getFunctionName:39]).to(equal(NAMES_SendLocation));
        expect([functionID getFunctionName:40]).to(equal(NAMES_DialNumber));
        expect([functionID getFunctionName:45]).to(equal(NAMES_GetWaypoints));
        expect([functionID getFunctionName:46]).to(equal(NAMES_SubscribeWaypoints));
        expect([functionID getFunctionName:47]).to(equal(NAMES_UnsubscribeWaypoints));
        expect([functionID getFunctionName:32768]).to(equal(NAMES_OnHMIStatus));
        expect([functionID getFunctionName:32769]).to(equal(NAMES_OnAppInterfaceUnregistered));
        expect([functionID getFunctionName:32770]).to(equal(NAMES_OnButtonEvent));
        expect([functionID getFunctionName:32771]).to(equal(NAMES_OnButtonPress));
        expect([functionID getFunctionName:32772]).to(equal(NAMES_OnVehicleData));
        expect([functionID getFunctionName:32773]).to(equal(NAMES_OnCommand));
        expect([functionID getFunctionName:32774]).to(equal(NAMES_OnTBTClientState));
        expect([functionID getFunctionName:32775]).to(equal(NAMES_OnDriverDistraction));
        expect([functionID getFunctionName:32776]).to(equal(NAMES_OnPermissionsChange));
        expect([functionID getFunctionName:32777]).to(equal(NAMES_OnAudioPassThru));
        expect([functionID getFunctionName:32778]).to(equal(NAMES_OnLanguageChange));
        expect([functionID getFunctionName:32779]).to(equal(NAMES_OnKeyboardInput));
        expect([functionID getFunctionName:32780]).to(equal(NAMES_OnTouchEvent));
        expect([functionID getFunctionName:32781]).to(equal(NAMES_OnSystemRequest));
        expect([functionID getFunctionName:32782]).to(equal(NAMES_OnHashChange));
        expect([functionID getFunctionName:32784]).to(equal(NAMES_OnWaypointChange));
        
        //Not listed in Spec
        expect([functionID getFunctionName:65536]).to(equal(NAMES_EncodedSyncPData));
        expect([functionID getFunctionName:65537]).to(equal(NAMES_SyncPData));
        
        expect([functionID getFunctionName:98304]).to(equal(NAMES_OnEncodedSyncPData));
        expect([functionID getFunctionName:98305]).to(equal(NAMES_OnSyncPData));
    });
});

describe(@"GetFunctionID Tests", ^ {
    it(@"Should return the correct function ID", ^ {
        expect([functionID getFunctionID:NAMES_RegisterAppInterface]).to(equal(@1));
        expect([functionID getFunctionID:NAMES_UnregisterAppInterface]).to(equal(@2));
        expect([functionID getFunctionID:NAMES_SetGlobalProperties]).to(equal(@3));
        expect([functionID getFunctionID:NAMES_ResetGlobalProperties]).to(equal(@4));
        expect([functionID getFunctionID:NAMES_AddCommand]).to(equal(@5));
        expect([functionID getFunctionID:NAMES_DeleteCommand]).to(equal(@6));
        expect([functionID getFunctionID:NAMES_AddSubMenu]).to(equal(@7));
        expect([functionID getFunctionID:NAMES_DeleteSubMenu]).to(equal(@8));
        expect([functionID getFunctionID:NAMES_CreateInteractionChoiceSet]).to(equal(@9));
        expect([functionID getFunctionID:NAMES_PerformInteraction]).to(equal(@10));
        expect([functionID getFunctionID:NAMES_DeleteInteractionChoiceSet]).to(equal(@11));
        expect([functionID getFunctionID:NAMES_Alert]).to(equal(@12));
        expect([functionID getFunctionID:NAMES_Show]).to(equal(@13));
        expect([functionID getFunctionID:NAMES_Speak]).to(equal(@14));
        expect([functionID getFunctionID:NAMES_SetMediaClockTimer]).to(equal(@15));
        expect([functionID getFunctionID:NAMES_PerformAudioPassThru]).to(equal(@16));
        expect([functionID getFunctionID:NAMES_EndAudioPassThru]).to(equal(@17));
        expect([functionID getFunctionID:NAMES_SubscribeButton]).to(equal(@18));
        expect([functionID getFunctionID:NAMES_UnsubscribeButton]).to(equal(@19));
        expect([functionID getFunctionID:NAMES_SubscribeVehicleData]).to(equal(@20));
        expect([functionID getFunctionID:NAMES_UnsubscribeVehicleData]).to(equal(@21));
        expect([functionID getFunctionID:NAMES_GetVehicleData]).to(equal(@22));
        expect([functionID getFunctionID:NAMES_ReadDID]).to(equal(@23));
        expect([functionID getFunctionID:NAMES_GetDTCs]).to(equal(@24));
        expect([functionID getFunctionID:NAMES_ScrollableMessage]).to(equal(@25));
        expect([functionID getFunctionID:NAMES_Slider]).to(equal(@26));
        expect([functionID getFunctionID:NAMES_ShowConstantTBT]).to(equal(@27));
        expect([functionID getFunctionID:NAMES_AlertManeuver]).to(equal(@28));
        expect([functionID getFunctionID:NAMES_UpdateTurnList]).to(equal(@29));
        expect([functionID getFunctionID:NAMES_ChangeRegistration]).to(equal(@30));
        expect([functionID getFunctionID:NAMES_GenericResponse]).to(equal(@31));
        expect([functionID getFunctionID:NAMES_PutFile]).to(equal(@32));
        expect([functionID getFunctionID:NAMES_DeleteFile]).to(equal(@33));
        expect([functionID getFunctionID:NAMES_ListFiles]).to(equal(@34));
        expect([functionID getFunctionID:NAMES_SetAppIcon]).to(equal(@35));
        expect([functionID getFunctionID:NAMES_SetDisplayLayout]).to(equal(@36));
        expect([functionID getFunctionID:NAMES_DiagnosticMessage]).to(equal(@37));
        expect([functionID getFunctionID:NAMES_SystemRequest]).to(equal(@38));
        expect([functionID getFunctionID:NAMES_SendLocation]).to(equal(@39));
        expect([functionID getFunctionID:NAMES_DialNumber]).to(equal(@40));
        expect([functionID getFunctionID:NAMES_GetWaypoints]).to(equal(@45));
        expect([functionID getFunctionID:NAMES_SubscribeWaypoints]).to(equal(@46));
        expect([functionID getFunctionID:NAMES_UnsubscribeWaypoints]).to(equal(@47));

        expect([functionID getFunctionID:NAMES_OnHMIStatus]).to(equal(@32768));
        expect([functionID getFunctionID:NAMES_OnAppInterfaceUnregistered]).to(equal(@32769));
        expect([functionID getFunctionID:NAMES_OnButtonEvent]).to(equal(@32770));
        expect([functionID getFunctionID:NAMES_OnButtonPress]).to(equal(@32771));
        expect([functionID getFunctionID:NAMES_OnVehicleData]).to(equal(@32772));
        expect([functionID getFunctionID:NAMES_OnCommand]).to(equal(@32773));
        expect([functionID getFunctionID:NAMES_OnTBTClientState]).to(equal(@32774));
        expect([functionID getFunctionID:NAMES_OnDriverDistraction]).to(equal(@32775));
        expect([functionID getFunctionID:NAMES_OnPermissionsChange]).to(equal(@32776));
        expect([functionID getFunctionID:NAMES_OnAudioPassThru]).to(equal(@32777));
        expect([functionID getFunctionID:NAMES_OnLanguageChange]).to(equal(@32778));
        expect([functionID getFunctionID:NAMES_OnKeyboardInput]).to(equal(@32779));
        expect([functionID getFunctionID:NAMES_OnTouchEvent]).to(equal(@32780));
        expect([functionID getFunctionID:NAMES_OnSystemRequest]).to(equal(@32781));
        expect([functionID getFunctionID:NAMES_OnHashChange]).to(equal(@32782));
        expect([functionID getFunctionID:NAMES_OnWaypointChange]).to(equal(@32784));
        
        //Not listed in Spec
        expect([functionID getFunctionID:NAMES_EncodedSyncPData]).to(equal(@65536));
        expect([functionID getFunctionID:NAMES_SyncPData]).to(equal(@65537));
        
        expect([functionID getFunctionID:NAMES_OnEncodedSyncPData]).to(equal(@98304));
        expect([functionID getFunctionID:NAMES_OnSyncPData]).to(equal(@98305));
    });
});

QuickSpecEnd
