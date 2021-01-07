//  SDLECallInfo.m
//

#import "SDLECallInfo.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLECallInfo

- (instancetype)initWithECallNotificationStatus:(SDLVehicleDataNotificationStatus)eCallNotificationStatus auxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus eCallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.eCallNotificationStatus = eCallNotificationStatus;
    self.auxECallNotificationStatus = auxECallNotificationStatus;
    self.eCallConfirmationStatus = eCallConfirmationStatus;
    return self;
}

- (void)setECallNotificationStatus:(SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    [self.store sdl_setObject:eCallNotificationStatus forName:SDLRPCParameterNameECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameECallNotificationStatus error:&error];
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    [self.store sdl_setObject:auxECallNotificationStatus forName:SDLRPCParameterNameAuxECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameAuxECallNotificationStatus error:&error];
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus {
    [self.store sdl_setObject:eCallConfirmationStatus forName:SDLRPCParameterNameECallConfirmationStatus];
}

- (SDLECallConfirmationStatus)eCallConfirmationStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameECallConfirmationStatus error:&error];
}

@end

NS_ASSUME_NONNULL_END
