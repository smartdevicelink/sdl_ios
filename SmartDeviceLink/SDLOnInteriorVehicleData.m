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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnInteriorVehicleData]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setModuleData:(SDLModuleData *)moduleData {
    [self.parameters sdl_setObject:moduleData forName:SDLRPCParameterNameModuleData];
}

- (SDLModuleData *)moduleData {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameModuleData ofClass:SDLModuleData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
