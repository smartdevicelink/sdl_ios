//  SDLFuelRange.m
//


#import "SDLFuelRange.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLFuelRange

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)setFuelType:(nullable SDLFuelType)fuelType {
    [store sdl_setObject:fuelType forName:SDLNameFuelType];
}

- (nullable SDLFuelType)fuelType {
    return [store sdl_objectForName:SDLNameFuelType];

}

- (void)setFuelRange:(nullable NSNumber<SDLFloat> *)fuelRange {
    [store sdl_setObject:fuelRange forName:SDLNameFuelRange];
}

- (nullable NSNumber<SDLFloat> *)fuelRange {
    return [store sdl_objectForName:SDLNameFuelRange];
}


@end
NS_ASSUME_NONNULL_END
