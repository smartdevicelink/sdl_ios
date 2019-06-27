//  SDLSliderResponse.m
//


#import "SDLSliderResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSliderResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSlider]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setSliderPosition:(nullable NSNumber<SDLInt> *)sliderPosition {
    [self.parameters sdl_setObject:sliderPosition forName:SDLRPCParameterNameSliderPosition];
}

- (nullable NSNumber<SDLInt> *)sliderPosition {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSliderPosition ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
