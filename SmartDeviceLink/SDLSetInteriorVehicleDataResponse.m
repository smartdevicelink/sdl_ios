//
//  SDLSetInteriorVehicleDataResponse.m
//

#import "SDLSetInteriorVehicleDataResponse.h"
#import "SDLNames.h"
#import "SDLModuleData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetInteriorVehicleDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetInteriorVehicleData]) {
    }
    return self;
}

- (void)setModuleData:(SDLModuleData *)moduleData {
    [parameters sdl_setObject:moduleData forName:SDLNameModuleData];
}

- (SDLModuleData *)moduleData {
    NSError *error;
    return [parameters sdl_objectForName:SDLNameModuleData ofClass:SDLModuleData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
