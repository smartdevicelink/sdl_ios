//  SDLHeadLampStatus.m
//

#import "SDLHeadLampStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAmbientLightStatus.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHeadLampStatus

- (void)setLowBeamsOn:(NSNumber<SDLBool> *)lowBeamsOn {
    [store sdl_setObject:lowBeamsOn forName:SDLNameLowBeamsOn];
}

- (NSNumber<SDLBool> *)lowBeamsOn {
    return [store sdl_objectForName:SDLNameLowBeamsOn];
}

- (void)setHighBeamsOn:(NSNumber<SDLBool> *)highBeamsOn {
    [store sdl_setObject:highBeamsOn forName:SDLNameHighBeamsOn];
}

- (NSNumber<SDLBool> *)highBeamsOn {
    return [store sdl_objectForName:SDLNameHighBeamsOn];
}

- (void)setAmbientLightSensorStatus:(nullable SDLAmbientLightStatus)ambientLightSensorStatus {
    [store sdl_setObject:ambientLightSensorStatus forName:SDLNameAmbientLightSensorStatus];
}

- (nullable SDLAmbientLightStatus)ambientLightSensorStatus {
    return [store sdl_objectForName:SDLNameAmbientLightSensorStatus];
}

@end

NS_ASSUME_NONNULL_END
