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
    NSError *error;
    return [parameters sdl_enumForName:SDLNameOnLockScreenStatus error:&error];
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    [parameters sdl_setObject:hmiLevel forName:SDLNameHMILevel];
}

- (SDLHMILevel)hmiLevel {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameHMILevel error:&error];
}

- (void)setUserSelected:(NSNumber<SDLBool> *)userSelected {
    [parameters sdl_setObject:userSelected forName:SDLNameUserSelected];
}

- (NSNumber<SDLBool> *)userSelected {
    NSError *error;
    return [parameters sdl_objectForName:SDLNameUserSelected ofClass:NSNumber.class error:&error];
}

- (void)setDriverDistractionStatus:(NSNumber<SDLBool> *)driverDistractionStatus {
    [parameters sdl_setObject:driverDistractionStatus forName:SDLNameDriverDistractionStatus];
}

- (NSNumber<SDLBool> *)driverDistractionStatus {
    NSError *error;
    return [parameters sdl_objectForName:SDLNameDriverDistractionStatus ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
