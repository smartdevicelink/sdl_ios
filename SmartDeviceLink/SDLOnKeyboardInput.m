//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

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

- (void)setData:(NSString *)data {
    [parameters sdl_setObject:data forName:SDLNameData];
}

- (NSString *)data {
    return [parameters sdl_objectForName:SDLNameData];
}

@end
