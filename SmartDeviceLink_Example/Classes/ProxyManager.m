//
//  ProxyManager.m
//  SmartDeviceLink-iOS

@import SmartDeviceLink;

#import "ProxyManager.h"

#import "Preferences.h"


NSString *const SDLAppName = @"SDL Example App";
NSString *const SDLAppId = @"9999";


@interface ProxyManager () <SDLManagerDelegate>

@property (strong, nonatomic) SDLManager *sdlManager;

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
    
    return self;
}

- (void)startIAP {
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration defaultConfigurationWithAppName:SDLAppName appId:SDLAppId]];
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfig lockScreen:[SDLLockScreenConfiguration enabledConfiguration]];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:self];
    
    [self.sdlManager start];
}

- (void)startTCP {
    SDLLifecycleConfiguration *lifecycleConfig = [self.class sdlex_setLifecycleConfigurationPropertiesOnConfiguration:[SDLLifecycleConfiguration debugConfigurationWithAppName:SDLAppName appId:SDLAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port]];
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfig lockScreen:[SDLLockScreenConfiguration enabledConfiguration]];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:self];
    
    [self.sdlManager start];
}

- (void)reset {
    [self.sdlManager stop];
}

- (void)showInitialData {
    SDLShow *initalData = [SDLRPCRequestFactory buildShowWithMainField1:@"SDL" mainField2:@"Test App" alignment:[SDLTextAlignment CENTERED] correlationID:@0];
    [self.sdlManager sendRequest:initalData];
}

+ (SDLLifecycleConfiguration *)sdlex_setLifecycleConfigurationPropertiesOnConfiguration:(SDLLifecycleConfiguration *)config {
    SDLArtwork *appIconArt = [SDLArtwork persistentArtworkWithImage:[UIImage imageNamed:@"AppIcon60x60@2x"] name:@"AppIcon" asImageFormat:SDLArtworkImageFormatPNG];
    
    config.shortAppName = @"SDL Example";
    config.appIcon = appIconArt;
    
    return config;
}


#pragma mark - SDLManagerDelegate

- (void)managerDidBecomeReady {
    if ([self.sdlManager.hmiLevel isEqualToEnum:[SDLHMILevel FULL]]) {
        [self showInitialData];
    }
}

- (void)managerDidDisconnect {}

- (void)hmiLevel:(SDLHMILevel *)oldLevel didChangeToLevel:(SDLHMILevel *)newLevel {
    if ([newLevel isEqualToEnum:[SDLHMILevel FULL]]) {
        [self showInitialData];
    }
}

@end
