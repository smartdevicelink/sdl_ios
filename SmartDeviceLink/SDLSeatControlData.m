//  SDLSeatControlData.m
//

#import "SDLSeatControlData.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

#import "SDLMassageModeData.h"
#import "SDLMassageCushionFirmness.h"
#import "SDLSeatMemoryAction.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSeatControlData

- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat {
    if (self = [super init]) {
        self.id = supportedSeat;
    }
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
    [store sdl_setObject:id forName:SDLNameId];
}

- (SDLSupportedSeat)id {
    return [store sdl_objectForName:SDLNameId];
}

- (void)setHeatingEnabled:(nullable NSNumber<SDLBool> *)heatingEnabled {
    [store sdl_setObject:heatingEnabled forName:SDLNameHeatingEnabled];
}

- (nullable NSNumber<SDLBool> *)heatingEnabled {
    return [store sdl_objectForName:SDLNameHeatingEnabled];
}

- (void)setCoolingEnabled:(nullable NSNumber<SDLBool> *)coolingEnabled {
    [store sdl_setObject:coolingEnabled forName:SDLNameCoolingEnabled];
}

- (nullable NSNumber<SDLBool> *)coolingEnabled {
    return [store sdl_objectForName:SDLNameCoolingEnabled];
}

- (void)setHeatingLevel:(nullable NSNumber<SDLInt> *)heatingLevel {
    [store sdl_setObject:heatingLevel forName:SDLNameHeatingLevel];
}

- (nullable NSNumber<SDLInt> *)heatingLevel {
    return [store sdl_objectForName:SDLNameHeatingLevel];
}

- (void)setCoolingLevel:(nullable NSNumber<SDLInt> *)coolingLevel {
    [store sdl_setObject:coolingLevel forName:SDLNameCoolingLevel];
}

- (nullable NSNumber<SDLInt> *)coolingLevel {
    return [store sdl_objectForName:SDLNameCoolingLevel];
}

- (void)setHorizontalPosition:(nullable NSNumber<SDLInt> *)horizontalPosition {
    [store sdl_setObject:horizontalPosition forName:SDLNameHorizontalPosition];
}

- (nullable NSNumber<SDLInt> *)horizontalPosition {
    return [store sdl_objectForName:SDLNameHorizontalPosition];
}

- (void)setVerticalPosition:(nullable NSNumber<SDLInt> *)verticalPosition {
    [store sdl_setObject:verticalPosition forName:SDLNameVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)verticalPosition {
    return [store sdl_objectForName:SDLNameVerticalPosition];
}

- (void)setFrontVerticalPosition:(nullable NSNumber<SDLInt> *)frontVerticalPosition {
    [store sdl_setObject:frontVerticalPosition forName:SDLNameFrontVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)frontVerticalPosition {
    return [store sdl_objectForName:SDLNameFrontVerticalPosition];
}

- (void)setBackVerticalPosition:(nullable NSNumber<SDLInt> *)backVerticalPosition {
    [store sdl_setObject:backVerticalPosition forName:SDLNameBackVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)backVerticalPosition {
    return [store sdl_objectForName:SDLNameBackVerticalPosition];
}

- (void)setBackTiltAngle:(nullable NSNumber<SDLInt> *)backTiltAngle {
    [store sdl_setObject:backTiltAngle forName:SDLNameBackTiltAngle];
}

- (nullable NSNumber<SDLInt> *)backTiltAngle {
    return [store sdl_objectForName:SDLNameBackTiltAngle];
}

-  (void)setHeadSupportHorizontalPosition:(nullable NSNumber<SDLInt> *)headSupportHorizontalPosition {
    [store sdl_setObject:headSupportHorizontalPosition forName:SDLNameHeadSupportHorizontalPosition];
}

- (nullable NSNumber<SDLInt> *)headSupportHorizontalPosition {
    return [store sdl_objectForName:SDLNameHeadSupportHorizontalPosition];
}

-(void)setHeadSupportVerticalPosition:(nullable NSNumber<SDLInt> *)headSupportVerticalPosition {
    [store sdl_setObject:headSupportVerticalPosition forName:SDLNameHeadSupportVerticalPosition];
}

- (nullable NSNumber<SDLInt> *)headSupportVerticalPosition {
    return [store sdl_objectForName:SDLNameHeadSupportVerticalPosition];
}

- (void)setMassageEnabled:(nullable NSNumber<SDLBool> *)massageEnabled {
    [store sdl_setObject:massageEnabled forName:SDLNameMassageEnabled];
}

- (nullable NSNumber<SDLBool> *)massageEnabled {
    return [store sdl_objectForName:SDLNameMassageEnabled];

}

- (void)setMassageMode:(nullable NSArray<SDLMassageModeData *> *)massageMode {
    [store sdl_setObject:massageMode forName:SDLNameMassageMode];
}

- (nullable NSArray<SDLMassageModeData *> *)massageMode {
   return [store sdl_objectForName:SDLNameMassageMode ];
}

- (void)setMassageCushionFirmness:(nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness {
    [store sdl_setObject:massageCushionFirmness forName:SDLNameMassageCushionFirmness];
}

- (nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness {
    return [store sdl_objectForName:SDLNameMassageCushionFirmness];
}

- (void)setMemory:(nullable SDLSeatMemoryAction *)memory {
    [store sdl_setObject:memory forName:SDLNameMemory];
}

- (nullable SDLSeatMemoryAction *)memory {
    return [store sdl_objectForName:SDLNameMemory ofClass:SDLSeatMemoryAction.class];
}

@end

NS_ASSUME_NONNULL_END
