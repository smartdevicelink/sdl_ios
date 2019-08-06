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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation SDLOnLockScreenStatus
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnLockScreenStatus]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setLockScreenStatus:(SDLLockScreenStatus)lockScreenStatus {
    [self.parameters sdl_setObject:lockScreenStatus forName:SDLRPCParameterNameOnLockScreenStatus];
}

- (SDLLockScreenStatus)lockScreenStatus {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameOnLockScreenStatus error:&error];
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    [self.parameters sdl_setObject:hmiLevel forName:SDLRPCParameterNameHMILevel];
}

- (SDLHMILevel)hmiLevel {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameHMILevel error:&error];
}

- (void)setUserSelected:(NSNumber<SDLBool> *)userSelected {
    [self.parameters sdl_setObject:userSelected forName:SDLRPCParameterNameUserSelected];
}

- (NSNumber<SDLBool> *)userSelected {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameUserSelected ofClass:NSNumber.class error:&error];
}

- (void)setDriverDistractionStatus:(NSNumber<SDLBool> *)driverDistractionStatus {
    [self.parameters sdl_setObject:driverDistractionStatus forName:SDLRPCParameterNameDriverDistractionStatus];
}

- (NSNumber<SDLBool> *)driverDistractionStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDriverDistractionStatus ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
