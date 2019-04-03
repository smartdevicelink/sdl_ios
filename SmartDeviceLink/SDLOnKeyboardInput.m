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
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameEvent error:&error];
}

- (void)setData:(nullable NSString *)data {
    [parameters sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (nullable NSString *)data {
    return [parameters sdl_objectForName:SDLRPCParameterNameData ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
