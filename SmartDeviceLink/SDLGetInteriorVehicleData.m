//
//  SDLGetInteriorVehicleData.m
//

#import "SDLGetInteriorVehicleData.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetInteriorVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetInteriorVehicleData]) {
    }
    return self;
}

- (instancetype)initWithType: (SDLModuleType )moduleType {
    self = [self init];
    
    self.moduleType = moduleType;
    
    return self;
}

- (instancetype)initWithSubscribe: (NSNumber<SDLBool> *)subscribe {
    self = [self init];
    
    self.subscribe = subscribe;
    
    return self;
}


- (void)setModuleType:(SDLModuleType )moduleType {
    [parameters sdl_setObject:moduleType forName:SDLNameModuleType];
}

- (SDLModuleType)moduleType {
    return [parameters sdl_objectForName:SDLNameModuleType];
}


- (void)setSubscribe:(NSNumber<SDLBool> *)subscribe {
    [parameters sdl_setObject:subscribe forName:SDLNameSubscribe_rc];
}

- (NSNumber<SDLBool> *)subscribe {
    return [parameters sdl_objectForName:SDLNameSubscribe_rc];
}

@end

NS_ASSUME_NONNULL_END
