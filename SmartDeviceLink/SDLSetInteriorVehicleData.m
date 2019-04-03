//
//  SDLSetInteriorVehicleData.m
//

#import "SDLSetInteriorVehicleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLModuleData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetInteriorVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetInteriorVehicleData]) {
    }
    return self;
}

- (instancetype)initWithModuleData:(SDLModuleData *)moduleData {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.moduleData = moduleData;
    
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
