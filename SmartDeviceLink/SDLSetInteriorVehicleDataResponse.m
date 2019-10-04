//
//  SDLSetInteriorVehicleDataResponse.m
//

#import "SDLSetInteriorVehicleDataResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLModuleData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetInteriorVehicleDataResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetInteriorVehicleData]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setModuleData:(nullable SDLModuleData *)moduleData {
    [self.parameters sdl_setObject:moduleData forName:SDLRPCParameterNameModuleData];
}

- (nullable SDLModuleData *)moduleData {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameModuleData ofClass:SDLModuleData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
