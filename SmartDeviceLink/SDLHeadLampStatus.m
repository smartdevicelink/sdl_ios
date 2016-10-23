//  SDLHeadLampStatus.m
//

#import "SDLHeadLampStatus.h"

#import "SDLAmbientLightStatus.h"
#import "SDLNames.h"

@implementation SDLHeadLampStatus

- (void)setLowBeamsOn:(NSNumber<SDLBool> *)lowBeamsOn {
    if (lowBeamsOn != nil) {
        [store setObject:lowBeamsOn forKey:SDLNameLowBeamsOn];
    } else {
        [store removeObjectForKey:SDLNameLowBeamsOn];
    }
}

- (NSNumber<SDLBool> *)lowBeamsOn {
    return [store objectForKey:SDLNameLowBeamsOn];
}

- (void)setHighBeamsOn:(NSNumber<SDLBool> *)highBeamsOn {
    if (highBeamsOn != nil) {
        [store setObject:highBeamsOn forKey:SDLNameHighBeamsOn];
    } else {
        [store removeObjectForKey:SDLNameHighBeamsOn];
    }
}

- (NSNumber<SDLBool> *)highBeamsOn {
    return [store objectForKey:SDLNameHighBeamsOn];
}

- (void)setAmbientLightSensorStatus:(SDLAmbientLightStatus)ambientLightSensorStatus {
    if (ambientLightSensorStatus != nil) {
        [store setObject:ambientLightSensorStatus forKey:SDLNameAmbientLightSensorStatus];
    } else {
        [store removeObjectForKey:SDLNameAmbientLightSensorStatus];
    }
}

- (SDLAmbientLightStatus)ambientLightSensorStatus {
    NSObject *obj = [store objectForKey:SDLNameAmbientLightSensorStatus];
    return (SDLAmbientLightStatus)obj;
}

@end
