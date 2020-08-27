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

- (instancetype)initWithDriverDistractionStatus:(nullable NSNumber<SDLBool> *)driverDistractionStatus userSelected:(nullable NSNumber<SDLBool> *)userSelected lockScreenStatus:(nullable SDLLockScreenStatus)lockScreenStatus hmiLevel:(nullable SDLHMILevel)hmiLevel {
    self = [self init];
    if (!self) {
        return nil;
    }
    _driverDistractionStatus = driverDistractionStatus;
    _userSelected = userSelected;
    _lockScreenStatus = lockScreenStatus;
    _hmiLevel = hmiLevel;

    return self;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"driverDistractionStatus: %@, userSelected: %@, lockScreenStatus: %@, hmiLevel: %@", self.driverDistractionStatus, self.userSelected, self.lockScreenStatus, self.hmiLevel];

    return description;
}

@end

NS_ASSUME_NONNULL_END
