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
    return [store sdl_objectForName:SDLRPCParameterNameECallNotificationStatus];
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    [store sdl_setObject:auxECallNotificationStatus forName:SDLRPCParameterNameAuxECallNotificationStatus];
}

- (SDLVehicleDataNotificationStatus)auxECallNotificationStatus {
    return [store sdl_objectForName:SDLRPCParameterNameAuxECallNotificationStatus];
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus)eCallConfirmationStatus {
    [store sdl_setObject:eCallConfirmationStatus forName:SDLRPCParameterNameECallConfirmationStatus];
}

- (SDLECallConfirmationStatus)eCallConfirmationStatus {
    return [store sdl_objectForName:SDLRPCParameterNameECallConfirmationStatus];
}

@end

NS_ASSUME_NONNULL_END
