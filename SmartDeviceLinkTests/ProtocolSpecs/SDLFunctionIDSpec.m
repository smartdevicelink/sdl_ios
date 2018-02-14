//
//  FunctionIDSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFunctionID.h"
#import "SDLNames.h"

QuickSpecBegin(SDLFunctionIDSpec)

SDLFunctionID* functionID = [SDLFunctionID sharedInstance];

describe(@"GetFunctionName Tests", ^ {
    it(@"Should return the correct function name", ^ {
        expect([functionID functionNameForId:1]).to(equal(SDLNameRegisterAppInterface));
        expect([functionID functionNameForId:2]).to(equal(SDLNameUnregisterAppInterface));
        expect([functionID functionNameForId:3]).to(equal(SDLNameSetGlobalProperties));
        expect([functionID functionNameForId:4]).to(equal(SDLNameResetGlobalProperties));
        expect([functionID functionNameForId:5]).to(equal(SDLNameAddCommand));
        expect([functionID functionNameForId:6]).to(equal(SDLNameDeleteCommand));
        expect([functionID functionNameForId:7]).to(equal(SDLNameAddSubMenu));
        expect([functionID functionNameForId:8]).to(equal(SDLNameDeleteSubMenu));
        expect([functionID functionNameForId:9]).to(equal(SDLNameCreateInteractionChoiceSet));
        expect([functionID functionNameForId:10]).to(equal(SDLNamePerformInteraction));
        expect([functionID functionNameForId:11]).to(equal(SDLNameDeleteInteractionChoiceSet));
        expect([functionID functionNameForId:12]).to(equal(SDLNameAlert));
        expect([functionID functionNameForId:13]).to(equal(SDLNameShow));
        expect([functionID functionNameForId:14]).to(equal(SDLNameSpeak));
        expect([functionID functionNameForId:15]).to(equal(SDLNameSetMediaClockTimer));
        expect([functionID functionNameForId:16]).to(equal(SDLNamePerformAudioPassThru));
        expect([functionID functionNameForId:17]).to(equal(SDLNameEndAudioPassThru));
        expect([functionID functionNameForId:18]).to(equal(SDLNameSubscribeButton));
        expect([functionID functionNameForId:19]).to(equal(SDLNameUnsubscribeButton));
        expect([functionID functionNameForId:20]).to(equal(SDLNameSubscribeVehicleData));
        expect([functionID functionNameForId:21]).to(equal(SDLNameUnsubscribeVehicleData));
        expect([functionID functionNameForId:22]).to(equal(SDLNameGetVehicleData));
        expect([functionID functionNameForId:23]).to(equal(SDLNameReadDID));
        expect([functionID functionNameForId:24]).to(equal(SDLNameGetDTCs));
        expect([functionID functionNameForId:25]).to(equal(SDLNameScrollableMessage));
        expect([functionID functionNameForId:26]).to(equal(SDLNameSlider));
        expect([functionID functionNameForId:27]).to(equal(SDLNameShowConstantTBT));
        expect([functionID functionNameForId:28]).to(equal(SDLNameAlertManeuver));
        expect([functionID functionNameForId:29]).to(equal(SDLNameUpdateTurnList));
        expect([functionID functionNameForId:30]).to(equal(SDLNameChangeRegistration));
        expect([functionID functionNameForId:31]).to(equal(SDLNameGenericResponse));
        expect([functionID functionNameForId:32]).to(equal(SDLNamePutFile));
        expect([functionID functionNameForId:33]).to(equal(SDLNameDeleteFile));
        expect([functionID functionNameForId:34]).to(equal(SDLNameListFiles));
        expect([functionID functionNameForId:35]).to(equal(SDLNameSetAppIcon));
        expect([functionID functionNameForId:36]).to(equal(SDLNameSetDisplayLayout));
        expect([functionID functionNameForId:37]).to(equal(SDLNameDiagnosticMessage));
        expect([functionID functionNameForId:38]).to(equal(SDLNameSystemRequest));
        expect([functionID functionNameForId:39]).to(equal(SDLNameSendLocation));
        expect([functionID functionNameForId:40]).to(equal(SDLNameDialNumber));
        expect([functionID functionNameForId:45]).to(equal(SDLNameGetWayPoints));
        expect([functionID functionNameForId:46]).to(equal(SDLNameSubscribeWayPoints));
        expect([functionID functionNameForId:47]).to(equal(SDLNameUnsubscribeWayPoints));
        expect([functionID functionNameForId:48]).to(equal(SDLNameGetSystemCapability));
        expect([functionID functionNameForId:49]).to(equal(SDLNameSendHapticData));
        expect([functionID functionNameForId:32768]).to(equal(SDLNameOnHMIStatus));
        expect([functionID functionNameForId:32769]).to(equal(SDLNameOnAppInterfaceUnregistered));
        expect([functionID functionNameForId:32770]).to(equal(SDLNameOnButtonEvent));
        expect([functionID functionNameForId:32771]).to(equal(SDLNameOnButtonPress));
        expect([functionID functionNameForId:32772]).to(equal(SDLNameOnVehicleData));
        expect([functionID functionNameForId:32773]).to(equal(SDLNameOnCommand));
        expect([functionID functionNameForId:32774]).to(equal(SDLNameOnTBTClientState));
        expect([functionID functionNameForId:32775]).to(equal(SDLNameOnDriverDistraction));
        expect([functionID functionNameForId:32776]).to(equal(SDLNameOnPermissionsChange));
        expect([functionID functionNameForId:32777]).to(equal(SDLNameOnAudioPassThru));
        expect([functionID functionNameForId:32778]).to(equal(SDLNameOnLanguageChange));
        expect([functionID functionNameForId:32779]).to(equal(SDLNameOnKeyboardInput));
        expect([functionID functionNameForId:32780]).to(equal(SDLNameOnTouchEvent));
        expect([functionID functionNameForId:32781]).to(equal(SDLNameOnSystemRequest));
        expect([functionID functionNameForId:32782]).to(equal(SDLNameOnHashChange));
        expect([functionID functionNameForId:32784]).to(equal(SDLNameOnWayPointChange));
        expect([functionID functionNameForId:32794]).to(equal(SDLNameOnRCStatus));

        //Not listed in Spec
        expect([functionID functionNameForId:65536]).to(equal(SDLNameEncodedSyncPData));
        expect([functionID functionNameForId:65537]).to(equal(SDLNameSyncPData));
        
        expect([functionID functionNameForId:98304]).to(equal(SDLNameOnEncodedSyncPData));
        expect([functionID functionNameForId:98305]).to(equal(SDLNameOnSyncPData));
    });
});

describe(@"GetFunctionID Tests", ^ {
    it(@"Should return the correct function ID", ^ {
        expect([functionID functionIdForName:SDLNameRegisterAppInterface]).to(equal(@1));
        expect([functionID functionIdForName:SDLNameUnregisterAppInterface]).to(equal(@2));
        expect([functionID functionIdForName:SDLNameSetGlobalProperties]).to(equal(@3));
        expect([functionID functionIdForName:SDLNameResetGlobalProperties]).to(equal(@4));
        expect([functionID functionIdForName:SDLNameAddCommand]).to(equal(@5));
        expect([functionID functionIdForName:SDLNameDeleteCommand]).to(equal(@6));
        expect([functionID functionIdForName:SDLNameAddSubMenu]).to(equal(@7));
        expect([functionID functionIdForName:SDLNameDeleteSubMenu]).to(equal(@8));
        expect([functionID functionIdForName:SDLNameCreateInteractionChoiceSet]).to(equal(@9));
        expect([functionID functionIdForName:SDLNamePerformInteraction]).to(equal(@10));
        expect([functionID functionIdForName:SDLNameDeleteInteractionChoiceSet]).to(equal(@11));
        expect([functionID functionIdForName:SDLNameAlert]).to(equal(@12));
        expect([functionID functionIdForName:SDLNameShow]).to(equal(@13));
        expect([functionID functionIdForName:SDLNameSpeak]).to(equal(@14));
        expect([functionID functionIdForName:SDLNameSetMediaClockTimer]).to(equal(@15));
        expect([functionID functionIdForName:SDLNamePerformAudioPassThru]).to(equal(@16));
        expect([functionID functionIdForName:SDLNameEndAudioPassThru]).to(equal(@17));
        expect([functionID functionIdForName:SDLNameSubscribeButton]).to(equal(@18));
        expect([functionID functionIdForName:SDLNameUnsubscribeButton]).to(equal(@19));
        expect([functionID functionIdForName:SDLNameSubscribeVehicleData]).to(equal(@20));
        expect([functionID functionIdForName:SDLNameUnsubscribeVehicleData]).to(equal(@21));
        expect([functionID functionIdForName:SDLNameGetVehicleData]).to(equal(@22));
        expect([functionID functionIdForName:SDLNameReadDID]).to(equal(@23));
        expect([functionID functionIdForName:SDLNameGetDTCs]).to(equal(@24));
        expect([functionID functionIdForName:SDLNameScrollableMessage]).to(equal(@25));
        expect([functionID functionIdForName:SDLNameSlider]).to(equal(@26));
        expect([functionID functionIdForName:SDLNameShowConstantTBT]).to(equal(@27));
        expect([functionID functionIdForName:SDLNameAlertManeuver]).to(equal(@28));
        expect([functionID functionIdForName:SDLNameUpdateTurnList]).to(equal(@29));
        expect([functionID functionIdForName:SDLNameChangeRegistration]).to(equal(@30));
        expect([functionID functionIdForName:SDLNameGenericResponse]).to(equal(@31));
        expect([functionID functionIdForName:SDLNamePutFile]).to(equal(@32));
        expect([functionID functionIdForName:SDLNameDeleteFile]).to(equal(@33));
        expect([functionID functionIdForName:SDLNameListFiles]).to(equal(@34));
        expect([functionID functionIdForName:SDLNameSetAppIcon]).to(equal(@35));
        expect([functionID functionIdForName:SDLNameSetDisplayLayout]).to(equal(@36));
        expect([functionID functionIdForName:SDLNameDiagnosticMessage]).to(equal(@37));
        expect([functionID functionIdForName:SDLNameSystemRequest]).to(equal(@38));
        expect([functionID functionIdForName:SDLNameSendLocation]).to(equal(@39));
        expect([functionID functionIdForName:SDLNameDialNumber]).to(equal(@40));
        expect([functionID functionIdForName:SDLNameGetWayPoints]).to(equal(@45));
        expect([functionID functionIdForName:SDLNameSubscribeWayPoints]).to(equal(@46));
        expect([functionID functionIdForName:SDLNameUnsubscribeWayPoints]).to(equal(@47));
        expect([functionID functionIdForName:SDLNameGetSystemCapability]).to(equal(@48));
        expect([functionID functionIdForName:SDLNameSendHapticData]).to(equal(@49));
        expect([functionID functionIdForName:SDLNameOnHMIStatus]).to(equal(@32768));
        expect([functionID functionIdForName:SDLNameOnAppInterfaceUnregistered]).to(equal(@32769));
        expect([functionID functionIdForName:SDLNameOnButtonEvent]).to(equal(@32770));
        expect([functionID functionIdForName:SDLNameOnButtonPress]).to(equal(@32771));
        expect([functionID functionIdForName:SDLNameOnVehicleData]).to(equal(@32772));
        expect([functionID functionIdForName:SDLNameOnCommand]).to(equal(@32773));
        expect([functionID functionIdForName:SDLNameOnTBTClientState]).to(equal(@32774));
        expect([functionID functionIdForName:SDLNameOnDriverDistraction]).to(equal(@32775));
        expect([functionID functionIdForName:SDLNameOnPermissionsChange]).to(equal(@32776));
        expect([functionID functionIdForName:SDLNameOnAudioPassThru]).to(equal(@32777));
        expect([functionID functionIdForName:SDLNameOnLanguageChange]).to(equal(@32778));
        expect([functionID functionIdForName:SDLNameOnKeyboardInput]).to(equal(@32779));
        expect([functionID functionIdForName:SDLNameOnTouchEvent]).to(equal(@32780));
        expect([functionID functionIdForName:SDLNameOnSystemRequest]).to(equal(@32781));
        expect([functionID functionIdForName:SDLNameOnHashChange]).to(equal(@32782));
        expect([functionID functionIdForName:SDLNameOnWayPointChange]).to(equal(@32784));
        expect([functionID functionIdForName:SDLNameOnRCStatus]).to(equal(@32794));
        
        //Not listed in Spec
        expect([functionID functionIdForName:SDLNameEncodedSyncPData]).to(equal(@65536));
        expect([functionID functionIdForName:SDLNameSyncPData]).to(equal(@65537));
        
        expect([functionID functionIdForName:SDLNameOnEncodedSyncPData]).to(equal(@98304));
        expect([functionID functionIdForName:SDLNameOnSyncPData]).to(equal(@98305));

    });
});

QuickSpecEnd
