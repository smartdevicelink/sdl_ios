//  SDLHeadLampStatus.m
//

#import "SDLHeadLampStatus.h"

#import "SDLAmbientLightStatus.h"



@implementation SDLHeadLampStatus

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

- (void)setLowBeamsOn:(NSNumber *)lowBeamsOn {
    if (lowBeamsOn != nil) {
        [store setObject:lowBeamsOn forKey:SDLNameLowBeamsOn];
    } else {
        [store removeObjectForKey:SDLNameLowBeamsOn];
    }
}

- (NSNumber *)lowBeamsOn {
    return [store objectForKey:SDLNameLowBeamsOn];
}

- (void)setHighBeamsOn:(NSNumber *)highBeamsOn {
    if (highBeamsOn != nil) {
        [store setObject:highBeamsOn forKey:SDLNameHighBeamsOn];
    } else {
        [store removeObjectForKey:SDLNameHighBeamsOn];
    }
}

- (NSNumber *)highBeamsOn {
    return [store objectForKey:SDLNameHighBeamsOn];
}

- (void)setAmbientLightSensorStatus:(SDLAmbientLightStatus *)ambientLightSensorStatus {
    if (ambientLightSensorStatus != nil) {
        [store setObject:ambientLightSensorStatus forKey:SDLNameAmbientLightSensorStatus];
    } else {
        [store removeObjectForKey:SDLNameAmbientLightSensorStatus];
    }
}

- (SDLAmbientLightStatus *)ambientLightSensorStatus {
    NSObject *obj = [store objectForKey:SDLNameAmbientLightSensorStatus];
    if (obj == nil || [obj isKindOfClass:SDLAmbientLightStatus.class]) {
        return (SDLAmbientLightStatus *)obj;
    } else {
        return [SDLAmbientLightStatus valueOf:(NSString *)obj];
    }
}

@end
