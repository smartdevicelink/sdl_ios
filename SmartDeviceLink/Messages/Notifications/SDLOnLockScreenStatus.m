//
//  SDLOnLockScreenStatus.m
//  SmartDeviceLink
//

#import "SDLOnLockScreenStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnLockScreenStatus

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnLockScreenStatus]) {
    }
    return self;
}

- (void)setLockScreenStatus:(SDLLockScreenStatus)lockScreenStatus {
    [parameters sdl_setObject:lockScreenStatus forName:SDLNameOnLockScreenStatus];
}

- (SDLLockScreenStatus)lockScreenStatus {
    return [parameters sdl_objectForName:SDLNameOnLockScreenStatus];
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    [parameters sdl_setObject:hmiLevel forName:SDLNameHMILevel];
}

- (SDLHMILevel)hmiLevel {
    return [parameters sdl_objectForName:SDLNameHMILevel];
}

- (void)setUserSelected:(NSNumber<SDLBool> *)userSelected {
    [parameters sdl_setObject:userSelected forName:SDLNameUserSelected];
}

- (NSNumber<SDLBool> *)userSelected {
    return [parameters sdl_objectForName:SDLNameUserSelected];
}

- (void)setDriverDistractionStatus:(NSNumber<SDLBool> *)driverDistractionStatus {
    [parameters sdl_setObject:driverDistractionStatus forName:SDLNameDriverDistractionStatus];
}

- (NSNumber<SDLBool> *)driverDistractionStatus {
    return [parameters sdl_objectForName:SDLNameDriverDistractionStatus];
}

@end

NS_ASSUME_NONNULL_END
