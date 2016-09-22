//  SDLFunctionID.m
//


#import "SDLFunctionID.h"

@interface SDLFunctionID ()

@property (nonatomic, strong, nonnull) NSDictionary* functionIDs;

@end

@implementation SDLFunctionID

- (instancetype)init {
    if (self = [super init]) {
        static NSDictionary* functionIDs = nil;
        if (functionIDs == nil) {
            functionIDs = @{
                            @0: SDLNameReserved,
                            @1: SDLNameRegisterAppInterface,
                            @2: SDLNameUnregisterAppInterface,
                            @3: SDLNameSetGlobalProperties,
                            @4: SDLNameResetGlobalProperties,
                            @5: SDLNameAddCommand,
                            @6: SDLNameDeleteCommand,
                            @7: SDLNameAddSubMenu,
                            @8: SDLNameDeleteSubMenu,
                            @9: SDLNameCreateInteractionChoiceSet,
                            @10: SDLNamePerformInteraction,
                            @11: SDLNameDeleteInteractionChoiceSet,
                            @12: SDLNameAlert,
                            @13: SDLNameShow,
                            @14: SDLNameSpeak,
                            @15: SDLNameSetMediaClockTimer,
                            @16: SDLNamePerformAudioPassThru,
                            @17: SDLNameEndAudioPassThru,
                            @18: SDLNameSubscribeButton,
                            @19: SDLNameUnsubscribeButton,
                            @20: SDLNameSubscribeVehicleData,
                            @21: SDLNameUnsubscribeVehicleData,
                            @22: SDLNameGetVehicleData,
                            @23: SDLNameReadDID,
                            @24: SDLNameGetDTCs,
                            @25: SDLNameScrollableMessage,
                            @26: SDLNameSlider,
                            @27: SDLNameShowConstantTBT,
                            @28: SDLNameAlertManeuver,
                            @29: SDLNameUpdateTurnList,
                            @30: SDLNameChangeRegistration,
                            @31: SDLNameGenericResponse,
                            @32: SDLNamePutFile,
                            @33: SDLNameDeleteFile,
                            @34: SDLNameListFiles,
                            @35: SDLNameSetAppIcon,
                            @36: SDLNameSetDisplayLayout,
                            @37: SDLNameDiagnosticMessage,
                            @38: SDLNameSystemRequest,
                            @39: SDLNameSendLocation,
                            @40: SDLNameDialNumber,
                            @32768: SDLNameOnHMIStatus,
                            @32769: SDLNameOnAppInterfaceUnregistered,
                            @32770: SDLNameOnButtonEvent,
                            @32771: SDLNameOnButtonPress,
                            @32772: SDLNameOnVehicleData,
                            @32773: SDLNameOnCommand,
                            @32774: SDLNameOnTBTClientState,
                            @32775: SDLNameOnDriverDistraction,
                            @32776: SDLNameOnPermissionsChange,
                            @32777: SDLNameOnAudioPassThru,
                            @32778: SDLNameOnLanguageChange,
                            @32779: SDLNameOnKeyboardInput,
                            @32780: SDLNameOnTouchEvent,
                            @32781: SDLNameOnSystemRequest,
                            @32782: SDLNameOnHashChange,
                            @65536: SDLNameEncodedSyncPData,
                            @65537: SDLNameSyncPData,
                            @98304: SDLNameOnEncodedSyncPData,
                            @98305: SDLNameOnSyncPData
                            };
        }
        self.functionIDs = functionIDs;
    }
    return self;
}

- (SDLName)getFunctionName:(int)functionID {
    return [self.functionIDs objectForKey:@(functionID)];
}


- (NSNumber *)getFunctionID:(SDLName)functionName {
    return [[self.functionIDs allKeysForObject:functionName] firstObject];
}


@end
