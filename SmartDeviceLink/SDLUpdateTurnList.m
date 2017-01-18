//  SDLUpdateTurnList.m
//


#import "SDLUpdateTurnList.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:turnList forName:SDLNameTurnList];
}

- (NSMutableArray<SDLTurn *> *)turnList {
    return [parameters sdl_objectsForName:SDLNameTurnList ofClass:SDLTurn.class];
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    return [parameters sdl_objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end
