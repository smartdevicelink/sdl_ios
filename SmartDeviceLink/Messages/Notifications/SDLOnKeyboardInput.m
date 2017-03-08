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
    NSObject *obj = [parameters sdl_objectForName:SDLNameEvent];
    return (SDLKeyboardEvent)obj;
}

- (void)setData:(nullable NSString *)data {
    [parameters sdl_setObject:data forName:SDLNameData];
}

- (nullable NSString *)data {
    return [parameters sdl_objectForName:SDLNameData];
}

@end

NS_ASSUME_NONNULL_END
