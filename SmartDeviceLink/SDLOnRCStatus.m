//  SDLOnRCStatus.m
//

#import "SDLOnRCStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLModuleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnRCStatus

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnRCStatus]) {
    }
    return self;
}

- (nullable NSNumber<SDLBool> *)allowed {
    return [parameters sdl_objectForName:SDLRPCParameterNameAllowed];
}

- (void)setAllowed:(nullable NSNumber<SDLBool> *)allowed {
    [parameters sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (void)setAllocatedModules:(NSArray<SDLModuleData *> *)allocatedModules {
    [parameters sdl_setObject:allocatedModules forName:SDLRPCParameterNameAllocatedModules];

}

- (NSArray<SDLModuleData *> *)allocatedModules {
    return [parameters sdl_objectsForName:SDLRPCParameterNameAllocatedModules ofClass:SDLModuleData.class];
}

- (void)setFreeModules:(NSArray<SDLModuleData *> *)freeModules {
    [parameters sdl_setObject:freeModules forName:SDLRPCParameterNameFreeModules];
}

- (NSArray<SDLModuleData *> *)freeModules {
    return [parameters sdl_objectsForName:SDLRPCParameterNameFreeModules ofClass:SDLModuleData.class];
}

@end

NS_ASSUME_NONNULL_END
