//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnKeyboardInput

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnKeyboardInput]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithEvent:(SDLKeyboardEvent)event {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.event = event;
    return self;
}

- (instancetype)initWithEvent:(SDLKeyboardEvent)event data:(nullable NSString *)data {
    self = [self initWithEvent:event];
    if (!self) {
        return nil;
    }
    self.data = data;
    return self;
}

- (void)setEvent:(SDLKeyboardEvent)event {
    [self.parameters sdl_setObject:event forName:SDLRPCParameterNameEvent];
}

- (SDLKeyboardEvent)event {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameEvent error:&error];
}

- (void)setData:(nullable NSString *)data {
    [self.parameters sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (nullable NSString *)data {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameData ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
