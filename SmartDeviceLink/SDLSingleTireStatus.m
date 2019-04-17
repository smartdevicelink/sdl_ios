//  SDLSingleTireStatus.m
//

#import "SDLSingleTireStatus.h"

#import "NSMutableDictionary+Store.h"
#import "NSNumber+NumberType.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSingleTireStatus

- (void)setStatus:(SDLComponentVolumeStatus)status {
    [store sdl_setObject:status forName:SDLRPCParameterNameStatus];
}

- (SDLComponentVolumeStatus)status {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameStatus error:&error];
}

- (void)setMonitoringSystemStatus:(nullable SDLTPMS)monitoringSystemStatus {
    [store sdl_setObject:monitoringSystemStatus forName:SDLRPCParameterNameTPMS];
}

- (nullable SDLTPMS)monitoringSystemStatus {
    return [store sdl_enumForName:SDLRPCParameterNameTPMS error:nil];
}

- (void)setPressure:(nullable NSNumber<SDLFloat> *)pressure {
    [store sdl_setObject:pressure forName:SDLRPCParameterNamePressure];
}

- (nullable NSNumber<SDLFloat> *)pressure {
    return [store sdl_objectForName:SDLRPCParameterNamePressure ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
