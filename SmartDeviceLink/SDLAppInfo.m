//  SDLAppInfo.m
//

#import "SDLAppInfo.h"

#import "SDLNames.h"

static NSString *const SDLBundleShortVersionStringKey = @"CFBundleShortVersionString";
static NSString *const SDLBundleAppNameKey = @"CFBundleName";

NS_ASSUME_NONNULL_BEGIN

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
    if (appDisplayName != nil) {
        [store setObject:appDisplayName forKey:SDLNameAppDisplayName];
    } else {
        [store removeObjectForKey:SDLNameAppDisplayName];
    }
}

- (NSString *)appDisplayName {
    return [store objectForKey:SDLNameAppDisplayName];
}

- (void)setAppBundleID:(NSString *)appBundleID {
    if (appBundleID != nil) {
        [store setObject:appBundleID forKey:SDLNameAppBundleId];
    } else {
        [store removeObjectForKey:SDLNameAppBundleId];
    }
}

- (NSString *)appBundleID {
    return [store objectForKey:SDLNameAppBundleId];
}

- (void)setAppVersion:(NSString *)appVersion {
    if (appVersion != nil) {
        [store setObject:appVersion forKey:SDLNameAppVersion];
    } else {
        [store removeObjectForKey:SDLNameAppVersion];
    }
}

- (NSString *)appVersion {
    return [store objectForKey:SDLNameAppVersion];
}

@end

NS_ASSUME_NONNULL_END
