//  SDLAppInfo.m
//

#import "SDLAppInfo.h"

#import "NSMutableDictionary+Store.h"
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
    [store sdl_setObject:appDisplayName forName:SDLNameAppDisplayName];
}

- (NSString *)appDisplayName {
    NSError *error;
    return [store sdl_objectForName:SDLNameAppDisplayName ofClass:NSString.class error:&error];
}

- (void)setAppBundleID:(NSString *)appBundleID {
    [store sdl_setObject:appBundleID forName:SDLNameAppBundleId];
}

- (NSString *)appBundleID {
    NSError *error;
    return [store sdl_objectForName:SDLNameAppBundleId ofClass:NSString.class error:&error];
}

- (void)setAppVersion:(NSString *)appVersion {
    [store sdl_setObject:appVersion forName:SDLNameAppVersion];
}

- (NSString *)appVersion {
    NSError *error;
    return [store sdl_objectForName:SDLNameAppVersion ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
