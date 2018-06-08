//
//  ProxyManager.m
//  SmartDeviceLink-iOS

#import "AppConstants.h"
#import "AlertManager.h"
#import "ButtonManager.h"
#import "MenuManager.h"
#import "PerformInteractionManager.h"
#import "Preferences.h"
#import "ProxyManager.h"
#import "RPCPermissionsManager.h"
#import "SmartDeviceLink.h"
#import "VehicleDataManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface ProxyManager () <SDLManagerDelegate>

// Describes the first time the HMI state goes non-none and full.
@property (assign, nonatomic) SDLHMILevel firstHMILevel;

@property (strong, nonatomic) VehicleDataManager *vehicleDataManager;
@property (strong, nonatomic) ButtonManager *buttonManager;
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

- (void)startWithProxyTransportType:(ProxyTransportType)proxyTransportType {
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];

    // Check for previous instance of sdlManager
    if (self.sdlManager) { return; }

    SDLLifecycleConfiguration *lifecycleConfig = proxyTransportType == ProxyTransportTypeIAP ? [self.class sdlex_iapLifecycleConfiguration] : [self.class sdlex_tcpLifecycleConfiguration];
    [self sdlex_setupConfigurationWithLifecycleConfiguration:lifecycleConfig];
}

+ (SDLLifecycleConfiguration *)sdlex_iapLifecycleConfiguration {
    return [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration defaultConfigurationWithAppName:ExampleAppName appId:ExampleAppId]];
}

+ (SDLLifecycleConfiguration *)sdlex_tcpLifecycleConfiguration {
    return [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration debugConfigurationWithAppName:ExampleAppName appId:ExampleAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port]];
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
    SDLLogFileModule *sdlExampleModule = [SDLLogFileModule moduleWithName:@"SDL Obj-C Example App" files:[NSSet setWithArray:@[@"ProxyManager", @"AlertManager", @"AudioManager", @"ButtonManager", @"MenuManager", @"PerformInteractionManager", @"RPCPermissionsManager", @"VehicleDataManager"]]];
    logConfig.modules = [logConfig.modules setByAddingObject:sdlExampleModule];
    logConfig.targets = [logConfig.targets setByAddingObject:[SDLLogTargetFile logger]];
    logConfig.globalLogLevel = SDLLogLevelDebug;

    return logConfig;
}

#pragma mark - Screen UI Helpers

- (void)sdlex_createMenus {
    [self.sdlManager sendRequest:[PerformInteractionManager createInteractionChoiceSet]];
    self.sdlManager.screenManager.menu = [MenuManager allMenuItemsWithManager:self.sdlManager];
    self.sdlManager.screenManager.voiceCommands = [MenuManager allVoiceMenuItemsWithManager:self.sdlManager];
}

- (void)sdlex_showInitialData {
    if (![self.sdlManager.hmiLevel isEqualToEnum:SDLHMILevelFull]) { return; }

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
        // The SDL app is in the foreground
        SDLLogD(@"The HMI level is full");
    } else if ([newLevel isEqualToEnum:SDLHMILevelLimited]) {
        // An active NAV or MEDIA SDL app is in the background
        SDLLogD(@"The HMI level is limited");
    } else if ([newLevel isEqualToEnum:SDLHMILevelBackground]) {
        // The SDL app is not in the foreground
        SDLLogD(@"The HMI level is background");
    } else if ([newLevel isEqualToEnum:SDLHMILevelNone]) {
        // The SDL app is not yet running
        SDLLogD(@"The HMI level is none");
    }
    
    if ([newLevel isEqualToEnum:SDLHMILevelFull]) {
        // We're always going to try to show the initial state. because if we've already shown it, it won't be shown, and we need to guard against some possible weird states
        [self sdlex_showInitialData];
    }
}

- (void)systemContext:(nullable SDLSystemContext)oldContext didChangeToContext:(SDLSystemContext)newContext {
    if ([newContext isEqualToEnum:SDLSystemContextAlert]) {
        SDLLogD(@"The System Context is Alert");
    } else if ([newContext isEqualToEnum:SDLSystemContextHMIObscured]) {
        SDLLogD(@"The System Context is HMI Obscured");
    } else if ([newContext isEqualToEnum:SDLSystemContextMain]) {
        SDLLogD(@"The System Context is Main");
    } else if ([newContext isEqualToEnum:SDLSystemContextMenu]) {
        SDLLogD(@"The System Context is Menu");
    } else if ([newContext isEqualToEnum:SDLSystemContextVoiceRecognitionSession]) {
        SDLLogD(@"The System Context is Voice Recognition Session");
    }
}

- (void)audioStreamingState:(nullable SDLAudioStreamingState)oldState didChangeToState:(SDLAudioStreamingState)newState {
    if ([newState isEqualToEnum:SDLAudioStreamingStateAudible]) {
        // The SDL app's audio can be heard
        SDLLogD(@"The Audio Streaming State is Audible");
    } else if ([newState isEqualToEnum:SDLAudioStreamingStateNotAudible]) {
        // The SDL app's audio cannot be heard
        SDLLogD(@"The Audio Streaming State is Not Audible");
    } else if ([newState isEqualToEnum:SDLAudioStreamingStateAttenuated]) {
        // The SDL app's audio volume has been lowered to let the system speak over the audio. This usually happens with voice recognition commands.
        SDLLogD(@"The Audio Streaming State is Not Attenuated");
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
