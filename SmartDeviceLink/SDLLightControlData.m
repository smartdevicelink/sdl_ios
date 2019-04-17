//  SDLLightControlData.m
//

#import "SDLLightControlData.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLLightState.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLightControlData

-(instancetype)initWithLightStates:(NSArray<SDLLightState *> *)lightState {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.lightState = lightState;

    return self;
}

- (void)setLightState:(NSArray<SDLLightState *> *)lightState {
    [store sdl_setObject:lightState forName:SDLRPCParameterNameLightState];
}

- (NSArray<SDLLightState *> *)lightState {
    NSError *error = nil;
    return [store sdl_objectsForName:SDLRPCParameterNameLightState ofClass:SDLLightState.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
