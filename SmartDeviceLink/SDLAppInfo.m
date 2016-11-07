//  SDLAppInfo.m
//

#import "SDLAppInfo.h"

#import "SDLNames.h"

static NSString *const SDLBundleShortVersionStringKey = @"CFBundleShortVersionString";
static NSString *const SDLBundleAppNameKey = @"CFBundleName";

@implementation SDLAppInfo

+ (instancetype)currentAppInfo {
    static SDLAppInfo *appInfo = nil;
    if (appInfo == nil) {
        appInfo = [[SDLAppInfo alloc] init];
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSDictionary *bundleDictionary = mainBundle.infoDictionary;
        appInfo.appDisplayName = bundleDictionary[SDLBundleAppNameKey];
        appInfo.appVersion = bundleDictionary[SDLBundleShortVersionStringKey];
        appInfo.appBundleID = mainBundle.bundleIdentifier;
    }
    return appInfo;
}

- (void)setAppDisplayName:(NSString *)appDisplayName {
    [self setObject:appDisplayName forName:SDLNameAppDisplayName];
}

- (NSString *)appDisplayName {
    return [self objectForName:SDLNameAppDisplayName];
}

- (void)setAppBundleID:(NSString *)appBundleID {
    [self setObject:appBundleID forName:SDLNameAppBundleId];
}

- (NSString *)appBundleID {
    return [self objectForName:SDLNameAppBundleId];
}

- (void)setAppVersion:(NSString *)appVersion {
    [self setObject:appVersion forName:SDLNameAppVersion];
}

- (NSString *)appVersion {
    return [self objectForName:SDLNameAppVersion];
}

@end
