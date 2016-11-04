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
    if (appDisplayName != nil) {
        [store setObject:appDisplayName forKey:NAMES_appDisplayName];
    } else {
        [store removeObjectForKey:NAMES_appDisplayName];
    }
}

- (NSString *)appDisplayName {
    return [store objectForKey:NAMES_appDisplayName];
}

- (void)setAppBundleID:(NSString *)appBundleID {
    if (appBundleID != nil) {
        [store setObject:appBundleID forKey:NAMES_appBundleID];
    } else {
        [store removeObjectForKey:NAMES_appBundleID];
    }
}

- (NSString *)appBundleID {
    return [store objectForKey:NAMES_appBundleID];
}

- (void)setAppVersion:(NSString *)appVersion {
    if (appVersion != nil) {
        [store setObject:appVersion forKey:NAMES_appVersion];
    } else {
        [store removeObjectForKey:NAMES_appVersion];
    }
}

- (NSString *)appVersion {
    return [store objectForKey:NAMES_appVersion];
}

@end
