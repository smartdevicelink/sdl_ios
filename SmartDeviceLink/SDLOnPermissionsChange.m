//  SDLOnPermissionsChange.m
//

#import "SDLOnPermissionsChange.h"

#import "SDLNames.h"
#import "SDLPermissionItem.h"


@implementation SDLOnPermissionsChange

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnPermissionsChange]) {
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
        [parameters setObject:permissionItem forKey:NAMES_permissionItem];
    } else {
        [parameters removeObjectForKey:NAMES_permissionItem];
    }
}

- (NSMutableArray<SDLPermissionItem *> *)permissionItem {
    NSMutableArray<SDLPermissionItem *> *array = [parameters objectForKey:NAMES_permissionItem];
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
