//
//  SDLSetInteriorVehicleData.m
//

#import "SDLSetInteriorVehicleData.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLModuleData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetInteriorVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetInteriorVehicleData]) {
    }
    return self;
}

- (void)setModuleData:(SDLModuleData *)moduleData {
    [parameters sdl_setObject:moduleData forName:SDLNameModuleData];
}

- (SDLModuleData *)moduleData {
    return [parameters sdl_objectForName:SDLNameModuleData];
}

@end

NS_ASSUME_NONNULL_END
