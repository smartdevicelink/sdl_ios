//
//  SDLOnLockScreenStatus.m
//  SmartDeviceLink
//

#import "SDLOnLockScreenStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnLockScreenStatus

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnLockScreenStatus]) {
    }
    return self;
}

- (void)setLockScreenStatus:(SDLLockScreenStatus)lockScreenStatus {
    [parameters sdl_setObject:lockScreenStatus forName:SDLRPCParameterNameOnLockScreenStatus];
}

- (SDLLockScreenStatus)lockScreenStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameOnLockScreenStatus];
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    [parameters sdl_setObject:hmiLevel forName:SDLRPCParameterNameHMILevel];
}

- (SDLHMILevel)hmiLevel {
    return [parameters sdl_objectForName:SDLRPCParameterNameHMILevel];
}

- (void)setUserSelected:(NSNumber<SDLBool> *)userSelected {
    [parameters sdl_setObject:userSelected forName:SDLRPCParameterNameUserSelected];
}

- (NSNumber<SDLBool> *)userSelected {
    return [parameters sdl_objectForName:SDLRPCParameterNameUserSelected];
}

- (void)setDriverDistractionStatus:(NSNumber<SDLBool> *)driverDistractionStatus {
    [parameters sdl_setObject:driverDistractionStatus forName:SDLRPCParameterNameDriverDistractionStatus];
}

- (NSNumber<SDLBool> *)driverDistractionStatus {
    return [parameters sdl_objectForName:SDLRPCParameterNameDriverDistractionStatus];
}

@end

NS_ASSUME_NONNULL_END
