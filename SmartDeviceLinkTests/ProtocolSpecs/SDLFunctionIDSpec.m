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
        expect([functionID getFunctionName:1]).to(equal(SDLNameRegisterAppInterface));
        expect([functionID getFunctionName:2]).to(equal(SDLNameUnregisterAppInterface));
        expect([functionID getFunctionName:3]).to(equal(SDLNameSetGlobalProperties));
        expect([functionID getFunctionName:4]).to(equal(SDLNameResetGlobalProperties));
        expect([functionID getFunctionName:5]).to(equal(SDLNameAddCommand));
        expect([functionID getFunctionName:6]).to(equal(SDLNameDeleteCommand));
        expect([functionID getFunctionName:7]).to(equal(SDLNameAddSubMenu));
        expect([functionID getFunctionName:8]).to(equal(SDLNameDeleteSubMenu));
        expect([functionID getFunctionName:9]).to(equal(SDLNameCreateInteractionChoiceSet));
        expect([functionID getFunctionName:10]).to(equal(SDLNamePerformInteraction));
        expect([functionID getFunctionName:11]).to(equal(SDLNameDeleteInteractionChoiceSet));
        expect([functionID getFunctionName:12]).to(equal(SDLNameAlert));
        expect([functionID getFunctionName:13]).to(equal(SDLNameShow));
        expect([functionID getFunctionName:14]).to(equal(SDLNameSpeak));
        expect([functionID getFunctionName:15]).to(equal(SDLNameSetMediaClockTimer));
        expect([functionID getFunctionName:16]).to(equal(SDLNamePerformAudioPassThru));
        expect([functionID getFunctionName:17]).to(equal(SDLNameEndAudioPassThru));
        expect([functionID getFunctionName:18]).to(equal(SDLNameSubscribeButton));
        expect([functionID getFunctionName:19]).to(equal(SDLNameUnsubscribeButton));
        expect([functionID getFunctionName:20]).to(equal(SDLNameSubscribeVehicleData));
        expect([functionID getFunctionName:21]).to(equal(SDLNameUnsubscribeVehicleData));
        expect([functionID getFunctionName:22]).to(equal(SDLNameGetVehicleData));
        expect([functionID getFunctionName:23]).to(equal(SDLNameReadDID));
        expect([functionID getFunctionName:24]).to(equal(SDLNameGetDTCs));
        expect([functionID getFunctionName:25]).to(equal(SDLNameScrollableMessage));
        expect([functionID getFunctionName:26]).to(equal(SDLNameSlider));
        expect([functionID getFunctionName:27]).to(equal(SDLNameShowConstantTBT));
        expect([functionID getFunctionName:28]).to(equal(SDLNameAlertManeuver));
        expect([functionID getFunctionName:29]).to(equal(SDLNameUpdateTurnList));
        expect([functionID getFunctionName:30]).to(equal(SDLNameChangeRegistration));
        expect([functionID getFunctionName:31]).to(equal(SDLNameGenericResponse));
        expect([functionID getFunctionName:32]).to(equal(SDLNamePutFile));
        expect([functionID getFunctionName:33]).to(equal(SDLNameDeleteFile));
        expect([functionID getFunctionName:34]).to(equal(SDLNameListFiles));
        expect([functionID getFunctionName:35]).to(equal(SDLNameSetAppIcon));
        expect([functionID getFunctionName:36]).to(equal(SDLNameSetDisplayLayout));
        expect([functionID getFunctionName:37]).to(equal(SDLNameDiagnosticMessage));
        expect([functionID getFunctionName:38]).to(equal(SDLNameSystemRequest));
        expect([functionID getFunctionName:39]).to(equal(SDLNameSendLocation));
        expect([functionID getFunctionName:40]).to(equal(SDLNameDialNumber));
        expect([functionID getFunctionName:32768]).to(equal(SDLNameOnHMIStatus));
        expect([functionID getFunctionName:32769]).to(equal(SDLNameOnAppInterfaceUnregistered));
        expect([functionID getFunctionName:32770]).to(equal(SDLNameOnButtonEvent));
        expect([functionID getFunctionName:32771]).to(equal(SDLNameOnButtonPress));
        expect([functionID getFunctionName:32772]).to(equal(SDLNameOnVehicleData));
        expect([functionID getFunctionName:32773]).to(equal(SDLNameOnCommand));
        expect([functionID getFunctionName:32774]).to(equal(SDLNameOnTBTClientState));
        expect([functionID getFunctionName:32775]).to(equal(SDLNameOnDriverDistraction));
        expect([functionID getFunctionName:32776]).to(equal(SDLNameOnPermissionsChange));
        expect([functionID getFunctionName:32777]).to(equal(SDLNameOnAudioPassThru));
        expect([functionID getFunctionName:32778]).to(equal(SDLNameOnLanguageChange));
        expect([functionID getFunctionName:32779]).to(equal(SDLNameOnKeyboardInput));
        expect([functionID getFunctionName:32780]).to(equal(SDLNameOnTouchEvent));
        expect([functionID getFunctionName:32781]).to(equal(SDLNameOnSystemRequest));
        expect([functionID getFunctionName:32782]).to(equal(SDLNameOnHashChange));
        
        //Not listed in Spec
        expect([functionID getFunctionName:65536]).to(equal(SDLNameEncodedSyncPData));
        expect([functionID getFunctionName:65537]).to(equal(SDLNameSyncPData));
        
        expect([functionID getFunctionName:98304]).to(equal(SDLNameOnEncodedSyncPData));
        expect([functionID getFunctionName:98305]).to(equal(SDLNameOnSyncPData));
    });
});

describe(@"GetFunctionID Tests", ^ {
    it(@"Should return the correct function ID", ^ {
        expect([functionID getFunctionID:SDLNameRegisterAppInterface]).to(equal(@1));
        expect([functionID getFunctionID:SDLNameUnregisterAppInterface]).to(equal(@2));
        expect([functionID getFunctionID:SDLNameSetGlobalProperties]).to(equal(@3));
        expect([functionID getFunctionID:SDLNameResetGlobalProperties]).to(equal(@4));
        expect([functionID getFunctionID:SDLNameAddCommand]).to(equal(@5));
        expect([functionID getFunctionID:SDLNameDeleteCommand]).to(equal(@6));
        expect([functionID getFunctionID:SDLNameAddSubMenu]).to(equal(@7));
        expect([functionID getFunctionID:SDLNameDeleteSubMenu]).to(equal(@8));
        expect([functionID getFunctionID:SDLNameCreateInteractionChoiceSet]).to(equal(@9));
        expect([functionID getFunctionID:SDLNamePerformInteraction]).to(equal(@10));
        expect([functionID getFunctionID:SDLNameDeleteInteractionChoiceSet]).to(equal(@11));
        expect([functionID getFunctionID:SDLNameAlert]).to(equal(@12));
        expect([functionID getFunctionID:SDLNameShow]).to(equal(@13));
        expect([functionID getFunctionID:SDLNameSpeak]).to(equal(@14));
        expect([functionID getFunctionID:SDLNameSetMediaClockTimer]).to(equal(@15));
        expect([functionID getFunctionID:SDLNamePerformAudioPassThru]).to(equal(@16));
        expect([functionID getFunctionID:SDLNameEndAudioPassThru]).to(equal(@17));
        expect([functionID getFunctionID:SDLNameSubscribeButton]).to(equal(@18));
        expect([functionID getFunctionID:SDLNameUnsubscribeButton]).to(equal(@19));
        expect([functionID getFunctionID:SDLNameSubscribeVehicleData]).to(equal(@20));
        expect([functionID getFunctionID:SDLNameUnsubscribeVehicleData]).to(equal(@21));
        expect([functionID getFunctionID:SDLNameGetVehicleData]).to(equal(@22));
        expect([functionID getFunctionID:SDLNameReadDID]).to(equal(@23));
        expect([functionID getFunctionID:SDLNameGetDTCs]).to(equal(@24));
        expect([functionID getFunctionID:SDLNameScrollableMessage]).to(equal(@25));
        expect([functionID getFunctionID:SDLNameSlider]).to(equal(@26));
        expect([functionID getFunctionID:SDLNameShowConstantTBT]).to(equal(@27));
        expect([functionID getFunctionID:SDLNameAlertManeuver]).to(equal(@28));
        expect([functionID getFunctionID:SDLNameUpdateTurnList]).to(equal(@29));
        expect([functionID getFunctionID:SDLNameChangeRegistration]).to(equal(@30));
        expect([functionID getFunctionID:SDLNameGenericResponse]).to(equal(@31));
        expect([functionID getFunctionID:SDLNamePutFile]).to(equal(@32));
        expect([functionID getFunctionID:SDLNameDeleteFile]).to(equal(@33));
        expect([functionID getFunctionID:SDLNameListFiles]).to(equal(@34));
        expect([functionID getFunctionID:SDLNameSetAppIcon]).to(equal(@35));
        expect([functionID getFunctionID:SDLNameSetDisplayLayout]).to(equal(@36));
        expect([functionID getFunctionID:SDLNameDiagnosticMessage]).to(equal(@37));
        expect([functionID getFunctionID:SDLNameSystemRequest]).to(equal(@38));
        expect([functionID getFunctionID:SDLNameSendLocation]).to(equal(@39));
        expect([functionID getFunctionID:SDLNameDialNumber]).to(equal(@40));
        expect([functionID getFunctionID:SDLNameOnHMIStatus]).to(equal(@32768));
        expect([functionID getFunctionID:SDLNameOnAppInterfaceUnregistered]).to(equal(@32769));
        expect([functionID getFunctionID:SDLNameOnButtonEvent]).to(equal(@32770));
        expect([functionID getFunctionID:SDLNameOnButtonPress]).to(equal(@32771));
        expect([functionID getFunctionID:SDLNameOnVehicleData]).to(equal(@32772));
        expect([functionID getFunctionID:SDLNameOnCommand]).to(equal(@32773));
        expect([functionID getFunctionID:SDLNameOnTBTClientState]).to(equal(@32774));
        expect([functionID getFunctionID:SDLNameOnDriverDistraction]).to(equal(@32775));
        expect([functionID getFunctionID:SDLNameOnPermissionsChange]).to(equal(@32776));
        expect([functionID getFunctionID:SDLNameOnAudioPassThru]).to(equal(@32777));
        expect([functionID getFunctionID:SDLNameOnLanguageChange]).to(equal(@32778));
        expect([functionID getFunctionID:SDLNameOnKeyboardInput]).to(equal(@32779));
        expect([functionID getFunctionID:SDLNameOnTouchEvent]).to(equal(@32780));
        expect([functionID getFunctionID:SDLNameOnSystemRequest]).to(equal(@32781));
        expect([functionID getFunctionID:SDLNameOnHashChange]).to(equal(@32782));
        
        //Not listed in Spec
        expect([functionID getFunctionID:SDLNameEncodedSyncPData]).to(equal(@65536));
        expect([functionID getFunctionID:SDLNameSyncPData]).to(equal(@65537));
        
        expect([functionID getFunctionID:SDLNameOnEncodedSyncPData]).to(equal(@98304));
        expect([functionID getFunctionID:SDLNameOnSyncPData]).to(equal(@98305));
    });
});

QuickSpecEnd
