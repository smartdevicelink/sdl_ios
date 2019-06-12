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
@property (strong, nonatomic) PerformInteractionManager *performManager;
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

- (void)sdlex_startManager {
    __weak typeof (self) weakSelf = self;
    [self.sdlManager startWithReadyHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            SDLLogE(@"SDL errored starting up: %@", error);
            [weakSelf sdlex_updateProxyState:ProxyStateStopped];
            return;
        }

        self.vehicleDataManager = [[VehicleDataManager alloc] initWithManager:self.sdlManager refreshUIHandler:self.refreshUIHandler];
        self.performManager = [[PerformInteractionManager alloc] initWithManager:self.sdlManager];
        self.buttonManager = [[ButtonManager alloc] initWithManager:self.sdlManager refreshUIHandler:self.refreshUIHandler];

        [weakSelf sdlex_updateProxyState:ProxyStateConnected];
        [RPCPermissionsManager setupPermissionsCallbacksWithManager:weakSelf.sdlManager];
        [weakSelf sdlex_showInitialData];

        SDLLogD(@"SDL file manager storage: %lu mb", self.sdlManager.fileManager.bytesAvailable / 1024 / 1024);
    }];
}

- (void)stopConnection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sdlManager stop];
    });

    [self sdlex_updateProxyState:ProxyStateStopped];
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

    SDLLifecycleConfiguration *lifecycleConfig = proxyTransportType == ProxyTransportTypeIAP ? [self.class sdlex_iapLifecycleConfiguration] : [self.class sdlex_tcpLifecycleConfiguration];
    [self sdlex_setupConfigurationWithLifecycleConfiguration:lifecycleConfig];
}

+ (SDLLifecycleConfiguration *)sdlex_iapLifecycleConfiguration {
    return [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration defaultConfigurationWithAppName:ExampleAppName fullAppId:ExampleFullAppId]];
}

+ (SDLLifecycleConfiguration *)sdlex_tcpLifecycleConfiguration {
    return [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration debugConfigurationWithAppName:ExampleAppName fullAppId:ExampleFullAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port]];
}

- (void)sdlex_setupConfigurationWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    if (self.sdlManager != nil) {
        // Manager already created, just start it again.
        [self sdlex_startManager];
        return;
    }
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfiguration lockScreen:[SDLLockScreenConfiguration enabledConfigurationWithAppIcon:[UIImage imageNamed:ExampleAppLogoName] backgroundColor:nil] logging:[self.class sdlex_logConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration]];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:self];
    [self sdlex_startManager];
}

+ (SDLLifecycleConfiguration *)sdlex_setLifecycleConfigurationPropertiesOnConfiguration:(SDLLifecycleConfiguration *)config {
    UIImage *appLogo = [[UIImage imageNamed:ExampleAppLogoName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SDLArtwork *appIconArt = [SDLArtwork persistentArtworkWithImage:appLogo asImageFormat:SDLArtworkImageFormatPNG];

    config.shortAppName = ExampleAppNameShort;
    config.appIcon = appIconArt;
    config.voiceRecognitionCommandNames = @[ExampleAppNameTTS];
    config.ttsName = [SDLTTSChunk textChunksFromString:ExampleAppName];
    config.language = SDLLanguageEnUs;
    config.languagesSupported = @[SDLLanguageEnUs, SDLLanguageFrCa, SDLLanguageEsMx];
    config.appType = SDLAppHMITypeDefault;

    SDLRGBColor *green = [[SDLRGBColor alloc] initWithRed:126 green:188 blue:121];
    SDLRGBColor *white = [[SDLRGBColor alloc] initWithRed:249 green:251 blue:254];
    SDLRGBColor *darkGrey = [[SDLRGBColor alloc] initWithRed:57 green:78 blue:96];
    SDLRGBColor *grey = [[SDLRGBColor alloc] initWithRed:186 green:198 blue:210];
    config.dayColorScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryRGBColor:green secondaryRGBColor:grey backgroundRGBColor:white];
    config.nightColorScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryRGBColor:green secondaryRGBColor:grey backgroundRGBColor:darkGrey];

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
    self.sdlManager.screenManager.menu = [MenuManager allMenuItemsWithManager:self.sdlManager performManager:self.performManager];
    self.sdlManager.screenManager.voiceCommands = [MenuManager allVoiceMenuItemsWithManager:self.sdlManager];
}

- (void)sdlex_showInitialData {
    if (![self.sdlManager.hmiLevel isEqualToEnum:SDLHMILevelFull]) { return; }

    SDLSetDisplayLayout *setDisplayLayout = [[SDLSetDisplayLayout alloc] initWithPredefinedLayout:SDLPredefinedLayoutNonMedia];
    [self.sdlManager sendRequest:setDisplayLayout];

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
        if ([self sdlex_imageFieldSupported:SDLImageFieldNameGraphic]) {
            screenManager.primaryGraphic = areImagesVisible ? [SDLArtwork persistentArtworkWithImage:[[UIImage imageNamed:ExampleAppLogoName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] asImageFormat:SDLArtworkImageFormatPNG] : nil;
        }

        if ([self sdlex_imageFieldSupported:SDLImageFieldNameSecondaryGraphic]) {
            screenManager.secondaryGraphic = areImagesVisible ? [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:CarBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] : nil;
        }
    }

    [screenManager endUpdatesWithCompletionHandler:^(NSError * _Nullable error) {
        SDLLogD(@"Updated text and graphics, error? %@", error);
    }];
}

/**
 *  Checks if SDL Core's HMI current template supports the template image field (i.e. primary graphic, secondary graphic, etc.)
 *
 *  @param imageFieldName   The name for the image field
 *  @return                 True if the image field is supported, false if not
 */
- (BOOL)sdlex_imageFieldSupported:(SDLImageFieldName)imageFieldName {
    for (SDLImageField *imageField in self.sdlManager.systemCapabilityManager.displayCapabilities.imageFields) {
        if ([imageField.name isEqualToString:imageFieldName]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - SDLManagerDelegate

- (void)managerDidDisconnect {
    if (self.state != ProxyStateStopped) {
        [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    }

    self.firstHMILevel = SDLHMILevelNone;
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
