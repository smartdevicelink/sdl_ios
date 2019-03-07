//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnKeyboardInput

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnKeyboardInput]) {
    }
    return self;
}

- (void)setEvent:(SDLKeyboardEvent)event {
    [parameters sdl_setObject:event forName:SDLNameEvent];
}

- (SDLKeyboardEvent)event {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameEvent error:&error];
}

- (void)setData:(nullable NSString *)data {
    [parameters sdl_setObject:data forName:SDLNameData];
}

- (nullable NSString *)data {
    return [parameters sdl_objectForName:SDLNameData ofClass:NSString.class];
}

@end

NS_ASSUME_NONNULL_END
