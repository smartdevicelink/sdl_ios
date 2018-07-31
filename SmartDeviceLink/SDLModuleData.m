//
//  SDLModuleData.m
//

#import "SDLModuleData.h"
#import "SDLNames.h"
#import "SDLClimateControlData.h"
#import "SDLRadioControlData.h"
#import "SDLSeatControlData.h"
#import "SDLAudioControlData.h"
#import "SDLLightControlData.h"
#import "SDLHMISettingsControlData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLModuleData

- (instancetype)initWithRadioControlData:(SDLRadioControlData *)radioControlData  {
    self = [self init];
    if(!self){
        return nil;
    }
    
    self.moduleType = SDLModuleTypeRadio;
    self.radioControlData = radioControlData;

    return self;
}

- (instancetype)initWithClimateControlData:(SDLClimateControlData *)climateControlData {
    self = [self init];
    if(!self){
        return nil;
    }
    
    self.moduleType = SDLModuleTypeClimate;
    self.climateControlData = climateControlData;
    
    return self;
}

- (instancetype)initWithAudioControlData:(SDLAudioControlData *)audioControlData {
    self = [self init];
    if(!self){
        return nil;
    }

    self.moduleType = SDLModuleTypeAudio;
    self.audioControlData = audioControlData;

    return self;
}

- (instancetype)initWithLightControlData:(SDLLightControlData *)lightControlData {
    self = [self init];
    if(!self){
        return nil;
    }

    self.moduleType = SDLModuleTypeLight;
    self.lightControlData = lightControlData;

    return self;
}

- (instancetype)initWithHMISettingsControlData:(SDLHMISettingsControlData *)hmiSettingsControlData {
    self = [self init];
    if(!self){
        return nil;
    }

    self.moduleType = SDLModuleTypeHMISettings;
    self.hmiSettingsControlData = hmiSettingsControlData;

    return self;
}

- (instancetype)initWithSeatControlData:(SDLSeatControlData *)seatControlData {
    self = [self init];
    if(!self){
        return nil;
    }

    self.moduleType = SDLModuleTypeSeat;
    self.seatControlData = seatControlData;

    return self;
}

- (void)setModuleType:(SDLModuleType)moduleType {
    [store sdl_setObject:moduleType forName:SDLNameModuleType];
}

- (SDLModuleType)moduleType {
    return [store sdl_objectForName:SDLNameModuleType];
}

- (void)setRadioControlData:(nullable SDLRadioControlData *)radioControlData {
    [store sdl_setObject:radioControlData forName:SDLNameRadioControlData];
}

- (nullable SDLRadioControlData *)radioControlData {
    return [store sdl_objectForName:SDLNameRadioControlData ofClass:SDLRadioControlData.class];
}

- (void)setClimateControlData:(nullable SDLClimateControlData *)climateControlData {
    [store sdl_setObject:climateControlData forName:SDLNameClimateControlData];
}

- (nullable SDLClimateControlData *)climateControlData {
    return [store sdl_objectForName:SDLNameClimateControlData ofClass:SDLClimateControlData.class];
}

- (void)setSeatControlData:(nullable SDLSeatControlData *)seatControlData {
    [store sdl_setObject:seatControlData forName:SDLNameSeatControlData];
}

- (nullable SDLSeatControlData *)seatControlData {
    return [store sdl_objectForName:SDLNameSeatControlData ofClass:SDLSeatControlData.class];
}

- (void)setAudioControlData:(nullable SDLAudioControlData *)audioControlData {
    [store sdl_setObject:audioControlData forName:SDLNameAudioControlData];
}

- (nullable SDLAudioControlData *)audioControlData {
    return [store sdl_objectForName:SDLNameAudioControlData ofClass:SDLAudioControlData.class];
}

- (void)setLightControlData:(nullable SDLLightControlData *)lightControlData {
    [store sdl_setObject:lightControlData forName:SDLNameLightControlData];
}

- (nullable SDLLightControlData *)lightControlData {
    return [store sdl_objectForName:SDLNameLightControlData ofClass:SDLLightControlData.class];
}

- (void)setHmiSettingsControlData:(nullable SDLHMISettingsControlData *)hmiSettingsControlData {
    [store sdl_setObject:hmiSettingsControlData forName:SDLNameHmiSettingsControlData];
}

- (nullable SDLHMISettingsControlData *)hmiSettingsControlData {
    return [store sdl_objectForName:SDLNameHmiSettingsControlData ofClass:SDLHMISettingsControlData.class];
}

@end

NS_ASSUME_NONNULL_END
