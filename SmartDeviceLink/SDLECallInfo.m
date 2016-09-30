//  SDLECallInfo.m
//

#import "SDLECallInfo.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLNames.h"
#import "SDLVehicleDataNotificationStatus.h"


@implementation SDLECallInfo

- (void)setECallNotificationStatus:(SDLVehicleDataNotificationStatus *)eCallNotificationStatus {
    if (eCallNotificationStatus != nil) {
        [store setObject:eCallNotificationStatus forKey:SDLNameECallNotificationStatus];
    } else {
        [store removeObjectForKey:SDLNameECallNotificationStatus];
    }
}

- (SDLVehicleDataNotificationStatus *)eCallNotificationStatus {
    NSObject *obj = [store objectForKey:SDLNameECallNotificationStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataNotificationStatus.class]) {
        return (SDLVehicleDataNotificationStatus *)obj;
    } else {
        return [SDLVehicleDataNotificationStatus valueOf:(NSString *)obj];
    }
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus *)auxECallNotificationStatus {
    if (auxECallNotificationStatus != nil) {
        [store setObject:auxECallNotificationStatus forKey:SDLNameAuxECallNotificationStatus];
    } else {
        [store removeObjectForKey:SDLNameAuxECallNotificationStatus];
    }
}

- (SDLVehicleDataNotificationStatus *)auxECallNotificationStatus {
    NSObject *obj = [store objectForKey:SDLNameAuxECallNotificationStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataNotificationStatus.class]) {
        return (SDLVehicleDataNotificationStatus *)obj;
    } else {
        return [SDLVehicleDataNotificationStatus valueOf:(NSString *)obj];
    }
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus *)eCallConfirmationStatus {
    if (eCallConfirmationStatus != nil) {
        [store setObject:eCallConfirmationStatus forKey:SDLNameECallConfirmationStatus];
    } else {
        [store removeObjectForKey:SDLNameECallConfirmationStatus];
    }
}

- (SDLECallConfirmationStatus *)eCallConfirmationStatus {
    NSObject *obj = [store objectForKey:SDLNameECallConfirmationStatus];
    if (obj == nil || [obj isKindOfClass:SDLECallConfirmationStatus.class]) {
        return (SDLECallConfirmationStatus *)obj;
    } else {
        return [SDLECallConfirmationStatus valueOf:(NSString *)obj];
    }
}

@end
