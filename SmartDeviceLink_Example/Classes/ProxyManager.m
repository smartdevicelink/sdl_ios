//
//  ProxyManager.m
//  SmartDeviceLink-iOS

@import SmartDeviceLink;

#import "ProxyManager.h"

#import "Preferences.h"


NSString *const SDLAppName = @"SDL Test";
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
    SDLLifecycleConfiguration *lifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:SDLAppName appId:SDLAppId];
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfig lockScreen:nil];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:nil];
    
    [self.sdlManager start];
}

- (void)startTCP {
    SDLLifecycleConfiguration *lifecycleConfig = [SDLLifecycleConfiguration debugConfigurationWithAppName:SDLAppName appId:SDLAppId ipAddress:[Preferences sharedPreferences].ipAddress port:[Preferences sharedPreferences].port];
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfig lockScreen:nil];
    self.sdlManager = [[SDLManager alloc] initWithConfiguration:config delegate:nil];
    
    [self.sdlManager start];
}

- (void)stop {
    [self.sdlManager stop];
}

- (void)showInitialData {
    SDLShow *initalData = [SDLRPCRequestFactory buildShowWithMainField1:@"SDL" mainField2:@"Test App" alignment:[SDLTextAlignment CENTERED] correlationID:@0];
    [self.sdlManager sendRequest:initalData];
}


#pragma mark - SDLManagerDelegate

- (void)managerDidBecomeReady {
    [self showInitialData];
}

- (void)managerDidDisconnect {
    
}

@end
