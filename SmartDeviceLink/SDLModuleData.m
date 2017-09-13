//
//  SDLModuleData.m
//

#import "SDLModuleData.h"
#import "SDLNames.h"
#import "SDLClimateControlData.h"
#import "SDLRadioControlData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLModuleData

-(instancetype) init {
    self = [super init];
    
    if(!self){
        return nil;
    }
    
    return self;
}

-(instancetype) initWithModuleType: (SDLModuleType)moduleType radioControlData: (SDLRadioControlData *) radioControlData climateControlData: (SDLClimateControlData *) climateControlData {
    self = [self init];
    
    self.moduleType = moduleType;
    self.radioControlData = radioControlData;
    self.climateControlData = climateControlData;
    
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
@end

NS_ASSUME_NONNULL_END
