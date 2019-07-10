//  SDLOnRCStatus.m
//

#import "SDLOnRCStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLModuleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnRCStatus

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnRCStatus]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (nullable NSNumber<SDLBool> *)allowed {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAllowed ofClass:NSNumber.class error:nil];
}

- (void)setAllowed:(nullable NSNumber<SDLBool> *)allowed {
    [self.parameters sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (void)setAllocatedModules:(NSArray<SDLModuleData *> *)allocatedModules {
    [self.parameters sdl_setObject:allocatedModules forName:SDLRPCParameterNameAllocatedModules];

}

- (NSArray<SDLModuleData *> *)allocatedModules {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameAllocatedModules ofClass:SDLModuleData.class error:&error];
}

- (void)setFreeModules:(NSArray<SDLModuleData *> *)freeModules {
    [self.parameters sdl_setObject:freeModules forName:SDLRPCParameterNameFreeModules];
}

- (NSArray<SDLModuleData *> *)freeModules {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameFreeModules ofClass:SDLModuleData.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
