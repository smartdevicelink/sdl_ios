//
//  SDLLockScreenStatusInfo.m
//  SmartDeviceLink
//

#import "SDLLockScreenStatusInfo.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMILevel.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLockScreenStatusInfo

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _lockScreenStatus = SDLLockScreenStatusOff;

    return self;
}

- (instancetype)initWithDriverDistractionStatus:(nullable NSNumber<SDLBool> *)driverDistractionStatus userSelected:(nullable NSNumber<SDLBool> *)userSelected lockScreenStatus:(SDLLockScreenStatus)lockScreenStatus hmiLevel:(nullable SDLHMILevel)hmiLevel {
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
    return [NSString stringWithFormat:@"driverDistractionStatus: %@, userSelected: %@, lockScreenStatus: %@, hmiLevel: %@", (self.driverDistractionStatus ? @"ON" : @"OFF"), (self.userSelected ? @"YES" : @"NO"), [self descriptionForStatus:self.lockScreenStatus], self.hmiLevel];
}

- (NSString *)descriptionForStatus:(SDLLockScreenStatus)status {
    switch (status) {
        case SDLLockScreenStatusOff: return @"Off";
        case SDLLockScreenStatusOptional: return @"Optional";
        case SDLLockScreenStatusRequired: return @"Required";
    }
}

@end

NS_ASSUME_NONNULL_END
