//
//  SDLOnInteriorVehicleData.m
//

#import "SDLOnInteriorVehicleData.h"
#import "SDLNames.h"
#import "SDLModuleData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnInteriorVehicleData


- (instancetype)init {
    if (self = [super initWithName:SDLNameOnInteriorVehicleData]) {
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
