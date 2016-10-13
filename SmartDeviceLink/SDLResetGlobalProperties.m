//  SDLResetGlobalProperties.m
//


#import "SDLResetGlobalProperties.h"

#import "SDLGlobalProperty.h"
#import "SDLNames.h"

@implementation SDLResetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameResetGlobalProperties]) {
    }
    return self;
}

- (void)setProperties:(NSMutableArray *)properties {
    if (properties != nil) {
        [parameters setObject:properties forKey:SDLNameProperties];
    } else {
        [parameters removeObjectForKey:SDLNameProperties];
    }
}

- (NSMutableArray *)properties {
    NSMutableArray *array = [parameters objectForKey:SDLNameProperties];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLGlobalProperty)enumString];
        }
        return newList;
    }
}

@end
