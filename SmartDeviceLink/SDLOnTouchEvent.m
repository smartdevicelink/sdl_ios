//  SDLOnTouchEvent.m
//

#import "SDLOnTouchEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTouchEvent.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnTouchEvent

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnTouchEvent]) {
    }
    return self;
}

- (void)setType:(SDLTouchType)type {
    [parameters sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (SDLTouchType)type {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameType];
    return (SDLTouchType)obj;
}

- (void)setEvent:(NSArray<SDLTouchEvent *> *)event {
    [parameters sdl_setObject:event forName:SDLRPCParameterNameEvent];
}

- (NSArray<SDLTouchEvent *> *)event {
    return [parameters sdl_objectsForName:SDLRPCParameterNameEvent ofClass:SDLTouchEvent.class];
}

@end

NS_ASSUME_NONNULL_END
