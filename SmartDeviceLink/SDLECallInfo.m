//  SDLECallInfo.m
//

#import "SDLECallInfo.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLECallInfo

- (void)setECallNotificationStatus:(SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    [store sdl_setObject:eCallNotificationStatus forName:SDLNameECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNameECallNotificationStatus error:&error];
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    [store sdl_setObject:auxECallNotificationStatus forName:SDLNameAuxECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNameAuxECallNotificationStatus error:&error];
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus {
    [store sdl_setObject:eCallConfirmationStatus forName:SDLNameECallConfirmationStatus];
}

- (SDLECallConfirmationStatus)eCallConfirmationStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNameECallConfirmationStatus error:&error];
}

@end

NS_ASSUME_NONNULL_END
