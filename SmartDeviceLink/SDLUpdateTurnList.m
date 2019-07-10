//  SDLUpdateTurnList.m
//


#import "SDLUpdateTurnList.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"
#import "SDLTurn.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUpdateTurnList

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUpdateTurnList]) {
    }
    return self;
}
#pragma clang diagnostic pop

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
    [self.parameters sdl_setObject:turnList forName:SDLRPCParameterNameTurnList];
}

- (nullable NSArray<SDLTurn *> *)turnList {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTurnList ofClass:SDLTurn.class error:nil];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [self.parameters sdl_setObject:softButtons forName:SDLRPCParameterNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameSoftButtons ofClass:SDLSoftButton.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
