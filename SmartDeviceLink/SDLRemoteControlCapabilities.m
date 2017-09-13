//
//  SDLRemoteControlCapabilities.m
//

#import "SDLRemoteControlCapabilities.h"
#import "SDLClimateControlCapabilities.h"
#import "SDLRadioControlCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"


NS_ASSUME_NONNULL_BEGIN


@implementation SDLRemoteControlCapabilities

-(instancetype) init{
    self = [super init];
    
    if(!self){
        return nil;
    }
    
    return self;
}

-(instancetype) initWithClimateControlCapabilities:(NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities radioControlCapabilities:(NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities buttonCapabilities:(NSArray *)buttonCapabilities {
    self = [super init];
    
    self.climateControlCapabilities = climateControlCapabilities;
    self.radioControlCapabilities = radioControlCapabilities;
    self.buttonCapabilities = buttonCapabilities;
    
    return self;
}

- (void)setClimateControlCapabilities:(nullable NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities {
    [store sdl_setObject:climateControlCapabilities forName:SDLNameClimateControlCapabilities];
}

- (nullable NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities {
    return [store sdl_objectsForName:SDLNameClimateControlCapabilities ofClass:SDLClimateControlCapabilities.class];
}

-(void)setRadioControlCapabilities:(nullable NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities {
    [store sdl_setObject:radioControlCapabilities forName:SDLNameRadioControlCapabilities ];
}

- (nullable NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities {
    return [store sdl_objectsForName:SDLNameRadioControlCapabilities ofClass:SDLRadioControlCapabilities.class];
}

- (void)setButtonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [store sdl_setObject:buttonCapabilities forName:SDLNameButtonCapabilities];}

- (nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [store sdl_objectsForName:SDLNameButtonCapabilities ofClass:SDLButtonCapabilities.class];
}

@end

NS_ASSUME_NONNULL_END
