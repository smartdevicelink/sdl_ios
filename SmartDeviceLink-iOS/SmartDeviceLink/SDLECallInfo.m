//  SDLECallInfo.m
//

#import "SDLECallInfo.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLNames.h"
#import "SDLVehicleDataNotificationStatus.h"


@implementation SDLECallInfo

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setECallNotificationStatus:(SDLVehicleDataNotificationStatus *)eCallNotificationStatus {
    if (eCallNotificationStatus != nil) {
        [store setObject:eCallNotificationStatus forKey:NAMES_eCallNotificationStatus];
    } else {
        [store removeObjectForKey:NAMES_eCallNotificationStatus];
    }
}

- (SDLVehicleDataNotificationStatus *)eCallNotificationStatus {
    NSObject *obj = [store objectForKey:NAMES_eCallNotificationStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataNotificationStatus.class]) {
        return (SDLVehicleDataNotificationStatus *)obj;
    } else {
        return [SDLVehicleDataNotificationStatus valueOf:(NSString *)obj];
    }
}

- (void)setAuxECallNotificationStatus:(SDLVehicleDataNotificationStatus *)auxECallNotificationStatus {
    if (auxECallNotificationStatus != nil) {
        [store setObject:auxECallNotificationStatus forKey:NAMES_auxECallNotificationStatus];
    } else {
        [store removeObjectForKey:NAMES_auxECallNotificationStatus];
    }
}

- (SDLVehicleDataNotificationStatus *)auxECallNotificationStatus {
    NSObject *obj = [store objectForKey:NAMES_auxECallNotificationStatus];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataNotificationStatus.class]) {
        return (SDLVehicleDataNotificationStatus *)obj;
    } else {
        return [SDLVehicleDataNotificationStatus valueOf:(NSString *)obj];
    }
}

- (void)setECallConfirmationStatus:(SDLECallConfirmationStatus *)eCallConfirmationStatus {
    if (eCallConfirmationStatus != nil) {
        [store setObject:eCallConfirmationStatus forKey:NAMES_eCallConfirmationStatus];
    } else {
        [store removeObjectForKey:NAMES_eCallConfirmationStatus];
    }
}

- (SDLECallConfirmationStatus *)eCallConfirmationStatus {
    NSObject *obj = [store objectForKey:NAMES_eCallConfirmationStatus];
    if (obj == nil || [obj isKindOfClass:SDLECallConfirmationStatus.class]) {
        return (SDLECallConfirmationStatus *)obj;
    } else {
        return [SDLECallConfirmationStatus valueOf:(NSString *)obj];
    }
}

@end
