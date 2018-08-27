//  SDLFunctionID.m
//


#import "SDLFunctionID.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFunctionID ()

@property (nonatomic, strong, nonnull) NSDictionary* functionIds;

@end

@implementation SDLFunctionID

+ (instancetype)sharedInstance {
    static SDLFunctionID* functionId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        functionId = [[SDLFunctionID alloc] init];
    });
    return functionId;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.functionIds = @{
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
                         @41: SDLNameButtonPress,
                         @43: SDLNameGetInteriorVehicleData,
                         @44: SDLNameSetInteriorVehicleData,
                         @45: SDLNameGetWayPoints,
                         @46: SDLNameSubscribeWayPoints,
                         @47: SDLNameUnsubscribeWayPoints,
                         @48: SDLNameGetSystemCapability,
                         @49: SDLNameSendHapticData,
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
                         @32783: SDLNameOnInteriorVehicleData,
                         @32784: SDLNameOnWayPointChange,
                         @65536: SDLNameEncodedSyncPData,
                         @65537: SDLNameSyncPData,
                         @98304: SDLNameOnEncodedSyncPData,
                         @98305: SDLNameOnSyncPData
                         };
    return self;
}

- (nullable SDLName)functionNameForId:(UInt32)functionID {
    return self.functionIds[@(functionID)];
}

- (nullable NSNumber<SDLInt> *)functionIdForName:(SDLName)functionName {
    return [[self.functionIds allKeysForObject:functionName] firstObject];
}

@end

NS_ASSUME_NONNULL_END
