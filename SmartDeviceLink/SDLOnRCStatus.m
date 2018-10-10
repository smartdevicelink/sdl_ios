//  SDLOnRCStatus.m
//

#import "SDLOnRCStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLModuleData.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnRCStatus

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnRCStatus]) {
    }
    return self;
}

- (nullable NSNumber<SDLBool> *)allowed {
    return [parameters sdl_objectForName:SDLNameAllowed];
}

- (void)setAllowed:(nullable NSNumber<SDLBool> *)allowed {
    [parameters sdl_setObject:allowed forName:SDLNameAllowed];
}

- (void)setAllocatedModules:(NSArray<SDLModuleData *> *)allocatedModules {
    [parameters sdl_setObject:allocatedModules forName:SDLNameAllocatedModules];

}

- (NSArray<SDLModuleData *> *)allocatedModules {
    return [parameters sdl_objectsForName:SDLNameAllocatedModules ofClass:SDLModuleData.class];
}

- (void)setFreeModules:(NSArray<SDLModuleData *> *)freeModules {
    [parameters sdl_setObject:freeModules forName:SDLNameFreeModules];
}

- (NSArray<SDLModuleData *> *)freeModules {
    return [parameters sdl_objectsForName:SDLNameFreeModules ofClass:SDLModuleData.class];
}

@end

NS_ASSUME_NONNULL_END
