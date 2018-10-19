//
//  SDLRemoteControlCapabilities.m
//

#import "SDLAudioControlCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLClimateControlCapabilities.h"
#import "SDLHMISettingsControlCapabilities.h"
#import "SDLLightControlCapabilities.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRadioControlCapabilities.h"
#import "SDLSeatControlCapabilities.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRemoteControlCapabilities

- (instancetype)initWithClimateControlCapabilities:(nullable NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities radioControlCapabilities:(nullable NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {

    return [self initWithClimateControlCapabilities:climateControlCapabilities radioControlCapabilities:radioControlCapabilities buttonCapabilities:buttonCapabilities seatControlCapabilities:nil audioControlCapabilities:nil hmiSettingsControlCapabilities:nil lightControlCapabilities:nil];
}

- (instancetype)initWithClimateControlCapabilities:(nullable NSArray<SDLClimateControlCapabilities *> *)climateControlCapabilities radioControlCapabilities:(nullable NSArray<SDLRadioControlCapabilities *> *)radioControlCapabilities buttonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities seatControlCapabilities:(nullable NSArray<SDLSeatControlCapabilities *> *)seatControlCapabilities audioControlCapabilities:(nullable NSArray<SDLAudioControlCapabilities *> *)audioControlCapabilities hmiSettingsControlCapabilities:(nullable NSArray<SDLHMISettingsControlCapabilities *> *)hmiSettingsControlCapabilities lightControlCapabilities:(nullable NSArray<SDLLightControlCapabilities *> *)lightControlCapabilities {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.climateControlCapabilities = climateControlCapabilities;
    self.radioControlCapabilities = radioControlCapabilities;
    self.buttonCapabilities = buttonCapabilities;
    self.seatControlCapabilities = seatControlCapabilities;
    self.audioControlCapabilities = audioControlCapabilities;
    self.hmiSettingsControlCapabilities = hmiSettingsControlCapabilities;
    self.lightControlCapabilities = lightControlCapabilities;

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

- (void)setSeatControlCapabilities:(nullable NSArray<SDLSeatControlCapabilities *> *)seatControlCapabilities {
    [store sdl_setObject:seatControlCapabilities forName:SDLNameSeatControlCapabilities];
}

- (nullable NSArray<SDLSeatControlCapabilities *> *)seatControlCapabilities {
    return [store sdl_objectsForName:SDLNameSeatControlCapabilities ofClass:SDLSeatControlCapabilities.class];
}

- (void)setAudioControlCapabilities:(nullable NSArray<SDLAudioControlCapabilities *> *)audioControlCapabilities {
    [store sdl_setObject:audioControlCapabilities forName:SDLNameAudioControlCapabilities];
}

- (nullable NSArray<SDLAudioControlCapabilities *> *)audioControlCapabilities {
    return [store sdl_objectsForName:SDLNameAudioControlCapabilities ofClass:SDLAudioControlCapabilities.class];

}

- (void)setHmiSettingsControlCapabilities:(nullable NSArray<SDLHMISettingsControlCapabilities *> *)hmiSettingsControlCapabilities {
    [store sdl_setObject:hmiSettingsControlCapabilities forName:SDLNameHmiSettingsControlCapabilities];
}

- (nullable NSArray<SDLHMISettingsControlCapabilities *> *)hmiSettingsControlCapabilities {
    return [store sdl_objectsForName:SDLNameHmiSettingsControlCapabilities ofClass:SDLHMISettingsControlCapabilities.class];
}

- (void)setLightControlCapabilities:(nullable NSArray<SDLLightControlCapabilities *> *)lightControlCapabilities {
    [store sdl_setObject:lightControlCapabilities forName:SDLNameLightControlCapabilities];
}

- (nullable NSArray<SDLLightControlCapabilities *> *)lightControlCapabilities {
    return [store sdl_objectsForName:SDLNameLightControlCapabilities ofClass:SDLLightControlCapabilities.class];
}

@end

NS_ASSUME_NONNULL_END
