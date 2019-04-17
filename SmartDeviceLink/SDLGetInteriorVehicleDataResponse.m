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

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetInteriorVehicleData]) {
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

- (void)setIsSubscribed:(nullable NSNumber<SDLBool> *)isSubscribed {
    [parameters sdl_setObject:isSubscribed forName:SDLRPCParameterNameIsSubscribed];
}

- (nullable NSNumber<SDLBool> *)isSubscribed {
    return [parameters sdl_objectForName:SDLRPCParameterNameIsSubscribed ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END

