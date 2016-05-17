//
//  ProxyManager.m
//  SmartDeviceLink-iOS

@import SmartDeviceLink;

#import "ProxyManager.h"

#import "Preferences.h"


NSString *const SDLAppName = @"SDL Test";
NSString *const SDLAppId = @"9999";


@interface ProxyManager () <SDLProxyListener>

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

- (void)start {
    SDLLifecycleConfiguration *lifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:SDLAppName appId:SDLAppId];
    SDLConfiguration *config = [SDLConfiguration configurationWithLifecycle:lifecycleConfig lockScreen:nil];
    
    [[SDLManager sharedManager] startWithConfiguration:config];
}

- (void)showInitialData {
    //    SDLShow *showRPC = [SDLRPCRequestFactory buildShowWithMainField1:@"SDL" mainField2:@"Test" alignment:[SDLTextAlignment CENTERED] correlationID:[self nextCorrelationID]];
    //    [self.proxy sendRPC:showRPC];
}

@end
