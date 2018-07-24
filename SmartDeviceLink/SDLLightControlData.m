//  SDLLightControlData.m
//

#import "SDLLightControlData.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLLightState.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLightControlData

-(instancetype)initWithLightStateArray:(NSArray<SDLLightState *> *)lightState {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.lightState = lightState;

    return self;
}

- (void)setLightState:(NSArray<SDLLightState *> *)lightState {
    [store sdl_setObject:lightState forName:SDLNameLightState];
}

- (NSArray<SDLLightState *> *)lightState {
    return [store sdl_objectsForName:SDLNameLightState ofClass:SDLLightState.class];
}


@end

NS_ASSUME_NONNULL_END
