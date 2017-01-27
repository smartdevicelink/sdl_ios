//  SDLOnPermissionsChange.m
//

#import "SDLOnPermissionsChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLPermissionItem.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnPermissionsChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnPermissionsChange]) {
    }
    return self;
}

- (void)setPermissionItem:(NSArray<SDLPermissionItem *> *)permissionItem {
    [parameters sdl_setObject:permissionItem forName:SDLNamePermissionItem];
}

- (NSArray<SDLPermissionItem *> *)permissionItem {
    return [parameters sdl_objectsForName:SDLNamePermissionItem ofClass:SDLPermissionItem.class];
}

@end

NS_ASSUME_NONNULL_END
