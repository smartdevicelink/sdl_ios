//  SDLSeatMemoryAction.m
//

#import "SDLSeatMemoryAction.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSeatMemoryAction

- (instancetype)initWithId:(UInt8)id action:(SDLSeatMemoryActionType)action {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.id = @(id);
    self.action = action;

    return self;
}

- (instancetype)initWithId:(UInt8)id label:(nullable NSString*)label action:(SDLSeatMemoryActionType)action {
    self = [self initWithId:id action:action];
    if (!self) {
        return nil;
    }

    self.label = label;
    return self;
}

- (void)setId:(NSNumber<SDLInt> *)id {
    [store sdl_setObject:id forName:SDLNameId];
}

- (NSNumber<SDLInt> *)id {
    return [store sdl_objectForName:SDLNameId];
}

- (void)setLabel:(nullable NSString *)label {
    [store sdl_setObject:label forName:SDLNameLabel];
}

- (nullable NSString *)label {
    return [store sdl_objectForName:SDLNameLabel];
}

- (void)setAction:(SDLSeatMemoryActionType)action {
    [store sdl_setObject:action forName:SDLNameAction];
}

- (SDLSeatMemoryActionType)action {
    return [store sdl_objectForName:SDLNameAction];
}
@end


NS_ASSUME_NONNULL_END
