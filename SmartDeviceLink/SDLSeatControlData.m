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

- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.id = supportedSeat;
    
    return self;
}

- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat heatingEnabled:(BOOL)heatingEnable coolingEnable:(BOOL)coolingEnabled heatingLevel:(UInt8)heatingLevel coolingLevel:(UInt8)coolingLevel horizontalPostion:(UInt8)horizontal verticalPostion:(UInt8)vertical frontVerticalPostion:(UInt8)frontVertical backVerticalPostion:(UInt8)backVertical backTiltAngle:(UInt8)backAngle headSupportedHorizontalPostion:(UInt8)headSupportedHorizontal headSupportedVerticalPostion:(UInt8)headSupportedVertical massageEnabled:(BOOL)massageEnable massageMode:(NSArray<SDLMassageModeData *> *)massageMode massageCussionFirmness:(NSArray<SDLMassageCushionFirmness *> *)firmness memory:(SDLSeatMemoryAction *)memoryAction {

    self = [super init];
    if (!self) {
        return nil;
    }

    self.id = supportedSeat;
    self.heatingEnabled = @(heatingEnable);
    self.coolingEnabled = @(coolingEnabled);
    self.heatingLevel = @(heatingLevel);
    self.coolingLevel = @(coolingLevel);

    self.horizontalPosition = @(horizontal);
    self.verticalPosition = @(vertical);
    self.frontVerticalPosition = @(frontVertical);
    self.backVerticalPosition = @(backVertical);
    self.backTiltAngle = @(backAngle);

    self.headSupportHorizontalPosition = @(headSupportedHorizontal);
    self.headSupportVerticalPosition = @(headSupportedVertical);

    self.massageEnabled = @(massageEnable);
    self.massageMode = massageMode;
    self.massageCushionFirmness = firmness;
    self.memory = memoryAction;

    return self;
}

- (void)setId:(SDLSupportedSeat)id {
    [store sdl_setObject:id forName:SDLRPCParameterNameId];
}

- (SDLSupportedSeat)id {
    return [store sdl_objectForName:SDLRPCParameterNameId];
}

- (void)setHeatingEnabled:(nullable NSNumber<SDLBool> *)heatingEnabled {
    [store sdl_setObject:heatingEnabled forName:SDLRPCParameterNameHeatingEnabled];
}

- (nullable NSNumber<SDLBool> *)heatingEnabled {
    return [store sdl_objectForName:SDLRPCParameterNameHeatingEnabled];
}

- (void)setCoolingEnabled:(nullable NSNumber<SDLBool> *)coolingEnabled {
    [store sdl_setObject:coolingEnabled forName:SDLRPCParameterNameCoolingEnabled];
}

- (nullable NSNumber<SDLBool> *)coolingEnabled {
    return [store sdl_objectForName:SDLRPCParameterNameCoolingEnabled];
}

- (void)setHeatingLevel:(nullable NSNumber<SDLInt> *)heatingLevel {
    [store sdl_setObject:heatingLevel forName:SDLRPCParameterNameHeatingLevel];
}

- (nullable NSNumber<SDLInt> *)heatingLevel {
    return [store sdl_objectForName:SDLRPCParameterNameHeatingLevel];
}

- (void)setCoolingLevel:(nullable NSNumber<SDLInt> *)coolingLevel {
    [store sdl_setObject:coolingLevel forName:SDLRPCParameterNameCoolingLevel];
}

- (nullable NSNumber<SDLInt> *)coolingLevel {
    return [store sdl_objectForName:SDLRPCParameterNameCoolingLevel];
}

- (void)setHorizontalPosition:(nullable NSNumber<SDLInt> *)horizontalPosition {
    [store sdl_setObject:horizontalPosition forName:SDLRPCParameterNameHorizontalPosition];
}

- (nullable NSNumber<SDLInt> *)horizontalPosition {
    return [store sdl_objectForName:SDLRPCParameterNameHorizontalPosition];
}

- (void)setVerticalPosition:(nullable NSNumber<SDLInt> *)verticalPosition {
    [store sdl_setObject:verticalPosition forName:SDLRPCParameterNameVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)verticalPosition {
    return [store sdl_objectForName:SDLRPCParameterNameVerticalPosition];
}

- (void)setFrontVerticalPosition:(nullable NSNumber<SDLInt> *)frontVerticalPosition {
    [store sdl_setObject:frontVerticalPosition forName:SDLRPCParameterNameFrontVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)frontVerticalPosition {
    return [store sdl_objectForName:SDLRPCParameterNameFrontVerticalPosition];
}

- (void)setBackVerticalPosition:(nullable NSNumber<SDLInt> *)backVerticalPosition {
    [store sdl_setObject:backVerticalPosition forName:SDLRPCParameterNameBackVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)backVerticalPosition {
    return [store sdl_objectForName:SDLRPCParameterNameBackVerticalPosition];
}

- (void)setBackTiltAngle:(nullable NSNumber<SDLInt> *)backTiltAngle {
    [store sdl_setObject:backTiltAngle forName:SDLRPCParameterNameBackTiltAngle];
}

- (nullable NSNumber<SDLInt> *)backTiltAngle {
    return [store sdl_objectForName:SDLRPCParameterNameBackTiltAngle];
}

-  (void)setHeadSupportHorizontalPosition:(nullable NSNumber<SDLInt> *)headSupportHorizontalPosition {
    [store sdl_setObject:headSupportHorizontalPosition forName:SDLRPCParameterNameHeadSupportHorizontalPosition];
}

- (nullable NSNumber<SDLInt> *)headSupportHorizontalPosition {
    return [store sdl_objectForName:SDLRPCParameterNameHeadSupportHorizontalPosition];
}

-(void)setHeadSupportVerticalPosition:(nullable NSNumber<SDLInt> *)headSupportVerticalPosition {
    [store sdl_setObject:headSupportVerticalPosition forName:SDLRPCParameterNameHeadSupportVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)headSupportVerticalPosition {
    return [store sdl_objectForName:SDLRPCParameterNameHeadSupportVerticalPosition];
}

- (void)setMassageEnabled:(nullable NSNumber<SDLBool> *)massageEnabled {
    [store sdl_setObject:massageEnabled forName:SDLRPCParameterNameMassageEnabled];
}

- (nullable NSNumber<SDLBool> *)massageEnabled {
    return [store sdl_objectForName:SDLRPCParameterNameMassageEnabled];

}

- (void)setMassageMode:(nullable NSArray<SDLMassageModeData *> *)massageMode {
    [store sdl_setObject:massageMode forName:SDLRPCParameterNameMassageMode];
}

- (nullable NSArray<SDLMassageModeData *> *)massageMode {
   return [store sdl_objectForName:SDLRPCParameterNameMassageMode ];
}

- (void)setMassageCushionFirmness:(nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness {
    [store sdl_setObject:massageCushionFirmness forName:SDLRPCParameterNameMassageCushionFirmness];
}

- (nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness {
    return [store sdl_objectForName:SDLRPCParameterNameMassageCushionFirmness];
}

- (void)setMemory:(nullable SDLSeatMemoryAction *)memory {
    [store sdl_setObject:memory forName:SDLRPCParameterNameMemory];
}

- (nullable SDLSeatMemoryAction *)memory {
    return [store sdl_objectForName:SDLRPCParameterNameMemory ofClass:SDLSeatMemoryAction.class];
}

@end

NS_ASSUME_NONNULL_END
