//  SDLSeatControlData.m
//

#import "SDLSeatControlData.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

#import "SDLMassageModeData.h"
#import "SDLMassageCushionFirmness.h"
#import "SDLSeatMemoryAction.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSeatControlData

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat {
#pragma clang diagnostic pop
    self = [self init];
    if (!self) {
        return nil;
    }
    self.id = supportedSeat;
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat heatingEnabled:(BOOL)heatingEnable coolingEnable:(BOOL)coolingEnabled heatingLevel:(UInt8)heatingLevel coolingLevel:(UInt8)coolingLevel horizontalPostion:(UInt8)horizontal verticalPostion:(UInt8)vertical frontVerticalPostion:(UInt8)frontVertical backVerticalPostion:(UInt8)backVertical backTiltAngle:(UInt8)backAngle headSupportedHorizontalPostion:(UInt8)headSupportedHorizontal headSupportedVerticalPostion:(UInt8)headSupportedVertical massageEnabled:(BOOL)massageEnable massageMode:(NSArray<SDLMassageModeData *> *)massageMode massageCussionFirmness:(NSArray<SDLMassageCushionFirmness *> *)firmness memory:(SDLSeatMemoryAction *)memoryAction {
#pragma clang diagnostic pop

    self = [self initWithHeatingEnabled:@(heatingEnable) coolingEnabled:@(coolingEnabled) heatingLevel:@(heatingLevel) coolingLevel:@(coolingLevel) horizontalPosition:@(horizontal) verticalPosition:@(vertical) frontVerticalPosition:@(frontVertical) backVerticalPosition:@(backVertical) backTiltAngle:@(backAngle) headSupportHorizontalPosition:@(headSupportedHorizontal) headSupportVerticalPosition:@(headSupportedVertical) massageEnabled:@(massageEnable) massageMode:massageMode massageCushionFirmness:firmness memory:memoryAction];
    if (!self) {
        return nil;
    }

    self.id = supportedSeat;

    return self;
}

- (instancetype)initWithHeatingEnabled:(nullable NSNumber<SDLBool> *)heatingEnabled coolingEnabled:(nullable NSNumber<SDLBool> *)coolingEnabled heatingLevel:(nullable NSNumber<SDLUInt> *)heatingLevel coolingLevel:(nullable NSNumber<SDLUInt> *)coolingLevel horizontalPosition:(nullable NSNumber<SDLUInt> *)horizontalPosition verticalPosition:(nullable NSNumber<SDLUInt> *)verticalPosition frontVerticalPosition:(nullable NSNumber<SDLUInt> *)frontVerticalPosition backVerticalPosition:(nullable NSNumber<SDLUInt> *)backVerticalPosition backTiltAngle:(nullable NSNumber<SDLUInt> *)backTiltAngle headSupportHorizontalPosition:(nullable NSNumber<SDLUInt> *)headSupportHorizontalPosition headSupportVerticalPosition:(nullable NSNumber<SDLUInt> *)headSupportVerticalPosition massageEnabled:(nullable NSNumber<SDLBool> *)massageEnabled massageMode:(nullable NSArray<SDLMassageModeData *> *)massageMode massageCushionFirmness:(nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness memory:(nullable SDLSeatMemoryAction *)memory {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.heatingEnabled = heatingEnabled;
    self.coolingEnabled = coolingEnabled;
    self.heatingLevel = heatingLevel;
    self.coolingLevel = coolingLevel;

    self.horizontalPosition = horizontalPosition;
    self.verticalPosition = verticalPosition;
    self.frontVerticalPosition = frontVerticalPosition;
    self.backVerticalPosition = backVerticalPosition;
    self.backTiltAngle = backTiltAngle;

    self.headSupportHorizontalPosition = headSupportHorizontalPosition;
    self.headSupportVerticalPosition = headSupportVerticalPosition;

    self.massageEnabled = massageEnabled;
    self.massageMode = massageMode;
    self.massageCushionFirmness = massageCushionFirmness;
    self.memory = memory;

    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)setId:(SDLSupportedSeat)id {
#pragma clang diagnostic pop
    [self.store sdl_setObject:id forName:SDLRPCParameterNameId];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (SDLSupportedSeat)id {
#pragma clang diagnostic pop
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameId error:&error];
}

- (void)setHeatingEnabled:(nullable NSNumber<SDLBool> *)heatingEnabled {
    [self.store sdl_setObject:heatingEnabled forName:SDLRPCParameterNameHeatingEnabled];
}

- (nullable NSNumber<SDLBool> *)heatingEnabled {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatingEnabled ofClass:NSNumber.class error:nil];
}

- (void)setCoolingEnabled:(nullable NSNumber<SDLBool> *)coolingEnabled {
    [self.store sdl_setObject:coolingEnabled forName:SDLRPCParameterNameCoolingEnabled];
}

- (nullable NSNumber<SDLBool> *)coolingEnabled {
    return [self.store sdl_objectForName:SDLRPCParameterNameCoolingEnabled ofClass:NSNumber.class error:nil];
}

- (void)setHeatingLevel:(nullable NSNumber<SDLInt> *)heatingLevel {
    [self.store sdl_setObject:heatingLevel forName:SDLRPCParameterNameHeatingLevel];
}

- (nullable NSNumber<SDLInt> *)heatingLevel {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatingLevel ofClass:NSNumber.class error:nil];
}

- (void)setCoolingLevel:(nullable NSNumber<SDLInt> *)coolingLevel {
    [self.store sdl_setObject:coolingLevel forName:SDLRPCParameterNameCoolingLevel];
}

- (nullable NSNumber<SDLInt> *)coolingLevel {
    return [self.store sdl_objectForName:SDLRPCParameterNameCoolingLevel ofClass:NSNumber.class error:nil];
}

- (void)setHorizontalPosition:(nullable NSNumber<SDLInt> *)horizontalPosition {
    [self.store sdl_setObject:horizontalPosition forName:SDLRPCParameterNameHorizontalPosition];
}

- (nullable NSNumber<SDLInt> *)horizontalPosition {
    return [self.store sdl_objectForName:SDLRPCParameterNameHorizontalPosition ofClass:NSNumber.class error:nil];
}

- (void)setVerticalPosition:(nullable NSNumber<SDLInt> *)verticalPosition {
    [self.store sdl_setObject:verticalPosition forName:SDLRPCParameterNameVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)verticalPosition {
    return [self.store sdl_objectForName:SDLRPCParameterNameVerticalPosition ofClass:NSNumber.class error:nil];
}

- (void)setFrontVerticalPosition:(nullable NSNumber<SDLInt> *)frontVerticalPosition {
    [self.store sdl_setObject:frontVerticalPosition forName:SDLRPCParameterNameFrontVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)frontVerticalPosition {
    return [self.store sdl_objectForName:SDLRPCParameterNameFrontVerticalPosition ofClass:NSNumber.class error:nil];
}

- (void)setBackVerticalPosition:(nullable NSNumber<SDLInt> *)backVerticalPosition {
    [self.store sdl_setObject:backVerticalPosition forName:SDLRPCParameterNameBackVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)backVerticalPosition {
    return [self.store sdl_objectForName:SDLRPCParameterNameBackVerticalPosition ofClass:NSNumber.class error:nil];
}

- (void)setBackTiltAngle:(nullable NSNumber<SDLInt> *)backTiltAngle {
    [self.store sdl_setObject:backTiltAngle forName:SDLRPCParameterNameBackTiltAngle];
}

- (nullable NSNumber<SDLInt> *)backTiltAngle {
    return [self.store sdl_objectForName:SDLRPCParameterNameBackTiltAngle ofClass:NSNumber.class error:nil];
}

-  (void)setHeadSupportHorizontalPosition:(nullable NSNumber<SDLInt> *)headSupportHorizontalPosition {
    [self.store sdl_setObject:headSupportHorizontalPosition forName:SDLRPCParameterNameHeadSupportHorizontalPosition];
}

- (nullable NSNumber<SDLInt> *)headSupportHorizontalPosition {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeadSupportHorizontalPosition ofClass:NSNumber.class error:nil];
}

-(void)setHeadSupportVerticalPosition:(nullable NSNumber<SDLInt> *)headSupportVerticalPosition {
    [self.store sdl_setObject:headSupportVerticalPosition forName:SDLRPCParameterNameHeadSupportVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)headSupportVerticalPosition {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeadSupportVerticalPosition ofClass:NSNumber.class error:nil];
}

- (void)setMassageEnabled:(nullable NSNumber<SDLBool> *)massageEnabled {
    [self.store sdl_setObject:massageEnabled forName:SDLRPCParameterNameMassageEnabled];
}

- (nullable NSNumber<SDLBool> *)massageEnabled {
    return [self.store sdl_objectForName:SDLRPCParameterNameMassageEnabled ofClass:NSNumber.class error:nil];

}

- (void)setMassageMode:(nullable NSArray<SDLMassageModeData *> *)massageMode {
    [self.store sdl_setObject:massageMode forName:SDLRPCParameterNameMassageMode];
}

- (nullable NSArray<SDLMassageModeData *> *)massageMode {
   return [self.store sdl_objectsForName:SDLRPCParameterNameMassageMode ofClass:SDLMassageModeData.class error:nil];
}

- (void)setMassageCushionFirmness:(nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness {
    [self.store sdl_setObject:massageCushionFirmness forName:SDLRPCParameterNameMassageCushionFirmness];
}

- (nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness {
    return [self.store sdl_objectsForName:SDLRPCParameterNameMassageCushionFirmness ofClass:SDLMassageCushionFirmness.class error:nil];
}

- (void)setMemory:(nullable SDLSeatMemoryAction *)memory {
    [self.store sdl_setObject:memory forName:SDLRPCParameterNameMemory];
}

- (nullable SDLSeatMemoryAction *)memory {
    return [self.store sdl_objectForName:SDLRPCParameterNameMemory ofClass:SDLSeatMemoryAction.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
