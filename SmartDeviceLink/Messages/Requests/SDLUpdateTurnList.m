//  SDLUpdateTurnList.m
//


#import "SDLUpdateTurnList.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"
#import "SDLTurn.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUpdateTurnList

- (instancetype)init {
    if (self = [super initWithName:SDLNameUpdateTurnList]) {
    }
    return self;
}

- (instancetype)initWithTurnList:(nullable NSArray<SDLTurn *> *)turnList softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.turnList = [turnList mutableCopy];
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setTurnList:(nullable NSArray<SDLTurn *> *)turnList {
    [parameters sdl_setObject:turnList forName:SDLNameTurnList];
}

- (nullable NSArray<SDLTurn *> *)turnList {
    return [parameters sdl_objectsForName:SDLNameTurnList ofClass:SDLTurn.class];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [parameters sdl_objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end

NS_ASSUME_NONNULL_END
