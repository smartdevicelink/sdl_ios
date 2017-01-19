//
//  SDLOnLockScreenStatus.m
//  SmartDeviceLink
//

#import "SDLOnLockScreenStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnLockScreenStatus

- (instancetype)init {
    if (self = [super initWithName:@"OnLockScreenStatus"]) {
    }
    return self;
}

- (void)setLockScreenStatus:(SDLLockScreenStatus)lockScreenStatus {
    [parameters sdl_setObject:lockScreenStatus forName:@"OnLockScreenStatus"];
}

- (SDLLockScreenStatus)lockScreenStatus {
    return [parameters sdl_objectForName:@"OnLockScreenStatus"];
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    [parameters sdl_setObject:hmiLevel forName:@"hmilevel"];
}

- (SDLHMILevel)hmiLevel {
    return [parameters sdl_objectForName:@"hmilevel"];
}

- (void)setUserSelected:(NSNumber<SDLBool> *)userSelected {
    [parameters sdl_setObject:userSelected forName:@"userselected"];
}

- (NSNumber<SDLBool> *)userSelected {
    return [parameters sdl_objectForName:@"userselected"];
}

- (void)setDriverDistractionStatus:(NSNumber<SDLBool> *)driverDistractionStatus {
    [parameters sdl_setObject:driverDistractionStatus forName:@"driverdistractionstatus"];
}

- (NSNumber<SDLBool> *)driverDistractionStatus {
    return [parameters sdl_objectForName:@"driverdistractionstatus"];
}

@end

NS_ASSUME_NONNULL_END
