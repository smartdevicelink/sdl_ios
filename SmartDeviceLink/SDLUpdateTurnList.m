//  SDLUpdateTurnList.m
//


#import "SDLUpdateTurnList.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTurn.h"

@implementation SDLUpdateTurnList

- (instancetype)init {
    if (self = [super initWithName:NAMES_UpdateTurnList]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithTurnList:(NSArray<SDLTurn *> *)turnList softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.turnList = [turnList mutableCopy];
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setTurnList:(NSMutableArray *)turnList {
    if (turnList != nil) {
        [parameters setObject:turnList forKey:NAMES_turnList];
    } else {
        [parameters removeObjectForKey:NAMES_turnList];
    }
}

- (NSMutableArray *)turnList {
    NSMutableArray *array = [parameters objectForKey:NAMES_turnList];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLTurn.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTurn alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:NAMES_softButtons];
    } else {
        [parameters removeObjectForKey:NAMES_softButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:NAMES_softButtons];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

@end
