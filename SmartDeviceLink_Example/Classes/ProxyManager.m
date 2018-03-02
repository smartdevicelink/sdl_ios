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
@property (assign, nonatomic) BOOL areImagesVisible;

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
    _areImagesVisible = YES;

    return self;
}

- (void)startIAP {
    // Check for previous instance of sdlManager
    if (self.sdlManager) { return; }
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration defaultConfigurationWithAppName:SDLAppName appId:SDLAppId]];
    [self sdlex_startWithLifecycleConfiguration:lifecycleConfig];
}

- (void)startTCP {
    // Check for previous instance of sdlManager
    if (self.sdlManager) { return; }
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration debugConfigurationWithAppName:SDLAppName appId:SDLAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port]];
    [self sdlex_startWithLifecycleConfiguration:lifecycleConfig];
}

- (void)sdlex_startWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfiguration lockScreen:[SDLLockScreenConfiguration enabledConfiguration] logging:[self.class sdlex_logConfiguration]];
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
    }];
}

- (void)reset {
    [self sdlex_updateProxyState:ProxyStateStopped];
    [self.sdlManager stop];
    self.sdlManager = nil;
}

#pragma mark - Helpers

- (void)sdlex_showInitialData {
    SDLSetDisplayLayout *displayLayout = [[SDLSetDisplayLayout alloc] initWithLayout:SDLPredefinedLayoutMedia];
    SDLAddCommand *speakNameAddCommand = [self.class sdlex_speakNameCommandWithManager:self.sdlManager];
    SDLAddCommand *performInteractionChoiceSetAddCommand = [self.class sdlex_interactionSetCommandWithManager:self.sdlManager];
    SDLAddCommand *getVehicleDataAddCommand = [self.class sdlex_vehicleDataCommandWithManager:self.sdlManager];
    SDLCreateInteractionChoiceSet *createInteractionChoiceSet = [self.class sdlex_createOnlyChoiceInteractionSet];

    [self.sdlManager sendSequentialRequests:@[displayLayout, speakNameAddCommand, performInteractionChoiceSetAddCommand, getVehicleDataAddCommand, createInteractionChoiceSet] progressHandler:^BOOL(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        SDLLogD(@"Show initial data RPC. Request: %@. Response: %@. Percentage complete: %f, error: %@", request, response, percentComplete, error);
        return YES;
    } completionHandler:^(BOOL success) {
        !success ? SDLLogW(@"Some show initial data RPCs were not sent successfully") : SDLLogD(@"All show initial data RPCs were sent successfully");
    }];
}

- (void)sdlex_updateShowWithManager:(SDLManager *)manager {
    NSString *mainField1Text = isTextOn ? @"Smart Device Link" : @"";
    NSString *mainField2Text = isTextOn ? @"Example App" : @"";
    SDLShow* show = [[SDLShow alloc] initWithMainField1:mainField1Text mainField2:mainField2Text alignment:SDLTextAlignmentCenter];

    [self sdlex_prepareSoftButtonsWithImages:self.areImagesVisible completionHandler:^(NSArray<SDLSoftButton *> * _Nonnull softButtons) {
        if (softButtons.count == 0) { return; }
        show.softButtons = softButtons;
        [manager sendRequest:show];
    }];

    [self sdlex_prepareMainGraphicImageWithImages:self.areImagesVisible completionHandler:^(SDLImage * _Nullable sdlImage) {
        if (sdlImage == nil) { return; }
        show.graphic = sdlImage;
        [manager sendRequest:show];
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

    return config;
}

+ (SDLLogConfiguration *)sdlex_logConfiguration {
    SDLLogConfiguration *logConfig = [SDLLogConfiguration defaultConfiguration];
    SDLLogFileModule *sdlExampleModule = [SDLLogFileModule moduleWithName:@"SDL Example" files:[NSSet setWithArray:@[@"ProxyManager"]]];
    logConfig.modules = [logConfig.modules setByAddingObject:sdlExampleModule];
    logConfig.targets = [logConfig.targets setByAddingObject:[SDLLogTargetFile logger]];
    logConfig.globalLogLevel = SDLLogLevelVerbose;

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
    SDLPerformInteraction *performOnlyChoiceInteraction = [[SDLPerformInteraction alloc] initWithInitialPrompt:@"Choose an item from the list" initialText:@"Choose the only option! You have 5 seconds..." interactionChoiceSetIDList:@[@0] helpPrompt:@"Select an item from the list" timeoutPrompt:@"The list is closing" interactionMode:SDLInteractionModeBoth timeout:5000 vrHelp:nil];
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

- (void)sdlex_prepareSoftButtonsWithImages:(BOOL)areImagesVisible completionHandler:(void (^)(NSArray<SDLSoftButton *> *softButtons))completionHandler {
    // Save each soft button to a specific index position in the array. Once all buttons have been created, return the array of buttons. This is done to prevent flickering that can occur if the UI is updated everytime a button is created.
    NSMutableArray<SDLSoftButton *> *softButtons = [[NSMutableArray alloc] initWithObjects:[[SDLSoftButton alloc] init], [[SDLSoftButton alloc] init], [[SDLSoftButton alloc] init], [[SDLSoftButton alloc] init], nil];

    dispatch_group_t dataDispatchGroup = dispatch_group_create();
    dispatch_group_enter(dataDispatchGroup);

    dispatch_group_enter(dataDispatchGroup);
    [self sdlex_prepareSoftButton1WithManager:self.sdlManager isImageVisible:areImagesVisible completionHandler:^(SDLSoftButton * _Nonnull button) {
        softButtons[0] = button;
        dispatch_group_leave(dataDispatchGroup);
    }];

    dispatch_group_enter(dataDispatchGroup);
    [self sdlex_prepareSoftButton2WithManager:self.sdlManager isImageVisible:areImagesVisible completionHandler:^(SDLSoftButton * _Nonnull button) {
        softButtons[1] = button;
        dispatch_group_leave(dataDispatchGroup);
    }];

    softButtons[2] = [self sdlex_prepareSoftButton3WithManager:self.sdlManager];
    softButtons[3] = [self sdlex_prepareSoftButton4WithManager:self.sdlManager areImagesVisible:areImagesVisible];

    dispatch_group_leave(dataDispatchGroup);
    dispatch_group_notify(dataDispatchGroup, dispatch_get_main_queue(), ^{
        completionHandler(softButtons);
    });
}

- (void)sdlex_prepareSoftButton1WithManager:(SDLManager *)manager isImageVisible:(BOOL)imageVisible completionHandler:(void (^)(SDLSoftButton * button))completionHandler {
    SDLSoftButton* softButton = [[SDLSoftButton alloc] initWithHandler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
        if (buttonPressNotification == nil) {
            return;
        }

        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = @"You pushed the soft button!";
        [manager sendRequest:alert];
    }];

    softButton.text = @"Press";
    softButton.softButtonID = @100;

    SDLArtwork *artwork = [self.class sdlex_softButton1Artwork];
    if (!imageVisible) {
        softButton.type = SDLSoftButtonTypeText;
        return completionHandler(softButton);
    }

    [manager.fileManager uploadArtwork:artwork completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
        softButton.type = success ? SDLSoftButtonTypeBoth : SDLSoftButtonTypeText;
        softButton.image = success ? [[SDLImage alloc] initWithName:artworkName] : nil;
        return completionHandler(softButton);
    }];
}

static BOOL isHexagonOn = YES;
- (void)sdlex_prepareSoftButton2WithManager:(SDLManager *)manager isImageVisible:(BOOL)imageVisible completionHandler:(void (^)(SDLSoftButton * button))completionHandler {
    SDLSoftButton* softButton = [[SDLSoftButton alloc] initWithHandler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
        if (buttonPressNotification == nil) { return; }
        isHexagonOn = !isHexagonOn;
        [self sdlex_updateShowWithManager:manager];
    }];
    softButton.softButtonID = @200;

    if (!imageVisible) {
        softButton.type = SDLSoftButtonTypeText;
        softButton.text = isHexagonOn ? @"➖Hex" : @"➕Hex";
        return completionHandler(softButton);
    }

    SDLArtwork *artwork = isHexagonOn ? [self.class sdlex_softButton2OnArtwork] : [self.class sdlex_softButton2OffArtwork];
    [manager.fileManager uploadArtwork:artwork completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
        softButton.type = success ? SDLSoftButtonTypeImage : SDLSoftButtonTypeText;
        softButton.image = success ? [[SDLImage alloc] initWithName:artworkName] : nil;
        return completionHandler(softButton);
    }];
}

static BOOL isTextOn = YES;
- (SDLSoftButton *)sdlex_prepareSoftButton3WithManager:(SDLManager *)manager {
    SDLSoftButton* softButton = [[SDLSoftButton alloc] initWithHandler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
        if (buttonPressNotification == nil) { return; }

        isTextOn = !isTextOn;
        [self sdlex_updateShowWithManager:manager];
    }];

    softButton.softButtonID = @300;
    softButton.text = isTextOn ? @"➖Text" : @"➕Text";
    softButton.type = SDLSoftButtonTypeText;

    return softButton;
}

- (SDLSoftButton *)sdlex_prepareSoftButton4WithManager:(SDLManager *)manager areImagesVisible:(BOOL)imageVisible {
    SDLSoftButton* softButton = [[SDLSoftButton alloc] initWithHandler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
        if (buttonPressNotification == nil) { return; }
        self.areImagesVisible = !imageVisible;
        [self sdlex_updateShowWithManager:manager];
    }];

    softButton.text = imageVisible ? @"➖Icons" : @"➕Icons";
    softButton.softButtonID = @400;
    softButton.type = SDLSoftButtonTypeText;

    return softButton;
}

- (void)sdlex_prepareMainGraphicImageWithImages:(BOOL)imageVisible completionHandler:(void (^)(SDLImage * _Nullable sdlImage))completionHandler {
    SDLArtwork *mainGraphicImage = imageVisible ? [self.class sdlex_mainGraphicArtwork] : [self.class sdlex_mainGraphicBlank];
    [self.sdlManager.fileManager uploadArtwork:mainGraphicImage completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
        if (!success) {
            SDLLogE(@"Artwork %@ failed to upload", artworkName);
            return completionHandler(nil);
        }
        return completionHandler([[SDLImage alloc] initWithName:artworkName]);
    }];
}

+ (void)sdlex_sendGetVehicleDataWithManager:(SDLManager *)manager {
    SDLGetVehicleData *getVehicleData = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES vin:YES wiperStatus:YES];

    [manager sendRequest:getVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"vehicle data response: %@", response);
    }];
}

#pragma mark - Files / Artwork

+ (SDLArtwork *)sdlex_softButton1Artwork {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"star_softbutton_icon"] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_softButton2OnArtwork {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"hexagon_on_softbutton_icon"] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_softButton2OffArtwork {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"hexagon_off_softbutton_icon"] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_mainGraphicArtwork {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"sdl_logo_green"] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_mainGraphicBlank {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), NO, 0.0);
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [SDLArtwork artworkWithImage:blankImage asImageFormat:SDLArtworkImageFormatPNG];
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
        [self sdlex_showInitialData];
    }
    
    if ([newLevel isEqualToEnum:SDLHMILevelFull] && (self.firstTimeState != SDLHMIFirstStateFull)) {
        // This is our first time in a FULL state
        self.firstTimeState = SDLHMIFirstStateFull;
        [self sdlex_updateShowWithManager:self.sdlManager];
    }
}

@end

NS_ASSUME_NONNULL_END
