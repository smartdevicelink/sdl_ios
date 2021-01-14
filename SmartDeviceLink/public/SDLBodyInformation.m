//  SDLBodyInformation.m
//


#import "NSMutableDictionary+Store.h"
#import "SDLBodyInformation.h"
#import "SDLDoorStatus.h"
#import "SDLGateStatus.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLRoofStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLBodyInformation

- (instancetype)initWithParkBrakeActive:(BOOL)parkBrakeActive ignitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus ignitionStatus:(SDLIgnitionStatus)ignitionStatus {
    self = [self init];
    if (self) {
        self.parkBrakeActive = @(parkBrakeActive);
        self.ignitionStableStatus = ignitionStableStatus;
        self.ignitionStatus = ignitionStatus;
    }
    return self;
}

- (instancetype)initWithParkBrakeActive:(BOOL)parkBrakeActive ignitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus ignitionStatus:(SDLIgnitionStatus)ignitionStatus doorStatuses:(nullable NSArray<SDLDoorStatus *> *)doorStatuses gateStatuses:(nullable NSArray<SDLGateStatus *> *)gateStatuses roofStatuses:(nullable NSArray<SDLRoofStatus *> *)roofStatuses {
    self = [self initWithParkBrakeActive:parkBrakeActive ignitionStableStatus:ignitionStableStatus ignitionStatus:ignitionStatus];
    if (self) {
        self.doorStatuses = doorStatuses;
        self.gateStatuses = gateStatuses;
        self.roofStatuses = roofStatuses;
    }
    return self;
}

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

- (void)setDoorStatuses:(nullable NSArray<SDLDoorStatus *> *)doorStatuses {
    [self.store sdl_setObject:doorStatuses forName:SDLRPCParameterNameDoorStatuses];
}

- (nullable NSArray<SDLDoorStatus *> *)doorStatuses {
    return [self.store sdl_objectsForName:SDLRPCParameterNameDoorStatuses ofClass:SDLDoorStatus.class error:nil];
}

- (void)setGateStatuses:(nullable NSArray<SDLGateStatus *> *)gateStatuses {
    [self.store sdl_setObject:gateStatuses forName:SDLRPCParameterNameGateStatuses];
}

- (nullable NSArray<SDLGateStatus *> *)gateStatuses {
    return [self.store sdl_objectsForName:SDLRPCParameterNameGateStatuses ofClass:SDLGateStatus.class error:nil];
}

- (void)setRoofStatuses:(nullable NSArray<SDLRoofStatus *> *)roofStatuses {
    [self.store sdl_setObject:roofStatuses forName:SDLRPCParameterNameRoofStatuses];
}

- (nullable NSArray<SDLRoofStatus *> *)roofStatuses {
    return [self.store sdl_objectsForName:SDLRPCParameterNameRoofStatuses ofClass:SDLRoofStatus.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
