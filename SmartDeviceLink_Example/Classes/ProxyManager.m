//
//  ProxyManager.m
//  SmartDeviceLink-iOS

#import "AppConstants.h"
#import "AlertManager.h"
#import "AudioManager.h"
#import "ButtonManager.h"
#import "Preferences.h"
#import "ProxyManager.h"
#import "RPCPermissionsManager.h"
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

@property (strong, nonatomic) VehicleDataManager *vehicleDataManager;
@property (strong, nonatomic) ButtonManager *buttonManager;
@property (strong, nonatomic) AudioManager *audioManager;
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

    return self;
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
        self.buttonManager = [[ButtonManager alloc] initWithManager:self.sdlManager refreshUIHandler:self.refreshUIHandler];
        self.audioManager = [[AudioManager alloc] initWithManager:self.sdlManager];

        [weakSelf sdlex_updateProxyState:ProxyStateConnected];
        [RPCPermissionsManager setupPermissionsCallbacksWithManager:weakSelf.sdlManager];
        [weakSelf sdlex_showInitialData];

        SDLLogD(@"SDL file manager storage: %lu mb", self.sdlManager.fileManager.bytesAvailable / 1024 / 1024);
    }];
}

- (void)reset {
    if (self.sdlManager == nil) {
        [self sdlex_updateProxyState:ProxyStateStopped];
        return;
    }

    [self.sdlManager stop];
}

- (void)sdlex_updateProxyState:(ProxyState)newState {
    if (self.state != newState) {
        [self willChangeValueForKey:@"state"];
        _state = newState;
        [self didChangeValueForKey:@"state"];
    }
}

#pragma mark - SDL Configuration

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
    SDLLogFileModule *sdlExampleModule = [SDLLogFileModule moduleWithName:@"SDL Obj-C Example App" files:[NSSet setWithArray:@[@"ProxyManager", @"AudioManager", @"VehicleDataManager", @"AlertManager", @"RPCPermissionsManager", @"ButtonManager"]]];
    logConfig.modules = [logConfig.modules setByAddingObject:sdlExampleModule];
    logConfig.targets = [logConfig.targets setByAddingObject:[SDLLogTargetFile logger]];
    logConfig.globalLogLevel = SDLLogLevelVerbose;

    return logConfig;
}

#pragma mark - Screen UI Helpers

- (void)sdlex_createMenus {
    [self.sdlManager sendRequest:[self.class sdlex_createChoiceInteractionSet]];
    [self sdlex_createMenu];
    [self sdlex_createVoiceCommands];
}

- (void)sdlex_showInitialData {
    if (![self.sdlManager.hmiLevel isEqualToEnum:SDLHMILevelFull]) {
        return;
    }

    [self sdlex_updateScreen];
    self.sdlManager.screenManager.softButtonObjects = [self.buttonManager allScreenSoftButtons];
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
    if (![self.sdlManager.hmiLevel isEqualToEnum:SDLHMILevelFull]) { return; }

    SDLScreenManager *screenManager = self.sdlManager.screenManager;
    BOOL isTextEnabled = self.buttonManager.isTextEnabled;
    BOOL areImagesVisible = self.buttonManager.areImagesEnabled;

    [screenManager beginUpdates];
    screenManager.textAlignment = SDLTextAlignmentLeft;
    screenManager.textField1 = isTextEnabled ? SmartDeviceLinkText : nil;
    screenManager.textField2 = isTextEnabled ? [NSString stringWithFormat:@"Obj-C %@", ExampleAppText] : nil;
    screenManager.textField3 = isTextEnabled ? self.vehicleDataManager.vehicleOdometerData : nil;

    if (self.sdlManager.systemCapabilityManager.displayCapabilities.graphicSupported) {
        screenManager.primaryGraphic = areImagesVisible ? [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:@"sdl_logo_green"] asImageFormat:SDLArtworkImageFormatPNG] : nil;
    }

    [screenManager endUpdatesWithCompletionHandler:^(NSError * _Nullable error) {
        SDLLogD(@"Updated text and graphics, error? %@", error);
    }];
}

#pragma mark - RPC builders

#pragma mark Perform Interaction Choice Sets
static UInt32 choiceSetId = 100;

+ (NSArray<SDLChoice *> *)sdlex_createChoiceSet {
    SDLChoice *firstChoice = [[SDLChoice alloc] initWithId:1 menuName:PICSFirstChoice vrCommands:@[PICSFirstChoice]];
    SDLChoice *secondChoice = [[SDLChoice alloc] initWithId:2 menuName:PICSSecondChoice vrCommands:@[PICSSecondChoice]];
    SDLChoice *thirdChoice = [[SDLChoice alloc] initWithId:3 menuName:PICSThirdChoice vrCommands:@[PICSThirdChoice]];
    return @[firstChoice, secondChoice, thirdChoice];
}

+ (SDLPerformInteraction *)sdlex_createPerformInteraction {
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] initWithInitialPrompt:PICSInitialPrompt initialText:PICSInitialText interactionChoiceSetIDList:@[@(choiceSetId)] helpPrompt:PICSHelpPrompt timeoutPrompt:PICSTimeoutPrompt interactionMode:SDLInteractionModeBoth timeout:10000];
    performInteraction.interactionLayout = SDLLayoutModeListOnly;
    return performInteraction;
}

+ (void)sdlex_showPerformInteractionChoiceSetWithManager:(SDLManager *)manager {
    [manager sendRequest:[self sdlex_createPerformInteraction] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (response.resultCode != SDLResultSuccess) {
            SDLLogE(@"The Show Perform Interaction Choice Set request failed: %@", error.localizedDescription);
            return;
        }

        if ([response.resultCode isEqualToEnum:SDLResultTimedOut]) {
            SDLLogD(@"The perform interaction choice set menu timed out before the user could select an item");
            [manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSYouMissed]];
        } else if ([response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogD(@"The user selected an item in the perform interaction choice set menu");
            [manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSGoodJob]];
        }
    }];
}

+ (SDLCreateInteractionChoiceSet *)sdlex_createChoiceInteractionSet {
    return [[SDLCreateInteractionChoiceSet alloc] initWithId:choiceSetId choiceSet:[self sdlex_createChoiceSet]];
}

#pragma mark Menu

- (void)sdlex_createMenu {
    __weak typeof(self) weakself = self;
    SDLMenuCell *speakCell = [[SDLMenuCell alloc] initWithTitle:ACSpeakAppNameMenuName icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:SpeakBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACSpeakAppNameMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [weakself.sdlManager sendRequest:[[SDLSpeak alloc] initWithTTS:ExampleAppNameTTS]];
    }];

    SDLMenuCell *interactionSetCell = [[SDLMenuCell alloc] initWithTitle:ACShowChoiceSetMenuName icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:MenuBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACShowChoiceSetMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [ProxyManager sdlex_showPerformInteractionChoiceSetWithManager:weakself.sdlManager];
    }];

    SDLMenuCell *getVehicleDataCell = [[SDLMenuCell alloc] initWithTitle:ACGetVehicleDataMenuName icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:CarBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACGetVehicleDataMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [VehicleDataManager getVehicleSpeedWithManager:weakself.sdlManager];
    }];

    SDLMenuCell *recordInCarMicrophoneAudio = [[SDLMenuCell alloc] initWithTitle:ACRecordInCarMicrophoneAudioMenuName icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:MicrophoneBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACRecordInCarMicrophoneAudioMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [self.audioManager startRecording];
    }];

    SDLMenuCell *dialPhoneNumber = [[SDLMenuCell alloc] initWithTitle:ACDialPhoneNumberMenuName icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:PhoneBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACDialPhoneNumberMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        if (![RPCPermissionsManager isDialNumberRPCAllowedWithManager:self.sdlManager]) {
            [self.sdlManager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"This app does not have the required permissions to dial a number" textField2:nil]];
            return;
        }

        [VehicleDataManager checkPhoneCallCapabilityWithManager:self.sdlManager phoneNumber:@"555-555-5555"];
    }];

    NSMutableArray *submenuItems = [NSMutableArray array];
    for (int i = 0; i < 75; i++) {
        SDLMenuCell *cell = [[SDLMenuCell alloc] initWithTitle:[NSString stringWithFormat:@"%@ %i", ACSubmenuItemMenuName, i] icon:[SDLArtwork artworkWithImage:[UIImage imageNamed:MenuBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
            [self.sdlManager sendRequest:[AlertManager alertWithMessageAndCloseButton:[NSString stringWithFormat:@"You selected %@ %i", ACSubmenuItemMenuName, i] textField2:nil]];
        }];
        [submenuItems addObject:cell];
    }
    SDLMenuCell *submenuCell = [[SDLMenuCell alloc] initWithTitle:ACSubmenuMenuName subCells:[submenuItems copy]];

    self.sdlManager.screenManager.menu = @[speakCell, getVehicleDataCell, interactionSetCell, recordInCarMicrophoneAudio, dialPhoneNumber, submenuCell];
}

#pragma mark Voice Commands

- (void)sdlex_createVoiceCommands {
    if (!self.sdlManager.systemCapabilityManager.vrCapability) {
        SDLLogE(@"The head unit does not support voice recognition");
        return;
    }
    self.sdlManager.screenManager.voiceCommands = @[[self.class sdlex_voiceCommandStartWithManager:self.sdlManager], [self.class sdlex_voiceCommandStopWithManager:self.sdlManager]];
}

+ (SDLVoiceCommand *)sdlex_voiceCommandStartWithManager:(SDLManager *)manager {
    return [[SDLVoiceCommand alloc] initWithVoiceCommands:@[VCStop] handler:^{
        [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:[NSString stringWithFormat:@"%@ voice command selected!", VCStop] textField2:nil]];
    }];
}

+ (SDLVoiceCommand *)sdlex_voiceCommandStopWithManager:(SDLManager *)manager {
    return [[SDLVoiceCommand alloc] initWithVoiceCommands:@[VCStart] handler:^{
        [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:[NSString stringWithFormat:@"%@ voice command selected!", VCStart] textField2:nil]];
    }];
}

#pragma mark - SDLManagerDelegate

- (void)managerDidDisconnect {
    [self sdlex_updateProxyState:ProxyStateStopped];
    self.firstHMILevel = SDLHMILevelNone;

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
        [self sdlex_createMenus];
        [self.vehicleDataManager subscribeToVehicleOdometer];
    }

    if ([newLevel isEqualToEnum:SDLHMILevelFull]) {
        SDLLogD(@"The HMI level is full");
    } else if ([newLevel isEqualToEnum:SDLHMILevelLimited]) {
        SDLLogD(@"The HMI level is limited");
    } else if ([newLevel isEqualToEnum:SDLHMILevelBackground]) {
        SDLLogD(@"The HMI level is background");
    } else if ([newLevel isEqualToEnum:SDLHMILevelNone]) {
        SDLLogD(@"The HMI level is none");
    }
    
    if ([newLevel isEqualToEnum:SDLHMILevelFull]) {
        // We're always going to try to show the initial state. because if we've already shown it, it won't be shown, and we need to guard against some possible weird states
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
