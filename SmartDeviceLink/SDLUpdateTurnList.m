//  SDLUpdateTurnList.m
//


#import "SDLUpdateTurnList.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTurn.h"

@implementation SDLUpdateTurnList

- (instancetype)init {
    if (self = [super initWithName:SDLNameUpdateTurnList]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setTurnList:(NSMutableArray<SDLTurn *> *)turnList {
    if (turnList != nil) {
        [parameters setObject:turnList forKey:SDLNameTurnList];
    } else {
        [parameters removeObjectForKey:SDLNameTurnList];
    }
}

- (NSMutableArray<SDLTurn *> *)turnList {
    NSMutableArray<SDLTurn *> *array = [parameters objectForKey:SDLNameTurnList];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTurn.class]) {
        return array;
    } else {
        NSMutableArray<SDLTurn *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTurn alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButton *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

@end
