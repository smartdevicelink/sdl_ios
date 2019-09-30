//
//  SDLGetInteriorVehicleDataResponse.m
//

#import "SDLGetInteriorVehicleDataResponse.h"
#import "SDLModuleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN


@implementation SDLGetInteriorVehicleDataResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetInteriorVehicleData]) {
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

- (void)setIsSubscribed:(nullable NSNumber<SDLBool> *)isSubscribed {
    [self.parameters sdl_setObject:isSubscribed forName:SDLRPCParameterNameIsSubscribed];
}

- (nullable NSNumber<SDLBool> *)isSubscribed {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameIsSubscribed ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END

