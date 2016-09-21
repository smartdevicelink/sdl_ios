//  SDLAppInfo.m
//

#import "SDLAppInfo.h"


@implementation SDLAppInfo

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
