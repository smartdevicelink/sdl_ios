//  SDLResetGlobalProperties.m
//


#import "SDLResetGlobalProperties.h"

#import "SDLGlobalProperty.h"
#import "SDLNames.h"

@implementation SDLResetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:NAMES_ResetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithProperties:(NSArray *)properties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.properties = [properties mutableCopy];

    return self;
}

- (void)setProperties:(NSMutableArray *)properties {
    if (properties != nil) {
        [parameters setObject:properties forKey:NAMES_properties];
    } else {
        [parameters removeObjectForKey:NAMES_properties];
    }
}

- (NSMutableArray *)properties {
    NSMutableArray *array = [parameters objectForKey:NAMES_properties];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLGlobalProperty.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLGlobalProperty valueOf:enumString]];
        }
        return newList;
    }
}

@end
