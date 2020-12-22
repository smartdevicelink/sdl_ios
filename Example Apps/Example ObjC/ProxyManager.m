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
#import "SubscribeButtonManager.h"
#import "VehicleDataManager.h"
#import "SDLCarWindow.h"
#import "SDLStreamingMediaDelegate.h"
#import "VideoStreamSettings.h"

NS_ASSUME_NONNULL_BEGIN


@interface ProxyManager () <SDLManagerDelegate>

// Describes the first time the HMI state goes non-none and full.
@property (assign, nonatomic) SDLHMILevel firstHMILevel;

@property (strong, nonatomic) VehicleDataManager *vehicleDataManager;
@property (strong, nonatomic) PerformInteractionManager *performManager;
@property (strong, nonatomic) ButtonManager *buttonManager;
@property (strong, nonatomic) SubscribeButtonManager *subscribeButtonManager;
@property (nonatomic, copy, nullable) RefreshUIHandler refreshUIHandler;
@end

//#Touch_Input:
@interface ProxyManager (SDLTouchManagerDelegate) <SDLTouchManagerDelegate>
- (void)touchEventAvailable:(SDLRPCNotificationNotification *)notification;
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

    //#Touch_Input: Pre sdl_ios v6.3
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEventAvailable:) name:SDLDidReceiveTouchEventNotification object:nil];


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
        self.subscribeButtonManager = [[SubscribeButtonManager alloc] initWithManager:self.sdlManager];

        [weakSelf sdlex_updateProxyState:ProxyStateConnected];
        [RPCPermissionsManager setupPermissionsCallbacksWithManager:weakSelf.sdlManager];
        [weakSelf sdlex_showInitialData];

        SDLLogD(@"SDL file manager storage: %lu mb", (long)self.sdlManager.fileManager.bytesAvailable / 1024 / 1024);
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

- (void)startProxyTCP:(SDLTCPConfig*)tcpConfig {
    assert(nil != tcpConfig);
    if (self.sdlManager) {
        [self.sdlManager stop];
        self.sdlManager = nil;
    }

    SDLLifecycleConfiguration *lifecycleConfiguration = [SDLLifecycleConfiguration debugConfigurationWithAppName:ExampleAppName fullAppId:ExampleFullAppId ipAddress:tcpConfig.ipAddress port:tcpConfig.port];

    UIImage *appLogo = [[UIImage imageNamed:ExampleAppLogoName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SDLArtwork *appIconArt = [SDLArtwork persistentArtworkWithImage:appLogo asImageFormat:SDLArtworkImageFormatPNG];

    lifecycleConfiguration.shortAppName = ExampleAppNameShort;
    lifecycleConfiguration.appIcon = appIconArt;
    lifecycleConfiguration.voiceRecognitionCommandNames = @[ExampleAppNameTTS];
    lifecycleConfiguration.ttsName = [SDLTTSChunk textChunksFromString:ExampleAppName];
    lifecycleConfiguration.language = SDLLanguageEnUs;
    lifecycleConfiguration.languagesSupported = @[SDLLanguageEnUs, SDLLanguageFrCa, SDLLanguageEsMx];
    lifecycleConfiguration.appType = SDLAppHMITypeNavigation;

    SDLRGBColor *green = [[SDLRGBColor alloc] initWithRed:126 green:188 blue:121];
    SDLRGBColor *white = [[SDLRGBColor alloc] initWithRed:249 green:251 blue:254];
    SDLRGBColor *darkGrey = [[SDLRGBColor alloc] initWithRed:57 green:78 blue:96];
    SDLRGBColor *grey = [[SDLRGBColor alloc] initWithRed:186 green:198 blue:210];
    lifecycleConfiguration.dayColorScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryRGBColor:green secondaryRGBColor:grey backgroundRGBColor:white];
    lifecycleConfiguration.nightColorScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryRGBColor:green secondaryRGBColor:grey backgroundRGBColor:darkGrey];

    SDLLockScreenConfiguration *lockScreenConfiguration = [SDLLockScreenConfiguration enabledConfigurationWithAppIcon:[UIImage imageNamed:ExampleAppLogoName] backgroundColor:nil];
    SDLConfiguration *config = [[SDLConfiguration alloc] initWithLifecycle:lifecycleConfiguration lockScreen:lockScreenConfiguration logging:[self.class sdlex_logConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:[SDLEncryptionConfiguration defaultConfiguration]];




    SDLEncryptionConfiguration *encryptionConfig = [SDLEncryptionConfiguration defaultConfiguration];//[[SDLEncryptionConfiguration alloc] initWithSecurityManagers:@[OEMSecurityManager.self] delegate:self];
    SDLStreamingMediaConfiguration *streamingConfig = nil;
//    SDLStreamingMediaConfiguration *streamingConfig = [SDLStreamingMediaConfiguration insecureConfiguration];

    if (self.videoVC) {
        streamingConfig = [SDLStreamingMediaConfiguration autostreamingInsecureConfigurationWithInitialViewController:self.videoVC];
        streamingConfig.delegate = self.videoVC;
        streamingConfig.supportedPortraitStreamingRange = self.videoStreamSettings.supportedPortraitStreamingRange;
        streamingConfig.supportedLandscapeStreamingRange = self.videoStreamSettings.supportedLandscapeStreamingRange;
    } else {
        streamingConfig = [SDLStreamingMediaConfiguration insecureConfiguration];
    }

    SDLConfiguration *config2 = [[SDLConfiguration alloc] initWithLifecycle:lifecycleConfiguration lockScreen:lockScreenConfiguration logging:[self.class sdlex_logConfiguration] streamingMedia:streamingConfig fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:encryptionConfig];


    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config2 delegate:self];
    self.sdlManager.sdlMsgVersionString = self.videoStreamSettings.SDLVersion;

    __weak typeof (self) weakSelf = self;
    [self.sdlManager startWithReadyHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"SDL start error: %@", error);
            [weakSelf sdlex_updateProxyState:ProxyStateStopped];
            return;
        }

        weakSelf.vehicleDataManager = [[VehicleDataManager alloc] initWithManager:weakSelf.sdlManager refreshUIHandler:weakSelf.refreshUIHandler];
        weakSelf.performManager = [[PerformInteractionManager alloc] initWithManager:weakSelf.sdlManager];
        weakSelf.buttonManager = [[ButtonManager alloc] initWithManager:weakSelf.sdlManager refreshUIHandler:weakSelf.refreshUIHandler];

        [weakSelf sdlex_updateProxyState:ProxyStateConnected];
        [RPCPermissionsManager setupPermissionsCallbacksWithManager:weakSelf.sdlManager];
        [weakSelf sdlex_showInitialData];

        //#Touch_Input, decide who is the delegate
        if ([weakSelf.videoVC conformsToProtocol:@protocol(SDLTouchManagerDelegate)]) {
            weakSelf.sdlManager.streamManager.touchManager.touchEventDelegate = (id<SDLTouchManagerDelegate>) weakSelf.videoVC;
        } else {
            weakSelf.sdlManager.streamManager.touchManager.touchEventDelegate = self;
        }



        NSLog(@"SDL started, file manager storage: %lu mb", (long)weakSelf.sdlManager.fileManager.bytesAvailable / 1024 / 1024);
    }];
}

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
        //TODO: the ip might change but we still start it with the old config
        [self sdlex_startManager];
        return;
    }

    SDLLockScreenConfiguration *lockScreenConfiguration = [SDLLockScreenConfiguration enabledConfigurationWithAppIcon:[UIImage imageNamed:ExampleAppLogoName] backgroundColor:nil];
    SDLConfiguration *config = [[SDLConfiguration alloc] initWithLifecycle:lifecycleConfiguration lockScreen:lockScreenConfiguration logging:[self.class sdlex_logConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:[SDLEncryptionConfiguration defaultConfiguration]];
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
    SDLLogFileModule *sdlExampleModule = [SDLLogFileModule moduleWithName:@"SDL Obj-C Example App" files:[NSSet setWithArray:@[@"ProxyManager", @"AlertManager", @"AudioManager", @"ButtonManager", @"SubscribeButtonManager", @"MenuManager", @"PerformInteractionManager", @"RPCPermissionsManager", @"VehicleDataManager"]]];
    logConfig.modules = [logConfig.modules setByAddingObject:sdlExampleModule];
    logConfig.targets = [logConfig.targets setByAddingObject:[SDLLogTargetFile logger]];
    logConfig.globalLogLevel = SDLLogLevelDebug;

    //TODO: fix it when done
//    logConfig.globalLogLevel = SDLLogLevelVerbose;
    
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
    screenManager.title = isTextEnabled ? @"Home" : nil;
    screenManager.textField1 = isTextEnabled ? SmartDeviceLinkText : nil;
    screenManager.textField2 = isTextEnabled ? [NSString stringWithFormat:@"Obj-C %@", ExampleAppText] : nil;
    screenManager.textField3 = isTextEnabled ? self.vehicleDataManager.vehicleOdometerData : nil;

    if ([self sdlex_imageFieldSupported:SDLImageFieldNameGraphic]) {
        screenManager.primaryGraphic = areImagesVisible ? [SDLArtwork persistentArtworkWithImage:[[UIImage imageNamed:ExampleAppLogoName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] asImageFormat:SDLArtworkImageFormatPNG] : nil;
    }

    if ([self sdlex_imageFieldSupported:SDLImageFieldNameSecondaryGraphic]) {
        screenManager.secondaryGraphic = areImagesVisible ? [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:CarBWIconImageName] asImageFormat:SDLArtworkImageFormatPNG] : nil;
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
    for (SDLImageField *imageField in self.sdlManager.systemCapabilityManager.defaultMainWindowCapability.imageFields) {
        if ([imageField.name isEqualToString:imageFieldName]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - SDLManagerDelegate

/// Called when the connection beween this app and the module has closed.
- (void)managerDidDisconnect {
    if (self.state != ProxyStateStopped) {
        [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    }

    self.firstHMILevel = SDLHMILevelNone;
}

/// Called when the state of the SDL app has changed. The state limits the type of RPC that can be sent. Refer to the class documentation for each RPC to determine what state(s) the RPC can be sent.
/// @param oldLevel The old HMI Level
/// @param newLevel The new HMI Level
- (void)hmiLevel:(SDLHMILevel)oldLevel didChangeToLevel:(SDLHMILevel)newLevel {
    NSLog(@"hmiLevel:changed:HMI[%@-->%@]", oldLevel, newLevel);

    if (![newLevel isEqualToEnum:SDLHMILevelNone] && ([self.firstHMILevel isEqualToEnum:SDLHMILevelNone])) {
        // This is our first time in a non-NONE state
        self.firstHMILevel = newLevel;
        
        // Send static menu items.
        [self sdlex_createMenus];

        // Subscribe to vehicle data.
        [self.vehicleDataManager subscribeToVehicleOdometer];
    }

    if ([newLevel isEqualToEnum:SDLHMILevelFull]) {
        // The SDL app is in the foreground. Always try to show the initial state to guard against some possible weird states. Duplicates will be ignored by Core.
        [self sdlex_showInitialData];
        [self.subscribeButtonManager subscribeToAllPresetButtons];
    } else if ([newLevel isEqualToEnum:SDLHMILevelLimited]) {
        // An active NAV or MEDIA SDL app is in the background
    } else if ([newLevel isEqualToEnum:SDLHMILevelBackground]) {
        // The SDL app is not in the foreground
    } else if ([newLevel isEqualToEnum:SDLHMILevelNone]) {
        // The SDL app is not yet running
    }

    // Preventing Device Sleep
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].idleTimerDisabled = ![newLevel isEqualToEnum:SDLHMILevelNone];
    });
}

/// Called when the SDL app's HMI context changes.
/// @param oldContext The old HMI context
/// @param newContext The new HMI context
- (void)systemContext:(nullable SDLSystemContext)oldContext didChangeToContext:(SDLSystemContext)newContext {
    NSLog(@"systemContext:changed:[%@-->%@]", oldContext, newContext);

    if ([newContext isEqualToEnum:SDLSystemContextAlert]) {
        // The SDL app's screen is obscured by an alert
    } else if ([newContext isEqualToEnum:SDLSystemContextHMIObscured]) {
        // The SDL app's screen is obscured
    } else if ([newContext isEqualToEnum:SDLSystemContextMain]) {
        // The SDL app's main screen is open
    } else if ([newContext isEqualToEnum:SDLSystemContextMenu]) {
        // The SDL app's menu is open
    } else if ([newContext isEqualToEnum:SDLSystemContextVoiceRecognitionSession]) {
        // A voice recognition session is in progress
    }
}

/// Called when the audio state of the SDL app has changed. The audio state only needs to be monitored if the app is streaming audio.
/// @param oldState The old audio streaming state
/// @param newState The new audio streaming state
- (void)audioStreamingState:(nullable SDLAudioStreamingState)oldState didChangeToState:(SDLAudioStreamingState)newState {
    NSLog(@"audioStreamingState:changed:[%@-->%@]", oldState, newState);

    if ([newState isEqualToEnum:SDLAudioStreamingStateAudible]) {
        // The SDL app's audio can be heard
    } else if ([newState isEqualToEnum:SDLAudioStreamingStateNotAudible]) {
        // The SDL app's audio cannot be heard
    } else if ([newState isEqualToEnum:SDLAudioStreamingStateAttenuated]) {
        // The SDL app's audio volume has been lowered to let the system speak over the audio. This usually happens with voice recognition commands.
    }
}

/// Called when the car's head unit language is different from the default langage set in the SDLConfiguration AND the head unit language is supported by the app (as set in `languagesSupported` of SDLConfiguration). This method is only called when a connection to Core is first established. If desired, you can update the app's name and text-to-speech name to reflect the head unit's language.
/// @param language The head unit's current VR+TTS language
/// @param hmiLanguage The head unit's current HMI language
/// @return A SDLLifecycleConfigurationUpdate object
- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language hmiLanguage:(SDLLanguage)hmiLanguage {
>>>>>>> develop
    SDLLifecycleConfigurationUpdate *update = [[SDLLifecycleConfigurationUpdate alloc] init];

    if ([hmiLanguage isEqualToEnum:SDLLanguageEnUs]) {
        update.appName = ExampleAppName;
    } else if ([hmiLanguage isEqualToEnum:SDLLanguageEsMx]) {
        update.appName = ExampleAppNameSpanish;
    } else if ([hmiLanguage isEqualToEnum:SDLLanguageFrCa]) {
        update.appName = ExampleAppNameFrench;
    } else {
        return nil;
    }

    update.ttsName = [SDLTTSChunk textChunksFromString:update.appName];

    return update;
}

@end

//#Touch_Input:
@implementation ProxyManager (SDLTouchManagerDelegate)

- (void)touchManager:(SDLTouchManager *)manager didReceiveSingleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    NSLog(@"%s: %@:%@ > %@", __PRETTY_FUNCTION__, NSStringFromClass(view.class), NSStringFromCGRect(view.frame), NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager didReceiveDoubleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

// panning
- (void)touchManager:(SDLTouchManager *)manager panningDidStartInView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager didReceivePanningFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    NSLog(@"%s: %@-->%@", __PRETTY_FUNCTION__, NSStringFromCGPoint(fromPoint), NSStringFromCGPoint(toPoint));
}

- (void)touchManager:(SDLTouchManager *)manager panningDidEndInView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager panningCanceledAtPoint:(CGPoint)point {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));
}

// pinch
- (void)touchManager:(SDLTouchManager *)manager pinchDidStartInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager didReceivePinchAtCenterPoint:(CGPoint)point withScale:(CGFloat)scale {
    NSLog(@"%s: %@ : %2.2f", __PRETTY_FUNCTION__, NSStringFromCGPoint(point), scale);
}

- (void)touchManager:(SDLTouchManager *)manager didReceivePinchInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point withScale:(CGFloat)scale {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager pinchDidEndInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager pinchCanceledAtCenterPoint:(CGPoint)point {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));
}

/// touch notification
- (void)touchEventAvailable:(SDLRPCNotificationNotification *)notification {
    if (![notification.notification isKindOfClass:SDLOnTouchEvent.class]) {
      return;
    }
//    SDLOnTouchEvent *touchEvent = (SDLOnTouchEvent *)notification.notification;
//
//    // Grab something like type
//    SDLTouchType type = touchEvent.type;
//    NSLog(@"%s > %@ : %@", __PRETTY_FUNCTION__, type, touchEvent);
}

@end


NS_ASSUME_NONNULL_END
