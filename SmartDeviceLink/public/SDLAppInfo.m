//  SDLAppInfo.m
//

#import "SDLAppInfo.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

static NSString *const SDLBundleShortVersionStringKey = @"CFBundleShortVersionString";
static NSString *const SDLBundleAppNameKey = @"CFBundleName";

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppInfo

- (instancetype)initWithAppDisplayName:(NSString *)appDisplayName appBundleID:(NSString *)appBundleID appVersion:(NSString *)appVersion {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.appDisplayName = appDisplayName;
    self.appBundleID = appBundleID;
    self.appVersion = appVersion;
    return self;
}

- (instancetype)initWithAppDisplayName:(NSString *)appDisplayName appBundleID:(NSString *)appBundleID appVersion:(NSString *)appVersion appIcon:(nullable NSString *)appIcon {
    self = [self initWithAppDisplayName:appDisplayName appBundleID:appBundleID appVersion:appVersion];
    if (!self) {
        return nil;
    }
    self.appIcon = appIcon;
    return self;
}

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
    [self.store sdl_setObject:appDisplayName forName:SDLRPCParameterNameAppDisplayName];
}

- (NSString *)appDisplayName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameAppDisplayName ofClass:NSString.class error:&error];
}

- (void)setAppBundleID:(NSString *)appBundleID {
    [self.store sdl_setObject:appBundleID forName:SDLRPCParameterNameAppBundleId];
}

- (NSString *)appBundleID {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameAppBundleId ofClass:NSString.class error:&error];
}

- (void)setAppVersion:(NSString *)appVersion {
    [self.store sdl_setObject:appVersion forName:SDLRPCParameterNameAppVersion];
}

- (NSString *)appVersion {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameAppVersion ofClass:NSString.class error:&error];
}

- (void)setAppIcon:(nullable NSString *)appIcon {
    [self.store sdl_setObject:appIcon forName:SDLRPCParameterNameAppIcon];
}

- (nullable NSString *)appIcon {
    return [self.store sdl_objectForName:SDLRPCParameterNameAppIcon ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
