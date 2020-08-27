//  SDLBodyInformation.m
//


#import "SDLBodyInformation.h"

#import "NSMutableDictionary+Store.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLBodyInformation

- (void)setParkBrakeActive:(NSNumber<SDLBool> *)parkBrakeActive {
    [self.store sdl_setObject:parkBrakeActive forName:SDLRPCParameterNameParkBrakeActive];
}

- (NSNumber<SDLBool> *)parkBrakeActive {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameParkBrakeActive ofClass:NSNumber.class error:&error];
}

- (void)setIgnitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus {
    [self.store sdl_setObject:ignitionStableStatus forName:SDLRPCParameterNameIgnitionStableStatus];
}

- (SDLIgnitionStableStatus)ignitionStableStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameIgnitionStableStatus error:&error];
}

- (void)setIgnitionStatus:(SDLIgnitionStatus)ignitionStatus {
    [self.store sdl_setObject:ignitionStatus forName:SDLRPCParameterNameIgnitionStatus];
}

- (SDLIgnitionStatus)ignitionStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameIgnitionStatus error:&error];
}

- (void)setDriverDoorAjar:(nullable NSNumber<SDLBool> *)driverDoorAjar {
    [self.store sdl_setObject:driverDoorAjar forName:SDLRPCParameterNameDriverDoorAjar];
}

- (nullable NSNumber<SDLBool> *)driverDoorAjar {
    return [self.store sdl_objectForName:SDLRPCParameterNameDriverDoorAjar ofClass:NSNumber.class error:nil];
}

- (void)setPassengerDoorAjar:(nullable NSNumber<SDLBool> *)passengerDoorAjar {
    [self.store sdl_setObject:passengerDoorAjar forName:SDLRPCParameterNamePassengerDoorAjar];
}

- (nullable NSNumber<SDLBool> *)passengerDoorAjar {
    return [self.store sdl_objectForName:SDLRPCParameterNamePassengerDoorAjar ofClass:NSNumber.class error:nil];
}

- (void)setRearLeftDoorAjar:(nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    [self.store sdl_setObject:rearLeftDoorAjar forName:SDLRPCParameterNameRearLeftDoorAjar];
}

- (nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    return [self.store sdl_objectForName:SDLRPCParameterNameRearLeftDoorAjar ofClass:NSNumber.class error:nil];
}

- (void)setRearRightDoorAjar:(nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    [self.store sdl_setObject:rearRightDoorAjar forName:SDLRPCParameterNameRearRightDoorAjar];
}

- (nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    return [self.store sdl_objectForName:SDLRPCParameterNameRearRightDoorAjar ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
