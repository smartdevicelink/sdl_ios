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

- (instancetype)initWithTurnList:(NSArray<SDLTurn *> *)turnList softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.turnList = [turnList mutableCopy];
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setTurnList:(NSMutableArray<SDLTurn *> *)turnList {
    [self setObject:turnList forName:SDLNameTurnList];
}

- (NSMutableArray<SDLTurn *> *)turnList {
    NSMutableArray<SDLTurn *> *array = [parameters objectForKey:SDLNameTurnList];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTurn.class]) {
        return array;
    } else {
        NSMutableArray<SDLTurn *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTurn alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [self setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButton *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
