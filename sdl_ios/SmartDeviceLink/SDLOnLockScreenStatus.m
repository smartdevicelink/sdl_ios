//
//  SDLOnLockScreenStatus.m
//  SmartDeviceLink
//

#import "SDLOnLockScreenStatus.h"

@implementation SDLOnLockScreenStatus

- (id)init {
    if (self = [super initWithName:@"OnLockScreenStatus"]) {

    }
    return self;
}

- (id)initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {

    }
    return self;
}

- (void)setLockScreenStatus:(SDLLockScreenStatus *)lockScreenStatus {
    [parameters setOrRemoveObject:lockScreenStatus forKey:@"OnLockScreenStatus"];
}

- (SDLLockScreenStatus *)lockScreenStatus {
    NSObject* obj = [parameters objectForKey:@"OnLockScreenStatus"];
    if ([obj isKindOfClass:SDLLockScreenStatus.class]) {
        return (SDLLockScreenStatus*)obj;
    } else {
        return [SDLLockScreenStatus valueOf:(NSString*)obj];
    }
}

- (void)setHmiLevel:(SDLHMILevel *)hmiLevel {
    [parameters setOrRemoveObject:hmiLevel forKey:@"hmilevel"];
}

- (SDLHMILevel *)hmiLevel {
    NSObject* obj = [parameters objectForKey:@"hmilevel"];
    if ([obj isKindOfClass:SDLLockScreenStatus.class]) {
        return (SDLHMILevel *)obj;
    } else {
        return [SDLHMILevel valueOf:(NSString*)obj];
    }
}

- (void)setUserSelected:(NSNumber *)userSelected {
    [parameters setOrRemoveObject:userSelected forKey:@"userselected"];
}

- (NSNumber *)userSelected {
    return [parameters objectForKey:@"userselected"];
}

- (void)setDriverDistractionStatus:(NSNumber *)driverDistractionStatus {
    [parameters setOrRemoveObject:driverDistractionStatus forKey:@"driverdistractionstatus"];
}

- (NSNumber *)driverDistractionStatus {
    return [parameters objectForKey:@"driverdistractionstatus"];
}

@end
