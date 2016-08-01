//  SDLAppInfo.m
//

#import "SDLAppInfo.h"
#import "SDLNames.h"

@implementation SDLAppInfo

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
