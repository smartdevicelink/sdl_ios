//
//  SDLModuleData.m
//

#import "SDLModuleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLClimateControlData.h"
#import "SDLRadioControlData.h"
#import "SDLSeatControlData.h"
#import "SDLAudioControlData.h"
#import "SDLLightControlData.h"
#import "SDLHMISettingsControlData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLModuleData

- (instancetype)initWithModuleType:(SDLModuleType)moduleType {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.moduleType = moduleType;
    return self;
}

- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleId:(nullable NSString *)moduleId radioControlData:(nullable SDLRadioControlData *)radioControlData climateControlData:(nullable SDLClimateControlData *)climateControlData seatControlData:(nullable SDLSeatControlData *)seatControlData audioControlData:(nullable SDLAudioControlData *)audioControlData lightControlData:(nullable SDLLightControlData *)lightControlData hmiSettingsControlData:(nullable SDLHMISettingsControlData *)hmiSettingsControlData {
    self = [self initWithModuleType:moduleType];
    if (!self) {
        return nil;
    }
    self.moduleId = moduleId;
    self.radioControlData = radioControlData;
    self.climateControlData = climateControlData;
    self.seatControlData = seatControlData;
    self.audioControlData = audioControlData;
    self.lightControlData = lightControlData;
    self.hmiSettingsControlData = hmiSettingsControlData;
    return self;
}

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
    [self.store sdl_setObject:moduleType forName:SDLRPCParameterNameModuleType];
}

- (SDLModuleType)moduleType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameModuleType error:&error];
}

- (void)setModuleId:(nullable NSString *)moduleId {
    [self.store sdl_setObject:moduleId forName:SDLRPCParameterNameModuleId];
}

- (nullable NSString *)moduleId {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameModuleId error:&error];
}

- (void)setRadioControlData:(nullable SDLRadioControlData *)radioControlData {
    [self.store sdl_setObject:radioControlData forName:SDLRPCParameterNameRadioControlData];
}

- (nullable SDLRadioControlData *)radioControlData {
    return [self.store sdl_objectForName:SDLRPCParameterNameRadioControlData ofClass:SDLRadioControlData.class error:nil];
}

- (void)setClimateControlData:(nullable SDLClimateControlData *)climateControlData {
    [self.store sdl_setObject:climateControlData forName:SDLRPCParameterNameClimateControlData];
}

- (nullable SDLClimateControlData *)climateControlData {
    return [self.store sdl_objectForName:SDLRPCParameterNameClimateControlData ofClass:SDLClimateControlData.class error:nil];
}

- (void)setSeatControlData:(nullable SDLSeatControlData *)seatControlData {
    [self.store sdl_setObject:seatControlData forName:SDLRPCParameterNameSeatControlData];
}

- (nullable SDLSeatControlData *)seatControlData {
    return [self.store sdl_objectForName:SDLRPCParameterNameSeatControlData ofClass:SDLSeatControlData.class error:nil];
}

- (void)setAudioControlData:(nullable SDLAudioControlData *)audioControlData {
    [self.store sdl_setObject:audioControlData forName:SDLRPCParameterNameAudioControlData];
}

- (nullable SDLAudioControlData *)audioControlData {
    return [self.store sdl_objectForName:SDLRPCParameterNameAudioControlData ofClass:SDLAudioControlData.class error:nil];
}

- (void)setLightControlData:(nullable SDLLightControlData *)lightControlData {
    [self.store sdl_setObject:lightControlData forName:SDLRPCParameterNameLightControlData];
}

- (nullable SDLLightControlData *)lightControlData {
    return [self.store sdl_objectForName:SDLRPCParameterNameLightControlData ofClass:SDLLightControlData.class error:nil];
}

- (void)setHmiSettingsControlData:(nullable SDLHMISettingsControlData *)hmiSettingsControlData {
    [self.store sdl_setObject:hmiSettingsControlData forName:SDLRPCParameterNameHmiSettingsControlData];
}

- (nullable SDLHMISettingsControlData *)hmiSettingsControlData {
    return [self.store sdl_objectForName:SDLRPCParameterNameHmiSettingsControlData ofClass:SDLHMISettingsControlData.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
