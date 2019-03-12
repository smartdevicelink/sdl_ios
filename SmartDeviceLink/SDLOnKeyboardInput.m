//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnKeyboardInput

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnKeyboardInput]) {
    }
    return self;
}

- (void)setEvent:(SDLKeyboardEvent)event {
    [parameters sdl_setObject:event forName:SDLRPCParameterNameEvent];
}

- (SDLKeyboardEvent)event {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameEvent];
    return (SDLKeyboardEvent)obj;
}

- (void)setData:(nullable NSString *)data {
    [parameters sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (nullable NSString *)data {
    return [parameters sdl_objectForName:SDLRPCParameterNameData];
}

@end

NS_ASSUME_NONNULL_END
