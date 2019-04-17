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
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameLowBeamsOn ofClass:NSNumber.class error:&error];
}

- (void)setHighBeamsOn:(NSNumber<SDLBool> *)highBeamsOn {
    [store sdl_setObject:highBeamsOn forName:SDLRPCParameterNameHighBeamsOn];
}

- (NSNumber<SDLBool> *)highBeamsOn {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameHighBeamsOn ofClass:NSNumber.class error:&error];
}

- (void)setAmbientLightSensorStatus:(nullable SDLAmbientLightStatus)ambientLightSensorStatus {
    [store sdl_setObject:ambientLightSensorStatus forName:SDLRPCParameterNameAmbientLightSensorStatus];
}

- (nullable SDLAmbientLightStatus)ambientLightSensorStatus {
    return [store sdl_enumForName:SDLRPCParameterNameAmbientLightSensorStatus error:nil];
}

@end

NS_ASSUME_NONNULL_END
