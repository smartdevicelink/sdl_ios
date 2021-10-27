//
//  FunctionIDSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFunctionID.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLFunctionIDSpec)

SDLFunctionID* functionID = [SDLFunctionID sharedInstance];

describe(@"GetFunctionName Tests", ^ {
    it(@"Should return the correct function name", ^ {
        expect([functionID functionNameForId:1]).to(equal(SDLRPCFunctionNameRegisterAppInterface));
        expect([functionID functionNameForId:2]).to(equal(SDLRPCFunctionNameUnregisterAppInterface));
        expect([functionID functionNameForId:3]).to(equal(SDLRPCFunctionNameSetGlobalProperties));
        expect([functionID functionNameForId:4]).to(equal(SDLRPCFunctionNameResetGlobalProperties));
        expect([functionID functionNameForId:5]).to(equal(SDLRPCFunctionNameAddCommand));
        expect([functionID functionNameForId:6]).to(equal(SDLRPCFunctionNameDeleteCommand));
        expect([functionID functionNameForId:7]).to(equal(SDLRPCFunctionNameAddSubMenu));
        expect([functionID functionNameForId:8]).to(equal(SDLRPCFunctionNameDeleteSubMenu));
        expect([functionID functionNameForId:9]).to(equal(SDLRPCFunctionNameCreateInteractionChoiceSet));
        expect([functionID functionNameForId:10]).to(equal(SDLRPCFunctionNamePerformInteraction));
        expect([functionID functionNameForId:11]).to(equal(SDLRPCFunctionNameDeleteInteractionChoiceSet));
        expect([functionID functionNameForId:12]).to(equal(SDLRPCFunctionNameAlert));
        expect([functionID functionNameForId:13]).to(equal(SDLRPCFunctionNameShow));
        expect([functionID functionNameForId:14]).to(equal(SDLRPCFunctionNameSpeak));
        expect([functionID functionNameForId:15]).to(equal(SDLRPCFunctionNameSetMediaClockTimer));
        expect([functionID functionNameForId:16]).to(equal(SDLRPCFunctionNamePerformAudioPassThru));
        expect([functionID functionNameForId:17]).to(equal(SDLRPCFunctionNameEndAudioPassThru));
        expect([functionID functionNameForId:18]).to(equal(SDLRPCFunctionNameSubscribeButton));
        expect([functionID functionNameForId:19]).to(equal(SDLRPCFunctionNameUnsubscribeButton));
        expect([functionID functionNameForId:20]).to(equal(SDLRPCFunctionNameSubscribeVehicleData));
        expect([functionID functionNameForId:21]).to(equal(SDLRPCFunctionNameUnsubscribeVehicleData));
        expect([functionID functionNameForId:22]).to(equal(SDLRPCFunctionNameGetVehicleData));
        expect([functionID functionNameForId:23]).to(equal(SDLRPCFunctionNameReadDID));
        expect([functionID functionNameForId:24]).to(equal(SDLRPCFunctionNameGetDTCs));
        expect([functionID functionNameForId:25]).to(equal(SDLRPCFunctionNameScrollableMessage));
        expect([functionID functionNameForId:26]).to(equal(SDLRPCFunctionNameSlider));
        expect([functionID functionNameForId:27]).to(equal(SDLRPCFunctionNameShowConstantTBT));
        expect([functionID functionNameForId:28]).to(equal(SDLRPCFunctionNameAlertManeuver));
        expect([functionID functionNameForId:29]).to(equal(SDLRPCFunctionNameUpdateTurnList));
        expect([functionID functionNameForId:30]).to(equal(SDLRPCFunctionNameChangeRegistration));
        expect([functionID functionNameForId:31]).to(equal(SDLRPCFunctionNameGenericResponse));
        expect([functionID functionNameForId:32]).to(equal(SDLRPCFunctionNamePutFile));
        expect([functionID functionNameForId:33]).to(equal(SDLRPCFunctionNameDeleteFile));
        expect([functionID functionNameForId:34]).to(equal(SDLRPCFunctionNameListFiles));
        expect([functionID functionNameForId:35]).to(equal(SDLRPCFunctionNameSetAppIcon));
        expect([functionID functionNameForId:36]).to(equal(SDLRPCFunctionNameSetDisplayLayout));
        expect([functionID functionNameForId:37]).to(equal(SDLRPCFunctionNameDiagnosticMessage));
        expect([functionID functionNameForId:38]).to(equal(SDLRPCFunctionNameSystemRequest));
        expect([functionID functionNameForId:39]).to(equal(SDLRPCFunctionNameSendLocation));
        expect([functionID functionNameForId:40]).to(equal(SDLRPCFunctionNameDialNumber));
        expect([functionID functionNameForId:45]).to(equal(SDLRPCFunctionNameGetWayPoints));
        expect([functionID functionNameForId:46]).to(equal(SDLRPCFunctionNameSubscribeWayPoints));
        expect([functionID functionNameForId:47]).to(equal(SDLRPCFunctionNameUnsubscribeWayPoints));
        expect([functionID functionNameForId:48]).to(equal(SDLRPCFunctionNameGetSystemCapability));
        expect([functionID functionNameForId:49]).to(equal(SDLRPCFunctionNameSendHapticData));
        expect([functionID functionNameForId:50]).to(equal(SDLRPCFunctionNameSetCloudAppProperties));
        expect([functionID functionNameForId:51]).to(equal(SDLRPCFunctionNameGetCloudAppProperties));
        expect([functionID functionNameForId:52]).to(equal(SDLRPCFunctionNamePublishAppService));
        expect([functionID functionNameForId:53]).to(equal(SDLRPCFunctionNameGetAppServiceData));
        expect([functionID functionNameForId:54]).to(equal(SDLRPCFunctionNameGetFile));
        expect([functionID functionNameForId:55]).to(equal(SDLRPCFunctionNamePerformAppServiceInteraction));
        expect([functionID functionNameForId:60]).to(equal(SDLRPCFunctionNameCreateWindow));
        expect([functionID functionNameForId:61]).to(equal(SDLRPCFunctionNameDeleteWindow));
        expect([functionID functionNameForId:65]).to(equal(SDLRPCFunctionNameDefault));
        expect([functionID functionNameForId:66]).to(equal(SDLRPCFunctionNamePerformChoiceSet));
        expect([functionID functionNameForId:67]).to(equal(SDLRPCFunctionNameScreenUpdate));
        expect([functionID functionNameForId:68]).to(equal(SDLRPCFunctionNameAccessMicrophone));
        expect([functionID functionNameForId:69]).to(equal(SDLRPCFunctionNameOpenMenu));
        expect([functionID functionNameForId:32768]).to(equal(SDLRPCFunctionNameOnHMIStatus));
        expect([functionID functionNameForId:32769]).to(equal(SDLRPCFunctionNameOnAppInterfaceUnregistered));
        expect([functionID functionNameForId:32770]).to(equal(SDLRPCFunctionNameOnButtonEvent));
        expect([functionID functionNameForId:32771]).to(equal(SDLRPCFunctionNameOnButtonPress));
        expect([functionID functionNameForId:32772]).to(equal(SDLRPCFunctionNameOnVehicleData));
        expect([functionID functionNameForId:32773]).to(equal(SDLRPCFunctionNameOnCommand));
        expect([functionID functionNameForId:32774]).to(equal(SDLRPCFunctionNameOnTBTClientState));
        expect([functionID functionNameForId:32775]).to(equal(SDLRPCFunctionNameOnDriverDistraction));
        expect([functionID functionNameForId:32776]).to(equal(SDLRPCFunctionNameOnPermissionsChange));
        expect([functionID functionNameForId:32777]).to(equal(SDLRPCFunctionNameOnAudioPassThru));
        expect([functionID functionNameForId:32778]).to(equal(SDLRPCFunctionNameOnLanguageChange));
        expect([functionID functionNameForId:32779]).to(equal(SDLRPCFunctionNameOnKeyboardInput));
        expect([functionID functionNameForId:32780]).to(equal(SDLRPCFunctionNameOnTouchEvent));
        expect([functionID functionNameForId:32781]).to(equal(SDLRPCFunctionNameOnSystemRequest));
        expect([functionID functionNameForId:32782]).to(equal(SDLRPCFunctionNameOnHashChange));
        expect([functionID functionNameForId:32784]).to(equal(SDLRPCFunctionNameOnWayPointChange));
        expect([functionID functionNameForId:32785]).to(equal(SDLRPCFunctionNameOnRCStatus));
        expect([functionID functionNameForId:32786]).to(equal(SDLRPCFunctionNameOnAppServiceData));
        expect([functionID functionNameForId:32787]).to(equal(SDLRPCFunctionNameOnSystemCapabilityUpdated));
        expect([functionID functionNameForId:32789]).to(equal(SDLRPCFunctionNameOnUpdateFile));
        expect([functionID functionNameForId:32790]).to(equal(SDLRPCFunctionNameOnUpdateSubMenu));
        expect([functionID functionNameForId:32791]).to(equal(SDLRPCFunctionNameOnAppCapabilityUpdated));

        //Not listed in Spec
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect([functionID functionNameForId:65536]).to(equal(SDLRPCFunctionNameEncodedSyncPData));
        expect([functionID functionNameForId:65537]).to(equal(SDLRPCFunctionNameSyncPData));
        
        expect([functionID functionNameForId:98304]).to(equal(SDLRPCFunctionNameOnEncodedSyncPData));
        expect([functionID functionNameForId:98305]).to(equal(SDLRPCFunctionNameOnSyncPData));
#pragma clang diagnostic pop
    });
});

describe(@"GetFunctionID Tests", ^ {
    it(@"Should return the correct function ID", ^ {
        expect([functionID functionIdForName:SDLRPCFunctionNameRegisterAppInterface]).to(equal(@1));
        expect([functionID functionIdForName:SDLRPCFunctionNameUnregisterAppInterface]).to(equal(@2));
        expect([functionID functionIdForName:SDLRPCFunctionNameSetGlobalProperties]).to(equal(@3));
        expect([functionID functionIdForName:SDLRPCFunctionNameResetGlobalProperties]).to(equal(@4));
        expect([functionID functionIdForName:SDLRPCFunctionNameAddCommand]).to(equal(@5));
        expect([functionID functionIdForName:SDLRPCFunctionNameDeleteCommand]).to(equal(@6));
        expect([functionID functionIdForName:SDLRPCFunctionNameAddSubMenu]).to(equal(@7));
        expect([functionID functionIdForName:SDLRPCFunctionNameDeleteSubMenu]).to(equal(@8));
        expect([functionID functionIdForName:SDLRPCFunctionNameCreateInteractionChoiceSet]).to(equal(@9));
        expect([functionID functionIdForName:SDLRPCFunctionNamePerformInteraction]).to(equal(@10));
        expect([functionID functionIdForName:SDLRPCFunctionNameDeleteInteractionChoiceSet]).to(equal(@11));
        expect([functionID functionIdForName:SDLRPCFunctionNameAlert]).to(equal(@12));
        expect([functionID functionIdForName:SDLRPCFunctionNameShow]).to(equal(@13));
        expect([functionID functionIdForName:SDLRPCFunctionNameSpeak]).to(equal(@14));
        expect([functionID functionIdForName:SDLRPCFunctionNameSetMediaClockTimer]).to(equal(@15));
        expect([functionID functionIdForName:SDLRPCFunctionNamePerformAudioPassThru]).to(equal(@16));
        expect([functionID functionIdForName:SDLRPCFunctionNameEndAudioPassThru]).to(equal(@17));
        expect([functionID functionIdForName:SDLRPCFunctionNameSubscribeButton]).to(equal(@18));
        expect([functionID functionIdForName:SDLRPCFunctionNameUnsubscribeButton]).to(equal(@19));
        expect([functionID functionIdForName:SDLRPCFunctionNameSubscribeVehicleData]).to(equal(@20));
        expect([functionID functionIdForName:SDLRPCFunctionNameUnsubscribeVehicleData]).to(equal(@21));
        expect([functionID functionIdForName:SDLRPCFunctionNameGetVehicleData]).to(equal(@22));
        expect([functionID functionIdForName:SDLRPCFunctionNameReadDID]).to(equal(@23));
        expect([functionID functionIdForName:SDLRPCFunctionNameGetDTCs]).to(equal(@24));
        expect([functionID functionIdForName:SDLRPCFunctionNameScrollableMessage]).to(equal(@25));
        expect([functionID functionIdForName:SDLRPCFunctionNameSlider]).to(equal(@26));
        expect([functionID functionIdForName:SDLRPCFunctionNameShowConstantTBT]).to(equal(@27));
        expect([functionID functionIdForName:SDLRPCFunctionNameAlertManeuver]).to(equal(@28));
        expect([functionID functionIdForName:SDLRPCFunctionNameUpdateTurnList]).to(equal(@29));
        expect([functionID functionIdForName:SDLRPCFunctionNameChangeRegistration]).to(equal(@30));
        expect([functionID functionIdForName:SDLRPCFunctionNameGenericResponse]).to(equal(@31));
        expect([functionID functionIdForName:SDLRPCFunctionNamePutFile]).to(equal(@32));
        expect([functionID functionIdForName:SDLRPCFunctionNameDeleteFile]).to(equal(@33));
        expect([functionID functionIdForName:SDLRPCFunctionNameListFiles]).to(equal(@34));
        expect([functionID functionIdForName:SDLRPCFunctionNameSetAppIcon]).to(equal(@35));
        expect([functionID functionIdForName:SDLRPCFunctionNameSetDisplayLayout]).to(equal(@36));
        expect([functionID functionIdForName:SDLRPCFunctionNameDiagnosticMessage]).to(equal(@37));
        expect([functionID functionIdForName:SDLRPCFunctionNameSystemRequest]).to(equal(@38));
        expect([functionID functionIdForName:SDLRPCFunctionNameSendLocation]).to(equal(@39));
        expect([functionID functionIdForName:SDLRPCFunctionNameDialNumber]).to(equal(@40));
        expect([functionID functionIdForName:SDLRPCFunctionNameGetWayPoints]).to(equal(@45));
        expect([functionID functionIdForName:SDLRPCFunctionNameSubscribeWayPoints]).to(equal(@46));
        expect([functionID functionIdForName:SDLRPCFunctionNameUnsubscribeWayPoints]).to(equal(@47));
        expect([functionID functionIdForName:SDLRPCFunctionNameGetSystemCapability]).to(equal(@48));
        expect([functionID functionIdForName:SDLRPCFunctionNameSendHapticData]).to(equal(@49));
        expect([functionID functionIdForName:SDLRPCFunctionNameSetCloudAppProperties]).to(equal(@50));
        expect([functionID functionIdForName:SDLRPCFunctionNameGetCloudAppProperties]).to(equal(@51));
        expect([functionID functionIdForName:SDLRPCFunctionNamePublishAppService]).to(equal(@52));
        expect([functionID functionIdForName:SDLRPCFunctionNameGetAppServiceData]).to(equal(@53));
        expect([functionID functionIdForName:SDLRPCFunctionNameGetFile]).to(equal(@54));
        expect([functionID functionIdForName:SDLRPCFunctionNamePerformAppServiceInteraction]).to(equal(@55));
        expect([functionID functionIdForName:SDLRPCFunctionNameCreateWindow]).to(equal(@60));
        expect([functionID functionIdForName:SDLRPCFunctionNameDeleteWindow]).to(equal(@61));
        expect([functionID functionIdForName:SDLRPCFunctionNameDefault]).to(equal(@65));
        expect([functionID functionIdForName:SDLRPCFunctionNamePerformChoiceSet]).to(equal(@66));
        expect([functionID functionIdForName:SDLRPCFunctionNameScreenUpdate]).to(equal(@67));
        expect([functionID functionIdForName:SDLRPCFunctionNameAccessMicrophone]).to(equal(@68));
        expect([functionID functionIdForName:SDLRPCFunctionNameOpenMenu]).to(equal(@69));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnHMIStatus]).to(equal(@32768));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnAppInterfaceUnregistered]).to(equal(@32769));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnButtonEvent]).to(equal(@32770));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnButtonPress]).to(equal(@32771));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnVehicleData]).to(equal(@32772));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnCommand]).to(equal(@32773));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnTBTClientState]).to(equal(@32774));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnDriverDistraction]).to(equal(@32775));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnPermissionsChange]).to(equal(@32776));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnAudioPassThru]).to(equal(@32777));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnLanguageChange]).to(equal(@32778));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnKeyboardInput]).to(equal(@32779));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnTouchEvent]).to(equal(@32780));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnSystemRequest]).to(equal(@32781));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnHashChange]).to(equal(@32782));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnWayPointChange]).to(equal(@32784));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnRCStatus]).to(equal(@32785));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnAppServiceData]).to(equal(@32786));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnSystemCapabilityUpdated]).to(equal(@32787));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnAppCapabilityUpdated]).to(equal(32791));

        //Not listed in Spec
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect([functionID functionIdForName:SDLRPCFunctionNameEncodedSyncPData]).to(equal(@65536));
        expect([functionID functionIdForName:SDLRPCFunctionNameSyncPData]).to(equal(@65537));
        
        expect([functionID functionIdForName:SDLRPCFunctionNameOnEncodedSyncPData]).to(equal(@98304));
        expect([functionID functionIdForName:SDLRPCFunctionNameOnSyncPData]).to(equal(@98305));
#pragma clang diagnostic pop
    });
});

QuickSpecEnd
