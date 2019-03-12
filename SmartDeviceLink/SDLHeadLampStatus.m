//  SDLHeadLampStatus.m
//

#import "SDLHeadLampStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAmbientLightStatus.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHeadLampStatus

- (void)setLowBeamsOn:(NSNumber<SDLBool> *)lowBeamsOn {
    [store sdl_setObject:lowBeamsOn forName:SDLRPCParameterNameLowBeamsOn];
}

- (NSNumber<SDLBool> *)lowBeamsOn {
    return [store sdl_objectForName:SDLRPCParameterNameLowBeamsOn];
}

- (void)setHighBeamsOn:(NSNumber<SDLBool> *)highBeamsOn {
    [store sdl_setObject:highBeamsOn forName:SDLRPCParameterNameHighBeamsOn];
}

- (NSNumber<SDLBool> *)highBeamsOn {
    return [store sdl_objectForName:SDLRPCParameterNameHighBeamsOn];
}

- (void)setAmbientLightSensorStatus:(nullable SDLAmbientLightStatus)ambientLightSensorStatus {
    [store sdl_setObject:ambientLightSensorStatus forName:SDLRPCParameterNameAmbientLightSensorStatus];
}

- (nullable SDLAmbientLightStatus)ambientLightSensorStatus {
    return [store sdl_objectForName:SDLRPCParameterNameAmbientLightSensorStatus];
}

@end

NS_ASSUME_NONNULL_END
