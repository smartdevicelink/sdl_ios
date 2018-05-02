//
//  ProxyManager.m
//  SmartDeviceLink-iOS

#import "AppConstants.h"
#import "AudioManager.h"
#import "Preferences.h"
#import "ProxyManager.h"
#import "SmartDeviceLink.h"
#import "VehicleDataManager.h"


typedef NS_ENUM(NSUInteger, SDLHMIFirstState) {
    SDLHMIFirstStateNone,
    SDLHMIFirstStateNonNone,
    SDLHMIFirstStateFull
};


NS_ASSUME_NONNULL_BEGIN

@interface ProxyManager () <SDLManagerDelegate>

// Describes the first time the HMI state goes non-none and full.
@property (assign, nonatomic) SDLHMILevel firstHMILevel;

@property (assign, nonatomic, getter=isTextEnabled) BOOL textEnabled;
@property (assign, nonatomic, getter=isHexagonEnabled) BOOL toggleEnabled;
@property (assign, nonatomic, getter=areImagesEnabled) BOOL imagesEnabled;

@property (strong, nonatomic) VehicleDataManager *vehicleDataManager;
@property (nonatomic, copy, nullable) RefreshUIHandler refreshUIHandler;
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
    if (!self) {
        return nil;
    }

    _state = ProxyStateStopped;
    _firstHMILevel = SDLHMILevelNone;

    _textEnabled = YES;
    _toggleEnabled = YES;
    _imagesEnabled = YES;

    return self;
}

- (void)startIAP {
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    // Check for previous instance of sdlManager
    if (self.sdlManager) { return; }
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration defaultConfigurationWithAppName:ExampleAppName appId:ExampleAppId]];
    [self sdlex_setupConfigurationWithLifecycleConfiguration:lifecycleConfig];
}

- (void)startTCP {
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    // Check for previous instance of sdlManager
    if (self.sdlManager) { return; }
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration debugConfigurationWithAppName:ExampleAppName appId:ExampleAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port]];
    [self sdlex_setupConfigurationWithLifecycleConfiguration:lifecycleConfig];
}

- (void)sdlex_setupConfigurationWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfiguration lockScreen:[SDLLockScreenConfiguration enabledConfigurationWithAppIcon:[UIImage imageNamed:ExampleAppLogoName] backgroundColor:nil] logging:[self.class sdlex_logConfiguration]];
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

        self.vehicleDataManager = [[VehicleDataManager alloc] initWithManager:self.sdlManager refreshUIHandler:self.refreshUIHandler];

        [weakSelf sdlex_updateProxyState:ProxyStateConnected];
        [weakSelf sdlex_setupPermissionsCallbacks];
        [weakSelf sdlex_showInitialData];
    }];
}

- (void)reset {
    if (self.sdlManager == nil) {
        [self sdlex_updateProxyState:ProxyStateStopped];
        return;
    }

    [self.sdlManager stop];
}


#pragma mark - Helpers

- (void)sdlex_showInitialData {
    if (![self.sdlManager.hmiLevel isEqualToEnum:SDLHMILevelFull]) {
        return;
    }

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
    [self setToggleSoftButtonIcon:self.isHexagonEnabled imagesEnabled:imagesEnabled];
    [self setAlertSoftButtonIcon];
}

- (void)setToggleEnabled:(BOOL)hexagonEnabled {
    _toggleEnabled = hexagonEnabled;
    [self setToggleSoftButtonIcon:hexagonEnabled imagesEnabled:self.areImagesEnabled];
}

- (void)setToggleSoftButtonIcon:(BOOL)toggleEnabled imagesEnabled:(BOOL)imagesEnabled {
    SDLSoftButtonObject *object = [self.sdlManager.screenManager softButtonObjectNamed:ToggleSoftButton];
    imagesEnabled ? [object transitionToStateNamed:(toggleEnabled ? ToggleSoftButtonImageOnState : ToggleSoftButtonImageOffState)] : [object transitionToStateNamed:(toggleEnabled ? ToggleSoftButtonTextOnState : ToggleSoftButtonTextOffState)];
}

- (void)setAlertSoftButtonIcon {
    SDLSoftButtonObject *object = [self.sdlManager.screenManager softButtonObjectNamed:AlertSoftButton];
    [object transitionToNextState];
}

- (nullable RefreshUIHandler)refreshUIHandler {
    if(!_refreshUIHandler) {
        __weak typeof(self) weakSelf = self;
        weakSelf.refreshUIHandler = ^{
            [weakSelf sdlex_updateScreen];
        };
    }

    return _refreshUIHandler;
}

- (void)sdlex_updateScreen {
    SDLScreenManager *screenManager = self.sdlManager.screenManager;

    [screenManager beginUpdates];
    screenManager.textAlignment = SDLTextAlignmentLeft;
    screenManager.textField1 = self.isTextEnabled ? SmartDeviceLinkText : nil;
    screenManager.textField2 = self.isTextEnabled ? [NSString stringWithFormat:@"Obj-C %@", ExampleAppText] : nil;
    screenManager.textField3 = self.isTextEnabled ? self.vehicleDataManager.vehicleOdometerData : nil;

    if (self.sdlManager.systemCapabilityManager.displayCapabilities.graphicSupported) {
        screenManager.primaryGraphic = self.areImagesEnabled ? [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:@"sdl_logo_green"] asImageFormat:SDLArtworkImageFormatPNG] : nil;
    }

    [screenManager endUpdatesWithCompletionHandler:^(NSError * _Nullable error) {
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
    SDLArtwork *appIconArt = [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:ExampleAppLogoName] asImageFormat:SDLArtworkImageFormatPNG];

    config.shortAppName = ExampleAppNameShort;
    config.appIcon = appIconArt;
    config.voiceRecognitionCommandNames = @[ExampleAppNameTTS];
    config.ttsName = [SDLTTSChunk textChunksFromString:ExampleAppName];
    config.language = SDLLanguageEnUs;
    config.languagesSupported = @[SDLLanguageEnUs, SDLLanguageFrCa, SDLLanguageEsMx];

    return config;
}

+ (SDLLogConfiguration *)sdlex_logConfiguration {
    SDLLogConfiguration *logConfig = [SDLLogConfiguration debugConfiguration];
    SDLLogFileModule *sdlExampleModule = [SDLLogFileModule moduleWithName:@"SDL Example" files:[NSSet setWithArray:@[@"ProxyManager"]]];
    logConfig.modules = [logConfig.modules setByAddingObject:sdlExampleModule];
    logConfig.targets = [logConfig.targets setByAddingObject:[SDLLogTargetFile logger]];
    // logConfig.filters = [logConfig.filters setByAddingObject:[SDLLogFilter filterByAllowingModules:[NSSet setWithObject:@"Transport"]]];
    logConfig.globalLogLevel = SDLLogLevelDebug;

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

+ (SDLSpeak *)sdlex_appNameSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:ExampleAppNameTTS];

    return speak;
}

+ (SDLSpeak *)sdlex_goodJobSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:TTSGoodJob];
    
    return speak;
}

+ (SDLSpeak *)sdlex_youMissedItSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:TTSYouMissed];

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
    SDLSoftButtonState *alertImageAndTextState = [[SDLSoftButtonState alloc] initWithStateName:AlertSoftButtonImageState text:AlertSoftButtonText image:[UIImage imageNamed:CarIconImageName]];
    SDLSoftButtonState *alertTextState = [[SDLSoftButtonState alloc] initWithStateName:AlertSoftButtonTextState text:AlertSoftButtonText image:nil];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *alertSoftButton = [[SDLSoftButtonObject alloc] initWithName:AlertSoftButton states:@[alertImageAndTextState, alertTextState] initialStateName:alertImageAndTextState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = @"You pushed the soft button!";
        [weakself.sdlManager sendRequest:alert];

        SDLLogD(@"Star icon soft button press fired");
    }];

    SDLSoftButtonState *toggleImageOnState = [[SDLSoftButtonState alloc] initWithStateName:ToggleSoftButtonImageOnState text:nil image:[UIImage imageNamed:WheelIconImageName]];
    SDLSoftButtonState *toggleImageOffState = [[SDLSoftButtonState alloc] initWithStateName:ToggleSoftButtonImageOffState text:nil image:[UIImage imageNamed:LaptopIconImageName]];
    SDLSoftButtonState *toggleTextOnState = [[SDLSoftButtonState alloc] initWithStateName:ToggleSoftButtonTextOnState text:ToggleSoftButtonTextTextOnText image:nil];
    SDLSoftButtonState *toggleTextOffState = [[SDLSoftButtonState alloc] initWithStateName:ToggleSoftButtonTextOffState text:ToggleSoftButtonTextTextOffText image:nil];
    SDLSoftButtonObject *toggleButton = [[SDLSoftButtonObject alloc] initWithName:ToggleSoftButton states:@[toggleImageOnState, toggleImageOffState, toggleTextOnState, toggleTextOffState] initialStateName:toggleImageOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        weakself.toggleEnabled = !weakself.toggleEnabled;
        SDLLogD(@"Toggle icon button press fired %d", self.toggleEnabled);
    }];

    SDLSoftButtonState *textOnState = [[SDLSoftButtonState alloc] initWithStateName:TextVisibleSoftButtonTextOnState text:TextVisibleSoftButtonTextOnText image:nil];
    SDLSoftButtonState *textOffState = [[SDLSoftButtonState alloc] initWithStateName:TextVisibleSoftButtonTextOffState text:TextVisibleSoftButtonTextOffText image:nil];
    SDLSoftButtonObject *textButton = [[SDLSoftButtonObject alloc] initWithName:TextVisibleSoftButton states:@[textOnState, textOffState] initialStateName:textOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        weakself.textEnabled = !weakself.textEnabled;
        SDLSoftButtonObject *object = [weakself.sdlManager.screenManager softButtonObjectNamed:TextVisibleSoftButton];
        [object transitionToNextState];

        SDLLogD(@"Text visibility soft button press fired %d", weakself.textEnabled);
    }];

    SDLSoftButtonState *imagesOnState = [[SDLSoftButtonState alloc] initWithStateName:ImagesVisibleSoftButtonImageOnState text:ImagesVisibleSoftButtonImageOnText image:nil];
    SDLSoftButtonState *imagesOffState = [[SDLSoftButtonState alloc] initWithStateName:ImagesVisibleSoftButtonImageOffState text:ImagesVisibleSoftButtonImageOffText image:nil];
    SDLSoftButtonObject *imagesButton = [[SDLSoftButtonObject alloc] initWithName:ImagesVisibleSoftButton states:@[imagesOnState, imagesOffState] initialStateName:imagesOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) {
            return;
        }

        weakself.imagesEnabled = !weakself.imagesEnabled;

        SDLSoftButtonObject *object = [weakself.sdlManager.screenManager softButtonObjectNamed:ImagesVisibleSoftButton];
        [object transitionToNextState];

        SDLLogD(@"Image visibility soft button press fired %d", weakself.imagesEnabled);
    }];

    return @[alertSoftButton, toggleButton, textButton, imagesButton];
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
    SDLCreateInteractionChoiceSet *choiceSet = [self.class sdlex_createOnlyChoiceInteractionSet];
    [self.sdlManager sendRequest:choiceSet];

    __weak typeof(self) weakself = self;
    SDLMenuCell *speakCell = [[SDLMenuCell alloc] initWithTitle:@"Speak" icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:@"speak"] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[@"Speak"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [weakself.sdlManager sendRequest:[ProxyManager sdlex_appNameSpeak]];
    }];

    SDLMenuCell *interactionSetCell = [[SDLMenuCell alloc] initWithTitle:@"Perform Interaction" icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:@"choice_set"] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[@"Perform Interaction"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [ProxyManager sdlex_sendPerformOnlyChoiceInteractionWithManager:weakself.sdlManager];
    }];

    SDLMenuCell *getVehicleDataCell = [[SDLMenuCell alloc] initWithTitle:@"Get Vehicle Data" icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:@"car"] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[@"Get Vehicle Data"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [ProxyManager sdlex_sendGetVehicleDataWithManager:weakself.sdlManager];
    }];

    NSMutableArray *menuArray = [NSMutableArray array];
    for (int i = 0; i < 75; i++) {
        SDLMenuCell *cell = [[SDLMenuCell alloc] initWithTitle:[NSString stringWithFormat:@"%i", i] icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:@"hexagon_on_softbutton_icon"] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource){}];
        [menuArray addObject:cell];
    }

    SDLMenuCell *submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Submenu" subCells:[menuArray copy]];

    SDLVoiceCommand *voiceCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test"] handler:^{
        [ProxyManager sdlex_sendPerformOnlyChoiceInteractionWithManager:weakself.sdlManager];
    }];

    self.sdlManager.screenManager.menu = @[speakCell, interactionSetCell, getVehicleDataCell, submenuCell];
    self.sdlManager.screenManager.voiceCommands = @[voiceCommand];
}


#pragma mark - SDLManagerDelegate

- (void)managerDidDisconnect {
    [self sdlex_updateProxyState:ProxyStateStopped];

    // Reset our state
    self.firstHMILevel = SDLHMILevelNone;
    [self.vehicleDataManager stopManager];

    // If desired, automatically start searching for a new connection to Core
    if (ExampleAppShouldRestartSDLManagerOnDisconnect) {
        [self startManager];
    }
}

- (void)hmiLevel:(SDLHMILevel)oldLevel didChangeToLevel:(SDLHMILevel)newLevel {
    if (![newLevel isEqualToEnum:SDLHMILevelNone] && ([self.firstHMILevel isEqualToEnum:SDLHMILevelNone])) {
        // This is our first time in a non-NONE state
        self.firstHMILevel = newLevel;
        
        // Send AddCommands
        [self sdlex_prepareRemoteSystem];
        [self.vehicleDataManager subscribeToVehicleOdometer];
    }

    if ([newLevel isEqualToEnum:SDLHMILevelFull]) {

    } else if ([newLevel isEqualToEnum:SDLHMILevelLimited]) {

    } else if ([newLevel isEqualToEnum:SDLHMILevelBackground]) {

    } else if ([newLevel isEqualToEnum:SDLHMILevelNone]) {

    }
    
    if ([newLevel isEqualToEnum:SDLHMILevelFull]) {
        // We're always going to try to show the initial state, because if we've already shown it, it won't be shown, and we need to guard against some possible weird states
        [self sdlex_showInitialData];
    }
}

- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language {
    SDLLifecycleConfigurationUpdate *update = [[SDLLifecycleConfigurationUpdate alloc] init];

    if ([language isEqualToEnum:SDLLanguageEnUs]) {
        update.appName = ExampleAppName;
    } else if ([language isEqualToString:SDLLanguageEsMx]) {
        update.appName = ExampleAppNameSpanish;
    } else if ([language isEqualToString:SDLLanguageFrCa]) {
        update.appName = ExampleAppNameFrench;
    } else {
        return nil;
    }

    update.ttsName = [SDLTTSChunk textChunksFromString:update.appName];
    return update;
}

@end

NS_ASSUME_NONNULL_END
