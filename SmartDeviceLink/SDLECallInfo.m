//  SDLECallInfo.m
//

#import "SDLECallInfo.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLECallInfo

- (void)setECallNotificationStatus:(SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    if (eCallNotificationStatus != nil) {
        [store setObject:eCallNotificationStatus forKey:SDLNameECallNotificationStatus];
    } else {
        [store removeObjectForKey:SDLNameECallNotificationStatus];
    }
}

- (SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    NSObject *obj = [store objectForKey:SDLNameECallNotificationStatus];
    return (SDLVehicleDataNotificationStatus)obj;
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    if (auxECallNotificationStatus != nil) {
        [store setObject:auxECallNotificationStatus forKey:SDLNameAuxECallNotificationStatus];
    } else {
        [store removeObjectForKey:SDLNameAuxECallNotificationStatus];
    }
}

- (SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    NSObject *obj = [store objectForKey:SDLNameAuxECallNotificationStatus];
    return (SDLVehicleDataNotificationStatus)obj;
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus {
    if (eCallConfirmationStatus != nil) {
        [store setObject:eCallConfirmationStatus forKey:SDLNameECallConfirmationStatus];
    } else {
        [store removeObjectForKey:SDLNameECallConfirmationStatus];
    }
}

- (SDLECallConfirmationStatus)eCallConfirmationStatus {
    NSObject *obj = [store objectForKey:SDLNameECallConfirmationStatus];
    return (SDLECallConfirmationStatus)obj;
}

@end

NS_ASSUME_NONNULL_END
