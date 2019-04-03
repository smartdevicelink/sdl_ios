//  SDLECallInfo.m
//

#import "SDLECallInfo.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLECallInfo

- (void)setECallNotificationStatus:(SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    [store sdl_setObject:eCallNotificationStatus forName:SDLRPCParameterNameECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)eCallNotificationStatus {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameECallNotificationStatus error:&error];
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    [store sdl_setObject:auxECallNotificationStatus forName:SDLRPCParameterNameAuxECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameAuxECallNotificationStatus error:&error];
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus {
    [store sdl_setObject:eCallConfirmationStatus forName:SDLRPCParameterNameECallConfirmationStatus];
}

- (SDLECallConfirmationStatus)eCallConfirmationStatus {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameECallConfirmationStatus error:&error];
}

@end

NS_ASSUME_NONNULL_END
