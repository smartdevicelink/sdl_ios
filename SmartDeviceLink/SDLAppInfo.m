//  SDLAppInfo.m
//

#import "SDLAppInfo.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

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
    [store sdl_setObject:appDisplayName forName:SDLRPCParameterNameAppDisplayName];
}

- (NSString *)appDisplayName {
    return [store sdl_objectForName:SDLRPCParameterNameAppDisplayName];
}

- (void)setAppBundleID:(NSString *)appBundleID {
    [store sdl_setObject:appBundleID forName:SDLRPCParameterNameAppBundleId];
}

- (NSString *)appBundleID {
    return [store sdl_objectForName:SDLRPCParameterNameAppBundleId];
}

- (void)setAppVersion:(NSString *)appVersion {
    [store sdl_setObject:appVersion forName:SDLRPCParameterNameAppVersion];
}

- (NSString *)appVersion {
    return [store sdl_objectForName:SDLRPCParameterNameAppVersion];
}

@end

NS_ASSUME_NONNULL_END
