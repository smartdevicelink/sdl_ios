//  SDLECallInfo.m
//

#import "SDLECallInfo.h"

#import "SDLNames.h"


@implementation SDLECallInfo

- (void)setECallNotificationStatus:(SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    [self setObject:eCallNotificationStatus forName:SDLNameECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    return [self objectForName:SDLNameECallNotificationStatus];
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    [self setObject:auxECallNotificationStatus forName:SDLNameAuxECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    return [self objectForName:SDLNameAuxECallNotificationStatus];
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus {
    [self setObject:eCallConfirmationStatus forName:SDLNameECallConfirmationStatus];
}

- (SDLECallConfirmationStatus)eCallConfirmationStatus {
    return [self objectForName:SDLNameECallConfirmationStatus];
}

@end
