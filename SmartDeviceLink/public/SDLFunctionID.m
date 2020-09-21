//  SDLFunctionID.m
//


#import "SDLFunctionID.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCFunctionNames.h"

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
                         @0: SDLRPCFunctionNameReserved,
                         @1: SDLRPCFunctionNameRegisterAppInterface,
                         @2: SDLRPCFunctionNameUnregisterAppInterface,
                         @3: SDLRPCFunctionNameSetGlobalProperties,
                         @4: SDLRPCFunctionNameResetGlobalProperties,
                         @5: SDLRPCFunctionNameAddCommand,
                         @6: SDLRPCFunctionNameDeleteCommand,
                         @7: SDLRPCFunctionNameAddSubMenu,
                         @8: SDLRPCFunctionNameDeleteSubMenu,
                         @9: SDLRPCFunctionNameCreateInteractionChoiceSet,
                         @10: SDLRPCFunctionNamePerformInteraction,
                         @11: SDLRPCFunctionNameDeleteInteractionChoiceSet,
                         @12: SDLRPCFunctionNameAlert,
                         @13: SDLRPCFunctionNameShow,
                         @14: SDLRPCFunctionNameSpeak,
                         @15: SDLRPCFunctionNameSetMediaClockTimer,
                         @16: SDLRPCFunctionNamePerformAudioPassThru,
                         @17: SDLRPCFunctionNameEndAudioPassThru,
                         @18: SDLRPCFunctionNameSubscribeButton,
                         @19: SDLRPCFunctionNameUnsubscribeButton,
                         @20: SDLRPCFunctionNameSubscribeVehicleData,
                         @21: SDLRPCFunctionNameUnsubscribeVehicleData,
                         @22: SDLRPCFunctionNameGetVehicleData,
                         @23: SDLRPCFunctionNameReadDID,
                         @24: SDLRPCFunctionNameGetDTCs,
                         @25: SDLRPCFunctionNameScrollableMessage,
                         @26: SDLRPCFunctionNameSlider,
                         @27: SDLRPCFunctionNameShowConstantTBT,
                         @28: SDLRPCFunctionNameAlertManeuver,
                         @29: SDLRPCFunctionNameUpdateTurnList,
                         @30: SDLRPCFunctionNameChangeRegistration,
                         @31: SDLRPCFunctionNameGenericResponse,
                         @32: SDLRPCFunctionNamePutFile,
                         @33: SDLRPCFunctionNameDeleteFile,
                         @34: SDLRPCFunctionNameListFiles,
                         @35: SDLRPCFunctionNameSetAppIcon,
                         @36: SDLRPCFunctionNameSetDisplayLayout,
                         @37: SDLRPCFunctionNameDiagnosticMessage,
                         @38: SDLRPCFunctionNameSystemRequest,
                         @39: SDLRPCFunctionNameSendLocation,
                         @40: SDLRPCFunctionNameDialNumber,
                         @41: SDLRPCFunctionNameButtonPress,
                         @43: SDLRPCFunctionNameGetInteriorVehicleData,
                         @44: SDLRPCFunctionNameSetInteriorVehicleData,
                         @45: SDLRPCFunctionNameGetWayPoints,
                         @46: SDLRPCFunctionNameSubscribeWayPoints,
                         @47: SDLRPCFunctionNameUnsubscribeWayPoints,
                         @48: SDLRPCFunctionNameGetSystemCapability,
                         @49: SDLRPCFunctionNameSendHapticData,
                         @50: SDLRPCFunctionNameSetCloudAppProperties,
                         @51: SDLRPCFunctionNameGetCloudAppProperties,
                         @52: SDLRPCFunctionNamePublishAppService,
                         @53: SDLRPCFunctionNameGetAppServiceData,
                         @54: SDLRPCFunctionNameGetFile,
                         @55: SDLRPCFunctionNamePerformAppServiceInteraction,
                         @56: SDLRPCFunctionNameUnpublishAppService,
                         @57: SDLRPCFunctionNameCancelInteraction,
                         @58: SDLRPCFunctionNameCloseApplication,
                         @59: SDLRPCFunctionNameShowAppMenu,
                         @60: SDLRPCFunctionNameCreateWindow,
                         @61: SDLRPCFunctionNameDeleteWindow,
                         @62: SDLRPCFunctionNameGetInteriorVehicleDataConsent,
                         @63: SDLRPCFunctionNameReleaseInteriorVehicleDataModule,
                         @64: SDLRPCFunctionNameSubtleAlert,
                         @32768: SDLRPCFunctionNameOnHMIStatus,
                         @32769: SDLRPCFunctionNameOnAppInterfaceUnregistered,
                         @32770: SDLRPCFunctionNameOnButtonEvent,
                         @32771: SDLRPCFunctionNameOnButtonPress,
                         @32772: SDLRPCFunctionNameOnVehicleData,
                         @32773: SDLRPCFunctionNameOnCommand,
                         @32774: SDLRPCFunctionNameOnTBTClientState,
                         @32775: SDLRPCFunctionNameOnDriverDistraction,
                         @32776: SDLRPCFunctionNameOnPermissionsChange,
                         @32777: SDLRPCFunctionNameOnAudioPassThru,
                         @32778: SDLRPCFunctionNameOnLanguageChange,
                         @32779: SDLRPCFunctionNameOnKeyboardInput,
                         @32780: SDLRPCFunctionNameOnTouchEvent,
                         @32781: SDLRPCFunctionNameOnSystemRequest,
                         @32782: SDLRPCFunctionNameOnHashChange,
                         @32783: SDLRPCFunctionNameOnInteriorVehicleData,
                         @32784: SDLRPCFunctionNameOnWayPointChange,
                         @32785: SDLRPCFunctionNameOnRCStatus,
                         @32786: SDLRPCFunctionNameOnAppServiceData,
                         @32787: SDLRPCFunctionNameOnSystemCapabilityUpdated,
                         @32788: SDLRPCFunctionNameOnSubtleAlertPressed,
                         @32789: SDLRPCFunctionNameOnUpdateFile,
                         @32790: SDLRPCFunctionNameOnUpdateSubMenu,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                         @65536: SDLRPCFunctionNameEncodedSyncPData,
                         @65537: SDLRPCFunctionNameSyncPData,
                         @98304: SDLRPCFunctionNameOnEncodedSyncPData,
                         @98305: SDLRPCFunctionNameOnSyncPData
#pragma clang diagnostic pop
                         };
    return self;
}

- (nullable SDLRPCFunctionName)functionNameForId:(UInt32)functionID {
    return self.functionIds[@(functionID)];
}

- (nullable NSNumber<SDLInt> *)functionIdForName:(SDLRPCFunctionName)functionName {
    return [[self.functionIds allKeysForObject:functionName] firstObject];
}

@end

NS_ASSUME_NONNULL_END
