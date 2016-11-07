//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "SDLNames.h"

@implementation SDLOnKeyboardInput

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnKeyboardInput]) {
    }
    return self;
}

- (void)setEvent:(SDLKeyboardEvent)event {
    [self setObject:event forName:SDLNameEvent];
}

- (SDLKeyboardEvent)event {
    NSObject *obj = [parameters objectForKey:SDLNameEvent];
    return (SDLKeyboardEvent)obj;
}

- (void)setData:(NSString *)data {
    [self setObject:data forName:SDLNameData];
}

- (NSString *)data {
    return [parameters objectForKey:SDLNameData];
}

@end
