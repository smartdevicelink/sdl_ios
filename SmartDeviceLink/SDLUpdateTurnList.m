//  SDLUpdateTurnList.m
//


#import "SDLUpdateTurnList.h"


#import "SDLSoftButton.h"
#import "SDLTurn.h"

@implementation SDLUpdateTurnList

- (instancetype)init {
    if (self = [super initWithName:SDLNameUpdateTurnList]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setTurnList:(NSMutableArray *)turnList {
    if (turnList != nil) {
        [parameters setObject:turnList forKey:SDLNameTurnList];
    } else {
        [parameters removeObjectForKey:SDLNameTurnList];
    }
}

- (NSMutableArray *)turnList {
    NSMutableArray *array = [parameters objectForKey:SDLNameTurnList];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTurn.class]) {
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
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
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
