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
    return [parameters sdl_objectForName:SDLRPCParameterNameAllowed ofClass:NSNumber.class error:nil];
}

- (void)setAllowed:(nullable NSNumber<SDLBool> *)allowed {
    [parameters sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (void)setAllocatedModules:(NSArray<SDLModuleData *> *)allocatedModules {
    [parameters sdl_setObject:allocatedModules forName:SDLRPCParameterNameAllocatedModules];

}

- (NSArray<SDLModuleData *> *)allocatedModules {
    NSError *error = nil;
    return [parameters sdl_objectsForName:SDLRPCParameterNameAllocatedModules ofClass:SDLModuleData.class error:&error];
}

- (void)setFreeModules:(NSArray<SDLModuleData *> *)freeModules {
    [parameters sdl_setObject:freeModules forName:SDLRPCParameterNameFreeModules];
}

- (NSArray<SDLModuleData *> *)freeModules {
    NSError *error = nil;
    return [parameters sdl_objectsForName:SDLRPCParameterNameFreeModules ofClass:SDLModuleData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
