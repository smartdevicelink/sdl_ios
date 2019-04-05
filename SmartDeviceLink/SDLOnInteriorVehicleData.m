//
//  SDLOnInteriorVehicleData.m
//

#import "SDLOnInteriorVehicleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLModuleData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnInteriorVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnInteriorVehicleData]) {
    }
    return self;
}

- (void)setModuleData:(SDLModuleData *)moduleData {
    [parameters sdl_setObject:moduleData forName:SDLRPCParameterNameModuleData];
}

- (SDLModuleData *)moduleData {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameModuleData ofClass:SDLModuleData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
