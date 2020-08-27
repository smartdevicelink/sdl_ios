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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetInteriorVehicleData]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithModuleData:(SDLModuleData *)moduleData {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.moduleData = moduleData;
    
    return self;
}

- (void)setModuleData:(SDLModuleData *)moduleData {
    [self.parameters sdl_setObject:moduleData forName:SDLRPCParameterNameModuleData];
}

- (SDLModuleData *)moduleData {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameModuleData ofClass:SDLModuleData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
