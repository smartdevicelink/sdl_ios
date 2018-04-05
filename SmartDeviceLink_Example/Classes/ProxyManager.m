//
//  ProxyManager.m
//  SmartDeviceLink-iOS

#import "SmartDeviceLink.h"
#import "ProxyManager.h"
#import "Preferences.h"

NSString *const SDLAppName = @"SDL Example App";
NSString *const SDLAppId = @"9999";


BOOL const ShouldRestartOnDisconnect = NO;

typedef NS_ENUM(NSUInteger, SDLHMIFirstState) {
    SDLHMIFirstStateNone,
    SDLHMIFirstStateNonNone,
    SDLHMIFirstStateFull
};


NS_ASSUME_NONNULL_BEGIN

@interface ProxyManager () <SDLManagerDelegate>

// Describes the first time the HMI state goes non-none and full.
@property (assign, nonatomic) SDLHMIFirstState firstTimeState;

@property (assign, nonatomic, getter=isTextEnabled) BOOL textEnabled;
@property (assign, nonatomic, getter=isHexagonEnabled) BOOL hexagonEnabled;
@property (assign, nonatomic, getter=areImagesEnabled) BOOL imagesEnabled;

@end


@implementation ProxyManager

#pragma mark - Initialization

+ (instancetype)sharedManager {
    static ProxyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ProxyManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _state = ProxyStateStopped;
    _firstTimeState = SDLHMIFirstStateNone;

    _textEnabled = YES;
    _hexagonEnabled = YES;
    _imagesEnabled = YES;
    
    return self;
}

- (void)startIAP {
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    // Check for previous instance of sdlManager
    if (self.sdlManager) { return; }
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration defaultConfigurationWithAppName:SDLAppName appId:SDLAppId]];
    [self sdlex_setupConfigurationWithLifecycleConfiguration:lifecycleConfig];
}

- (void)startTCP {
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    // Check for previous instance of sdlManager
    if (self.sdlManager) { return; }
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration debugConfigurationWithAppName:SDLAppName appId:SDLAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port]];
    [self sdlex_setupConfigurationWithLifecycleConfiguration:lifecycleConfig];
}

- (void)sdlex_setupConfigurationWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfiguration lockScreen:[SDLLockScreenConfiguration enabledConfigurationWithAppIcon:[UIImage imageNamed:@"AppIcon60x60@2x"] backgroundColor:nil] logging:[self.class sdlex_logConfiguration]];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:self];

    [self startManager];
}

- (void)startManager {
    __weak typeof (self) weakSelf = self;
    [self.sdlManager startWithReadyHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            SDLLogE(@"SDL errored starting up: %@", error);
            [weakSelf sdlex_updateProxyState:ProxyStateStopped];
            return;
        }
        
        [weakSelf sdlex_updateProxyState:ProxyStateConnected];

        [weakSelf sdlex_setupPermissionsCallbacks];
        
        if ([weakSelf.sdlManager.hmiLevel isEqualToEnum:SDLHMILevelFull]) {
            [weakSelf sdlex_showInitialData];
        }
    }];
}

- (void)reset {
    [self sdlex_updateProxyState:ProxyStateStopped];
    [self.sdlManager stop];
    // Remove reference
    self.sdlManager = nil;
}


#pragma mark - Helpers

- (void)sdlex_showInitialData {
    if (![self.sdlManager.hmiLevel isEqualToEnum:SDLHMILevelFull]) {
        return;
    }

    SDLSetDisplayLayout *displayLayout = [[SDLSetDisplayLayout alloc] initWithLayout:SDLPredefinedLayoutNonMedia];
    [self.sdlManager sendRequest:displayLayout];

    [self sdlex_updateScreen];

    self.sdlManager.screenManager.softButtonObjects = [self sdlex_softButtons];
}

- (void)setTextEnabled:(BOOL)textEnabled {
    _textEnabled = textEnabled;
    [self sdlex_updateScreen];
}

- (void)setImagesEnabled:(BOOL)imagesEnabled {
    _imagesEnabled = imagesEnabled;
    [self sdlex_updateScreen];
    [self setHexagonButtonIconEnabled:self.isHexagonEnabled imagesEnabled:imagesEnabled];
}

- (void)setHexagonEnabled:(BOOL)hexagonEnabled {
    _hexagonEnabled = hexagonEnabled;
    [self setHexagonButtonIconEnabled:hexagonEnabled imagesEnabled:self.areImagesEnabled];
}

- (void)setHexagonButtonIconEnabled:(BOOL)hexagonEnabled imagesEnabled:(BOOL)imagesEnabled {
    SDLSoftButtonObject *object = [self.sdlManager.screenManager softButtonObjectNamed:@"HexagonButton"];
    imagesEnabled ? [object transitionToStateNamed:(hexagonEnabled ? @"imageOnState" : @"imageOffState")] : [object transitionToStateNamed:(hexagonEnabled ? @"textOnState" : @"textOffState")];
}

- (void)sdlex_updateScreen {
    [self.sdlManager.screenManager beginUpdates];
    self.sdlManager.screenManager.textAlignment = SDLTextAlignmentLeft;
    self.sdlManager.screenManager.textField1 = self.isTextEnabled ? @"SmartDeviceLink" : nil;
    self.sdlManager.screenManager.textField2 = self.isTextEnabled ? @"Example App" : nil;

    if (self.sdlManager.systemCapabilityManager.displayCapabilities.graphicSupported) {
        self.sdlManager.screenManager.primaryGraphic = self.areImagesEnabled ? [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:@"sdl_logo_green"] asImageFormat:SDLArtworkImageFormatPNG] : nil;
    }

    [self.sdlManager.screenManager endUpdatesWithCompletionHandler:^(NSError * _Nullable error) {
        SDLLogD(@"Updated text and graphics, error? %@", error);
    }];
}

- (void)sdlex_setupPermissionsCallbacks {
    // This will tell you whether or not you can use the Show RPC right at this moment
    BOOL isAvailable = [self.sdlManager.permissionManager isRPCAllowed:@"Show"];
    SDLLogD(@"Show is allowed? %@", @(isAvailable));

    // This will set up a block that will tell you whether or not you can use none, all, or some of the RPCs specified, and notifies you when those permissions change
    SDLPermissionObserverIdentifier observerId = [self.sdlManager.permissionManager addObserverForRPCs:@[@"Show", @"Alert"] groupType:SDLPermissionGroupTypeAllAllowed withHandler:^(NSDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
        SDLLogD(@"Show changed permission to status: %@, dict: %@", @(status), change);
    }];
    // The above block will be called immediately, this will then remove the block from being called any more
    [self.sdlManager.permissionManager removeObserverForIdentifier:observerId];

    // This will give us the current status of the group of RPCs, as if we had set up an observer, except these are one-shot calls
    NSArray *rpcGroup =@[@"AddCommand", @"PerformInteraction"];
    SDLPermissionGroupStatus commandPICSStatus = [self.sdlManager.permissionManager groupStatusOfRPCs:rpcGroup];
    NSDictionary *commandPICSStatusDict = [self.sdlManager.permissionManager statusOfRPCs:rpcGroup];
    SDLLogD(@"Command / PICS status: %@, dict: %@", @(commandPICSStatus), commandPICSStatusDict);

    // This will set up a long-term observer for the RPC group and will tell us when the status of any specified RPC changes (due to the `SDLPermissionGroupTypeAny`) option.
    [self.sdlManager.permissionManager addObserverForRPCs:rpcGroup groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
        SDLLogD(@"Command / PICS changed permission to status: %@, dict: %@", @(status), change);
    }];
}

+ (SDLLifecycleConfiguration *)sdlex_setLifecycleConfigurationPropertiesOnConfiguration:(SDLLifecycleConfiguration *)config {
    SDLArtwork *appIconArt = [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:@"AppIcon60x60@2x"] asImageFormat:SDLArtworkImageFormatPNG];

    config.shortAppName = @"SDL Example";
    config.appIcon = appIconArt;
    config.voiceRecognitionCommandNames = @[@"S D L Example"];
    config.ttsName = [SDLTTSChunk textChunksFromString:config.shortAppName];
    config.language = SDLLanguageEnUs;
    config.languagesSupported = @[SDLLanguageEnUs, SDLLanguageFrCa, SDLLanguageEsMx];

    return config;
}

+ (SDLLogConfiguration *)sdlex_logConfiguration {
    SDLLogConfiguration *logConfig = [SDLLogConfiguration defaultConfiguration];
    SDLLogFileModule *sdlExampleModule = [SDLLogFileModule moduleWithName:@"SDL Example" files:[NSSet setWithArray:@[@"ProxyManager"]]];
    logConfig.modules = [logConfig.modules setByAddingObject:sdlExampleModule];
    logConfig.targets = [logConfig.targets setByAddingObject:[SDLLogTargetFile logger]];
    // logConfig.filters = [logConfig.filters setByAddingObject:[SDLLogFilter filterByAllowingModules:[NSSet setWithObject:@"Transport"]]];

    return logConfig;
}

- (void)sdlex_updateProxyState:(ProxyState)newState {
    if (self.state != newState) {
        [self willChangeValueForKey:@"state"];
        _state = newState;
        [self didChangeValueForKey:@"state"];
    }
}

#pragma mark - RPC builders

+ (SDLAddCommand *)sdlex_speakNameCommandWithManager:(SDLManager *)manager {
    NSString *commandName = @"Speak App Name";
    
    SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] init];
    commandMenuParams.menuName = commandName;
    
    SDLAddCommand *speakNameCommand = [[SDLAddCommand alloc] init];
    speakNameCommand.vrCommands = @[commandName];
    speakNameCommand.menuParams = commandMenuParams;
    speakNameCommand.cmdID = @0;
    
    speakNameCommand.handler = ^void(SDLOnCommand *notification) {
        [manager sendRequest:[self.class sdlex_appNameSpeak]];
    };
    
    return speakNameCommand;
}

+ (SDLAddCommand *)sdlex_interactionSetCommandWithManager:(SDLManager *)manager {
    NSString *commandName = @"Perform Interaction";
    
    SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] init];
    commandMenuParams.menuName = commandName;
    
    SDLAddCommand *performInteractionCommand = [[SDLAddCommand alloc] init];
    performInteractionCommand.vrCommands = @[commandName];
    performInteractionCommand.menuParams = commandMenuParams;
    performInteractionCommand.cmdID = @1;
    
    // NOTE: You may want to preload your interaction sets, because they can take a while for the remote system to process. We're going to ignore our own advice here.
    __weak typeof(self) weakSelf = self;
    performInteractionCommand.handler = ^void(SDLOnCommand *notification) {
        [weakSelf sdlex_sendPerformOnlyChoiceInteractionWithManager:manager];
    };
    
    return performInteractionCommand;
}

+ (SDLAddCommand *)sdlex_vehicleDataCommandWithManager:(SDLManager *)manager {
    SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] init];
    commandMenuParams.menuName = @"Get Vehicle Data";

    SDLAddCommand *getVehicleDataCommand = [[SDLAddCommand alloc] init];
    getVehicleDataCommand.vrCommands = [NSMutableArray arrayWithObject:@"Get Vehicle Data"];
    getVehicleDataCommand.menuParams = commandMenuParams;
    getVehicleDataCommand.cmdID = @2;

    getVehicleDataCommand.handler = ^void(SDLOnCommand *notification) {
        [ProxyManager sdlex_sendGetVehicleDataWithManager:manager];
    };

    return getVehicleDataCommand;
}

+ (SDLAddCommand *)sdlex_dialNumberCommandWithManager:(SDLManager *)manager {
    NSString *menuName = @"Dial Number";
    SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] initWithMenuName:menuName];

    SDLAddCommand *dialNumberCommand = [[SDLAddCommand alloc] init];
    dialNumberCommand.vrCommands = [NSMutableArray arrayWithObject:menuName];
    dialNumberCommand.menuParams = commandMenuParams;
    dialNumberCommand.cmdID = @3;
    dialNumberCommand.handler = ^(SDLOnCommand * _Nonnull command) {
        SDLLogD(@"Checking if app has permission to dial a number");
        if (![manager.permissionManager isRPCAllowed:@"DialNumber"]) {
            SDLAlert* alert = [[SDLAlert alloc] init];
            alert.alertText1 = @"This app does not have the required permissions to dial a number";
            [manager sendRequest:alert];
            return;
        }

        SDLLogD(@"Checking phone call capability");
        [manager.systemCapabilityManager updateCapabilityType:SDLSystemCapabilityTypePhoneCall completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager *systemCapabilityManager) {
            SDLPhoneCapability *phoneCapability = systemCapabilityManager.phoneCapability;
            if (phoneCapability.dialNumberEnabled) {
                SDLLogD(@"Dialing number");
                [self.class sdlex_sendDialNumberWithManager:manager];
            } else {
                SDLAlert* alert = [[SDLAlert alloc] init];
                alert.alertText1 = @"The dial number feature is unavailable for this head unit";
                [manager sendRequest:alert];
            }
        }];
    };

    return dialNumberCommand;
}

+ (SDLSpeak *)sdlex_appNameSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:@"S D L Example App"];

    return speak;
}

+ (SDLSpeak *)sdlex_goodJobSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:@"Good Job"];
    
    return speak;
}

+ (SDLSpeak *)sdlex_youMissedItSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:@"You missed it"];

    return speak;
}

+ (SDLCreateInteractionChoiceSet *)sdlex_createOnlyChoiceInteractionSet {
    SDLCreateInteractionChoiceSet *createInteractionSet = [[SDLCreateInteractionChoiceSet alloc] init];
    createInteractionSet.interactionChoiceSetID = @0;
    
    NSString *theOnlyChoiceName = @"The Only Choice";
    SDLChoice *theOnlyChoice = [[SDLChoice alloc] init];
    theOnlyChoice.choiceID = @0;
    theOnlyChoice.menuName = theOnlyChoiceName;
    theOnlyChoice.vrCommands = @[theOnlyChoiceName];
    
    createInteractionSet.choiceSet = @[theOnlyChoice];
    
    return createInteractionSet;
}

+ (void)sdlex_sendPerformOnlyChoiceInteractionWithManager:(SDLManager *)manager {
    SDLPerformInteraction *performOnlyChoiceInteraction = [[SDLPerformInteraction alloc] init];
    performOnlyChoiceInteraction.initialText = @"Choose the only one! You have 5 seconds...";
    performOnlyChoiceInteraction.initialPrompt = [SDLTTSChunk textChunksFromString:@"Choose it"];
    performOnlyChoiceInteraction.interactionMode = SDLInteractionModeBoth;
    performOnlyChoiceInteraction.interactionChoiceSetIDList = @[@0];
    performOnlyChoiceInteraction.helpPrompt = [SDLTTSChunk textChunksFromString:@"Do it"];
    performOnlyChoiceInteraction.timeoutPrompt = [SDLTTSChunk textChunksFromString:@"Too late"];
    performOnlyChoiceInteraction.timeout = @5000;
    performOnlyChoiceInteraction.interactionLayout = SDLLayoutModeListOnly;
    
    [manager sendRequest:performOnlyChoiceInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLPerformInteractionResponse * _Nullable response, NSError * _Nullable error) {
        SDLLogD(@"Perform Interaction fired");
        if ((response == nil) || (error != nil)) {
            SDLLogE(@"Something went wrong, no perform interaction response: %@", error);
        }
        
        if ([response.choiceID isEqualToNumber:@0]) {
            [manager sendRequest:[self sdlex_goodJobSpeak]];
        } else {
            [manager sendRequest:[self sdlex_youMissedItSpeak]];
        }
    }];
}

- (NSArray<SDLSoftButtonObject *> *)sdlex_softButtons {
    SDLSoftButtonState *starImageState = [[SDLSoftButtonState alloc] initWithStateName:@"imageState" text:@"Press" image:[UIImage imageNamed:@"star_softbutton_icon"]];
    SDLSoftButtonState *starTextState = [[SDLSoftButtonState alloc] initWithStateName:@"textState" text:@"Press" image:nil];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *starButton = [[SDLSoftButtonObject alloc] initWithName:@"StarButton" states:@[starImageState, starTextState] initialStateName:@"imageState" handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) {
            return;
        }

        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = @"You pushed the soft button!";
        [weakself.sdlManager sendRequest:alert];

        SDLLogD(@"Star icon soft button press fired");
    }];

    SDLSoftButtonState *hexImageOnState = [[SDLSoftButtonState alloc] initWithStateName:@"imageOnState" text:nil image:[UIImage imageNamed:@"hexagon_on_softbutton_icon"]];
    SDLSoftButtonState *hexImageOffState = [[SDLSoftButtonState alloc] initWithStateName:@"imageOffState" text:nil image:[UIImage imageNamed:@"hexagon_off_softbutton_icon"]];
    SDLSoftButtonState *hexTextOnState = [[SDLSoftButtonState alloc] initWithStateName:@"textOnState" text:@"➖Hex" image:nil];
    SDLSoftButtonState *hexTextOffState = [[SDLSoftButtonState alloc] initWithStateName:@"textOffState" text:@"➕Hex" image:nil];
    SDLSoftButtonObject *hexButton = [[SDLSoftButtonObject alloc] initWithName:@"HexagonButton" states:@[hexImageOnState, hexImageOffState, hexTextOnState, hexTextOffState] initialStateName:hexImageOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        weakself.hexagonEnabled = !weakself.hexagonEnabled;
        SDLLogD(@"Hexagon icon button press fired %d", self.hexagonEnabled);
    }];

    SDLSoftButtonState *textOnState = [[SDLSoftButtonState alloc] initWithStateName:@"onState" text:@"➖Text" image:nil];
    SDLSoftButtonState *textOffState = [[SDLSoftButtonState alloc] initWithStateName:@"offState" text:@"➕Text" image:nil];
    SDLSoftButtonObject *textButton = [[SDLSoftButtonObject alloc] initWithName:@"TextButton" states:@[textOnState, textOffState] initialStateName:@"onState" handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) {
            return;
        }

        weakself.textEnabled = !weakself.textEnabled;
        SDLSoftButtonObject *object = [weakself.sdlManager.screenManager softButtonObjectNamed:@"TextButton"];
        [object transitionToNextState];

        SDLLogD(@"Text visibility soft button press fired %d", weakself.textEnabled);
    }];

    SDLSoftButtonState *imagesOnState = [[SDLSoftButtonState alloc] initWithStateName:@"onState" text:@"➖Icons" image:nil];
    SDLSoftButtonState *imagesOffState = [[SDLSoftButtonState alloc] initWithStateName:@"offState" text:@"➕Icons" image:nil];
    SDLSoftButtonObject *imagesButton = [[SDLSoftButtonObject alloc] initWithName:@"ImagesButton" states:@[imagesOnState, imagesOffState] initialStateName:@"onState" handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) {
            return;
        }

        weakself.imagesEnabled = !weakself.imagesEnabled;

        SDLSoftButtonObject *object = [weakself.sdlManager.screenManager softButtonObjectNamed:@"ImagesButton"];
        [object transitionToNextState];

        SDLLogD(@"Image visibility soft button press fired %d", weakself.imagesEnabled);
    }];

    return @[starButton, hexButton, textButton, imagesButton];
}

+ (void)sdlex_sendGetVehicleDataWithManager:(SDLManager *)manager {
    SDLGetVehicleData *getVehicleData = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES vin:YES wiperStatus:YES];

    [manager sendRequest:getVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLLogD(@"vehicle data response: %@", response);
    }];
}

+ (void)sdlex_sendDialNumberWithManager:(SDLManager *)manager {
    SDLDialNumber *dialNumber = [[SDLDialNumber alloc] initWithNumber:@"5555555555"];
    [manager sendRequest:dialNumber withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLLogD(@"Dial number response: %@", response);
    }];
}

- (void)sdlex_prepareRemoteSystem {
    [self.sdlManager sendRequests:@[[self.class sdlex_speakNameCommandWithManager:self.sdlManager], [self.class sdlex_interactionSetCommandWithManager:self.sdlManager], [self.class sdlex_vehicleDataCommandWithManager:self.sdlManager], [self.class sdlex_dialNumberCommandWithManager:self.sdlManager], [self.class sdlex_createOnlyChoiceInteractionSet]]
                  progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                      SDLLogD(@"Commands sent updated, percent complete %f%%", percentComplete * 100);
                  } completionHandler:nil];
}


#pragma mark - SDLManagerDelegate

- (void)managerDidDisconnect {
    // Reset our state
    self.firstTimeState = SDLHMIFirstStateNone;
    [self sdlex_updateProxyState:ProxyStateStopped];
    if (ShouldRestartOnDisconnect) {
        [self startManager];
    }
}

- (void)hmiLevel:(SDLHMILevel)oldLevel didChangeToLevel:(SDLHMILevel)newLevel {
    if (![newLevel isEqualToEnum:SDLHMILevelNone] && (self.firstTimeState == SDLHMIFirstStateNone)) {
        // This is our first time in a non-NONE state
        self.firstTimeState = SDLHMIFirstStateNonNone;
        
        // Send AddCommands
        [self sdlex_prepareRemoteSystem];
    }
    
    if ([newLevel isEqualToEnum:SDLHMILevelFull] && (self.firstTimeState != SDLHMIFirstStateFull)) {
        // This is our first time in a FULL state
        self.firstTimeState = SDLHMIFirstStateFull;
    }
    
    if ([newLevel isEqualToEnum:SDLHMILevelFull]) {
        // We're always going to try to show the initial state, because if we've already shown it, it won't be shown, and we need to guard against some possible weird states
        [self sdlex_showInitialData];
    }
}

- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language {
    SDLLifecycleConfigurationUpdate *update = [[SDLLifecycleConfigurationUpdate alloc] init];

    if ([language isEqualToEnum:SDLLanguageEnUs]) {
        update.appName = SDLAppName;
    } else if ([language isEqualToString:SDLLanguageEsMx]) {
        NSString *SDLAppNameSpanish = @"SDL Aplicación de ejemplo";
        update.appName = SDLAppNameSpanish;
    } else if ([language isEqualToString:SDLLanguageFrCa]) {
        NSString *SDLAppNameFrench = @"SDL Exemple App";
        update.appName = SDLAppNameFrench;
    } else {
        return nil;
    }

    update.ttsName = [SDLTTSChunk textChunksFromString:update.appName];
    return update;
}

@end

NS_ASSUME_NONNULL_END
