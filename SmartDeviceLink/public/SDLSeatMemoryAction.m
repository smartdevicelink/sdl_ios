//  SDLSeatMemoryAction.m
//

#import "SDLSeatMemoryAction.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSeatMemoryAction

- (instancetype)initWithIdParam:(UInt8)idParam action:(SDLSeatMemoryActionType)action {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.idParam = @(idParam);
    self.action = action;
    return self;
}

- (instancetype)initWithIdParam:(UInt8)idParam action:(SDLSeatMemoryActionType)action label:(nullable NSString *)label {
    self = [self initWithIdParam:idParam action:action];
    if (!self) {
        return nil;
    }
    self.label = label;
    return self;
}

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

- (void)setIdParam:(NSNumber<SDLUInt> *)idParam {
    [self.store sdl_setObject:idParam forName:SDLRPCParameterNameId];
}

- (NSNumber<SDLUInt> *)idParam {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameId ofClass:NSNumber.class error:&error];
}

- (void)setId:(NSNumber<SDLInt> *)id {
    [self.store sdl_setObject:id forName:SDLRPCParameterNameId];
}

- (NSNumber<SDLInt> *)id {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameId ofClass:NSNumber.class error:&error];
}

- (void)setLabel:(nullable NSString *)label {
    [self.store sdl_setObject:label forName:SDLRPCParameterNameLabel];
}

- (nullable NSString *)label {
    return [self.store sdl_objectForName:SDLRPCParameterNameLabel ofClass:NSString.class error:nil];
}

- (void)setAction:(SDLSeatMemoryActionType)action {
    [self.store sdl_setObject:action forName:SDLRPCParameterNameAction];
}

- (SDLSeatMemoryActionType)action {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameAction error:&error];
}
@end


NS_ASSUME_NONNULL_END
