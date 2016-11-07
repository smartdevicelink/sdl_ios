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

- (instancetype)initWithProperties:(NSArray<SDLGlobalProperty> *)properties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.properties = [properties mutableCopy];

    return self;
}

- (void)setProperties:(NSMutableArray<SDLGlobalProperty> *)properties {
    [self setObject:properties forName:SDLNameProperties];
}

- (NSMutableArray<SDLGlobalProperty> *)properties {
    NSMutableArray<SDLGlobalProperty> *array = [parameters objectForKey:SDLNameProperties];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLGlobalProperty> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLGlobalProperty)enumString];
        }
        return newList;
    }
}

@end
