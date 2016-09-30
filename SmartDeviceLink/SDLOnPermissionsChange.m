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

- (void)setPermissionItem:(NSMutableArray *)permissionItem {
    if (permissionItem != nil) {
        [parameters setObject:permissionItem forKey:SDLNamePermissionItem];
    } else {
        [parameters removeObjectForKey:SDLNamePermissionItem];
    }
}

- (NSMutableArray *)permissionItem {
    NSMutableArray *array = [parameters objectForKey:SDLNamePermissionItem];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLPermissionItem.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLPermissionItem alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
