//  SDLHeadLampStatus.m
//

#import "SDLHeadLampStatus.h"

#import "SDLAmbientLightStatus.h"
#import "SDLNames.h"

@implementation SDLHeadLampStatus

- (void)setLowBeamsOn:(NSNumber<SDLBool> *)lowBeamsOn {
    [self setObject:lowBeamsOn forName:SDLNameLowBeamsOn];
}

- (NSNumber<SDLBool> *)lowBeamsOn {
    return [self objectForName:SDLNameLowBeamsOn];
}

- (void)setHighBeamsOn:(NSNumber<SDLBool> *)highBeamsOn {
    [self setObject:highBeamsOn forName:SDLNameHighBeamsOn];
}

- (NSNumber<SDLBool> *)highBeamsOn {
    return [self objectForName:SDLNameHighBeamsOn];
}

- (void)setAmbientLightSensorStatus:(SDLAmbientLightStatus)ambientLightSensorStatus {
    [self setObject:ambientLightSensorStatus forName:SDLNameAmbientLightSensorStatus];
}

- (SDLAmbientLightStatus)ambientLightSensorStatus {
    return [self objectForName:SDLNameAmbientLightSensorStatus];
}

@end
