//  SDLSliderResponse.m
//


#import "SDLSliderResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSliderResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSlider]) {
    }
    return self;
}

- (void)setSliderPosition:(nullable NSNumber<SDLInt> *)sliderPosition {
    [parameters sdl_setObject:sliderPosition forName:SDLRPCParameterNameSliderPosition];
}

- (nullable NSNumber<SDLInt> *)sliderPosition {
    return [parameters sdl_objectForName:SDLRPCParameterNameSliderPosition ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
