//  SDLDeleteSubMenu.m
//


#import "SDLDeleteSubMenu.h"

#import "SDLNames.h"

@implementation SDLDeleteSubMenu

- (instancetype)init {
    if (self = [super initWithName:NAMES_DeleteSubMenu]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt32)menuId {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuID = @(menuId);

    return self;
}

- (void)setMenuID:(NSNumber *)menuID {
    if (menuID != nil) {
        [parameters setObject:menuID forKey:NAMES_menuID];
    } else {
        [parameters removeObjectForKey:NAMES_menuID];
    }
}

- (NSNumber *)menuID {
    return [parameters objectForKey:NAMES_menuID];
}

@end
