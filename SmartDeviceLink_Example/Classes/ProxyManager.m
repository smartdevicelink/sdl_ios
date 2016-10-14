//
//  ProxyManager.m
//  SmartDeviceLink-iOS

@import SmartDeviceLink;

#import "ProxyManager.h"

#import "Preferences.h"


NSString *const SDLAppName = @"SDL Example App";
NSString *const SDLAppId = @"9999";

NSString *const PointingSoftButtonArtworkName = @"PointingSoftButtonIcon";
NSString *const MainGraphicArtworkName = @"MainArtwork";

typedef NS_ENUM(NSUInteger, SDLHMIFirstState) {
    SDLHMIFirstStateNone,
    SDLHMIFirstStateNonNone,
    SDLHMIFirstStateFull
};

typedef NS_ENUM(NSUInteger, SDLHMIInitialShowState) {
    SDLHMIInitialShowStateNone,
    SDLHMIInitialShowStateDataAvailable,
    SDLHMIInitialShowStateShown
};


NS_ASSUME_NONNULL_BEGIN

@interface ProxyManager () <SDLManagerDelegate>

// Describes the first time the HMI state goes non-none and full.
@property (assign, nonatomic) SDLHMIFirstState firstTimeState;
@property (assign, nonatomic) SDLHMIInitialShowState initialShowState;

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
    _initialShowState = SDLHMIInitialShowStateNone;
    
    return self;
}

- (void)startIAP {
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    SDLLifecycleConfiguration *lifecycleConfig = [self.class setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration defaultConfigurationWithAppName:SDLAppName appId:SDLAppId]];
    
    // Assume this is production and disable logging
    lifecycleConfig.logFlags = SDLLogOutputNone;
    
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfig lockScreen:[SDLLockScreenConfiguration enabledConfiguration]];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:self];
    
    [self startManager];
}

- (void)startTCP {
    [self sdlex_updateProxyState:ProxyStateSearchingForConnection];
    SDLLifecycleConfiguration *lifecycleConfig = [self.class setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration debugConfigurationWithAppName:SDLAppName appId:SDLAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port]];
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfig lockScreen:[SDLLockScreenConfiguration enabledConfiguration]];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:self];
    
    [self startManager];
}

- (void)startManager {
    __weak typeof (self) weakSelf = self;
    [self.sdlManager startWithReadyHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"SDL errored starting up: %@", error);
            [weakSelf sdlex_updateProxyState:ProxyStateStopped];
        } else {
            [weakSelf sdlex_updateProxyState:ProxyStateConnected];
        }
        
        if ([weakSelf.sdlManager.hmiLevel isEqualToString:SDLHMILevelFull]) {
            [weakSelf showInitialData];
        }
    }];
}

- (void)reset {
    [self.sdlManager stop];
}

- (void)showInitialData {
    if ((self.initialShowState != SDLHMIInitialShowStateDataAvailable) || [self.sdlManager.hmiLevel isEqualToString:SDLHMILevelFull]) {
        return;
    }
    
    self.initialShowState = SDLHMIInitialShowStateShown;
    
    SDLShow *show = [SDLRPCRequestFactory buildShowWithMainField1:@"SDL" mainField2:@"Test App" alignment:SDLTextAlignmentCentered correlationID:@0];
    SDLSoftButton *pointingSoftButton = [self.class pointingSoftButtonWithManager:self.sdlManager];
    show.softButtons = [@[pointingSoftButton] mutableCopy];
    show.graphic = [self.class mainGraphicImage];
    
    [self.sdlManager sendRequest:show];
}

+ (SDLLifecycleConfiguration *)setLifecycleConfigurationPropertiesOnConfiguration:(SDLLifecycleConfiguration *)config {
    SDLArtwork *appIconArt = [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:@"AppIcon60x60@2x"] name:@"AppIcon" asImageFormat:SDLArtworkImageFormatPNG];
    
    config.shortAppName = @"SDL Example";
    config.appIcon = appIconArt;
    config.voiceRecognitionCommandNames = @[@"S D L Example"];
    config.ttsName = @[[SDLTTSChunkFactory buildTTSChunkForString:config.shortAppName type:SDLSpeechCapabilitiesText]];
    
    return config;
}

- (void)sdlex_updateProxyState:(ProxyState)newState {
    if (self.state != newState) {
        [self willChangeValueForKey:@"state"];
        _state = newState;
        [self didChangeValueForKey:@"state"];
    }
}

#pragma mark - RPC builders

+ (SDLAddCommand *)speakNameCommandWithManager:(SDLManager *)manager {
    NSString *commandName = @"Speak App Name";
    
    SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] init];
    commandMenuParams.menuName = commandName;
    
    SDLAddCommand *speakNameCommand = [[SDLAddCommand alloc] init];
    speakNameCommand.vrCommands = [NSMutableArray arrayWithObject:commandName];
    speakNameCommand.menuParams = commandMenuParams;
    speakNameCommand.cmdID = @0;
    
    speakNameCommand.handler = ^void(SDLOnCommand *notification) {
        [manager sendRequest:[self.class appNameSpeak]];
    };
    
    return speakNameCommand;
}

+ (SDLAddCommand *)interactionSetCommandWithManager:(SDLManager *)manager {
    NSString *commandName = @"Perform Interaction";
    
    SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] init];
    commandMenuParams.menuName = commandName;
    
    SDLAddCommand *performInteractionCommand = [[SDLAddCommand alloc] init];
    performInteractionCommand.vrCommands = [NSMutableArray arrayWithObject:commandName];
    performInteractionCommand.menuParams = commandMenuParams;
    performInteractionCommand.cmdID = @1;
    
    // NOTE: You may want to preload your interaction sets, because they can take a while for the remote system to process. We're going to ignore our own advice here.
    __weak typeof(self) weakSelf = self;
    performInteractionCommand.handler = ^void(SDLOnCommand *notification) {
        [weakSelf sendPerformOnlyChoiceInteractionWithManager:manager];
    };
    
    return performInteractionCommand;
}

+ (SDLSpeak *)appNameSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:@"S D L Example App" type:SDLSpeechCapabilitiesText]];
    
    return speak;
}

+ (SDLSpeak *)goodJobSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:@"Good job" type:SDLSpeechCapabilitiesText]];
    
    return speak;
}

+ (SDLSpeak *)youMissedItSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:@"You missed it" type:SDLSpeechCapabilitiesText]];
    
    return speak;
}

+ (SDLCreateInteractionChoiceSet *)createOnlyChoiceInteractionSet {
    SDLCreateInteractionChoiceSet *createInteractionSet = [[SDLCreateInteractionChoiceSet alloc] init];
    createInteractionSet.interactionChoiceSetID = @0;
    
    NSString *theOnlyChoiceName = @"The Only Choice";
    SDLChoice *theOnlyChoice = [[SDLChoice alloc] init];
    theOnlyChoice.choiceID = @0;
    theOnlyChoice.menuName = theOnlyChoiceName;
    theOnlyChoice.vrCommands = [NSMutableArray arrayWithObject:theOnlyChoiceName];
    
    createInteractionSet.choiceSet = [NSMutableArray arrayWithArray:@[theOnlyChoice]];
    
    return createInteractionSet;
}

+ (void)sendPerformOnlyChoiceInteractionWithManager:(SDLManager *)manager {
    SDLPerformInteraction *performOnlyChoiceInteraction = [[SDLPerformInteraction alloc] init];
    performOnlyChoiceInteraction.initialText = @"Choose the only one! You have 5 seconds...";
    performOnlyChoiceInteraction.initialPrompt = [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:@"Choose it" type:SDLSpeechCapabilitiesText]];
    performOnlyChoiceInteraction.interactionMode = SDLInteractionModeBoth;
    performOnlyChoiceInteraction.interactionChoiceSetIDList = [NSMutableArray arrayWithObject:@0];
    performOnlyChoiceInteraction.helpPrompt = [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:@"Do it" type:SDLSpeechCapabilitiesText]];
    performOnlyChoiceInteraction.timeoutPrompt = [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:@"Too late" type:SDLSpeechCapabilitiesText]];
    performOnlyChoiceInteraction.timeout = @5000;
    performOnlyChoiceInteraction.interactionLayout = SDLLayoutModeListOnly;
    
    [manager sendRequest:performOnlyChoiceInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLPerformInteractionResponse * _Nullable response, NSError * _Nullable error) {
        if ((response == nil) || (error != nil)) {
            NSLog(@"Something went wrong, no perform interaction response: %@", error);
        }
        
        if ([response.choiceID isEqualToNumber:@0]) {
            [manager sendRequest:[self goodJobSpeak]];
        } else {
            [manager sendRequest:[self youMissedItSpeak]];
        }
    }];
}

+ (SDLSoftButton *)pointingSoftButtonWithManager:(SDLManager *)manager {
    SDLSoftButton* softButton = [[SDLSoftButton alloc] initWithHandler:^(__kindof SDLRPCNotification *notification) {
        if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
            SDLAlert* alert = [[SDLAlert alloc] init];
            alert.alertText1 = @"You pushed the button!";
            [manager sendRequest:alert];
        }
    }];
    softButton.text = @"Press";
    softButton.softButtonID = @100;
    softButton.type = SDLSoftButtonTypeBoth;
    
    SDLImage* image = [[SDLImage alloc] init];
    image.imageType = SDLImageTypeDynamic;
    image.value = PointingSoftButtonArtworkName;
    softButton.image = image;
    
    return softButton;
}

+ (SDLImage *)mainGraphicImage {
    SDLImage* image = [[SDLImage alloc] init];
    image.imageType = SDLImageTypeDynamic;
    image.value = MainGraphicArtworkName;

    return image;
}


#pragma mark - Files / Artwork 

+ (SDLArtwork*)pointingSoftButtonArtwork {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"sdl_softbutton_icon"] name:PointingSoftButtonArtworkName asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)mainGraphicArtwork {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"sdl_logo_green"] name:MainGraphicArtworkName asImageFormat:SDLArtworkImageFormatPNG];
}

- (void)prepareRemoteSystem {
    [self.sdlManager sendRequest:[self.class speakNameCommandWithManager:self.sdlManager]];
    [self.sdlManager sendRequest:[self.class interactionSetCommandWithManager:self.sdlManager]];
    
    dispatch_group_t dataDispatchGroup = dispatch_group_create();
    dispatch_group_enter(dataDispatchGroup);

    dispatch_group_enter(dataDispatchGroup);
    [self.sdlManager.fileManager uploadFile:[self.class mainGraphicArtwork] completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
        dispatch_group_leave(dataDispatchGroup);

        if (success == NO) {
            NSLog(@"Something went wrong, image could not upload: %@", error);
            return;
        }
    }];
    
    dispatch_group_enter(dataDispatchGroup);
    [self.sdlManager.fileManager uploadFile:[self.class pointingSoftButtonArtwork] completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
        dispatch_group_leave(dataDispatchGroup);
        
        if (success == NO) {
            NSLog(@"Something went wrong, image could not upload: %@", error);
            return;
        }
    }];
    
    dispatch_group_enter(dataDispatchGroup);
    [self.sdlManager sendRequest:[self.class createOnlyChoiceInteractionSet] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        // Interaction choice set ready
        dispatch_group_leave(dataDispatchGroup);
    }];
    
    dispatch_group_leave(dataDispatchGroup);
    dispatch_group_notify(dataDispatchGroup, dispatch_get_main_queue(), ^{
        self.initialShowState = SDLHMIInitialShowStateDataAvailable;
        [self showInitialData];
    });
}


#pragma mark - SDLManagerDelegate

- (void)managerDidDisconnect {
    // Reset our state
    self.firstTimeState = SDLHMIFirstStateNone;
    self.initialShowState = SDLHMIInitialShowStateNone;
    _state = ProxyStateStopped;
}

- (void)hmiLevel:(SDLHMILevel)oldLevel didChangeToLevel:(SDLHMILevel)newLevel {
    if (![newLevel isEqualToString:SDLHMILevelNone] && (self.firstTimeState == SDLHMIFirstStateNone)) {
        // This is our first time in a non-NONE state
        self.firstTimeState = SDLHMIFirstStateNonNone;
        
        // Send AddCommands
        [self prepareRemoteSystem];
    }
    
    if ([newLevel isEqualToString:SDLHMILevelFull] && (self.firstTimeState != SDLHMIFirstStateFull)) {
        // This is our first time in a FULL state
        self.firstTimeState = SDLHMIFirstStateFull;
    }
    
    if ([newLevel isEqualToString:SDLHMILevelFull]) {
        // We're always going to try to show the initial state, because if we've already shown it, it won't be shown, and we need to guard against some possible weird states
        [self showInitialData];
    }
}

@end

NS_ASSUME_NONNULL_END
