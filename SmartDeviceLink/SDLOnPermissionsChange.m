//  SDLOnPermissionsChange.m
//

#import "SDLOnPermissionsChange.h"

#import "SDLNames.h"
#import "SDLPermissionItem.h"

@implementation SDLOnPermissionsChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnPermissionsChange]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setPermissionItem:(NSMutableArray<SDLPermissionItem *> *)permissionItem {
    if (permissionItem != nil) {
        [parameters setObject:permissionItem forKey:SDLNamePermissionItem];
    } else {
        [parameters removeObjectForKey:SDLNamePermissionItem];
    }
}

- (NSMutableArray<SDLPermissionItem *> *)permissionItem {
    NSMutableArray<SDLPermissionItem *> *array = [parameters objectForKey:SDLNamePermissionItem];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLPermissionItem.class]) {
        return array;
    } else {
        NSMutableArray<SDLPermissionItem *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLPermissionItem alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

@end
