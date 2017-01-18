//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnKeyboardInput

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnKeyboardInput]) {
    }
    return self;
}

- (void)setEvent:(SDLKeyboardEvent)event {
    if (event != nil) {
        [parameters setObject:event forKey:SDLNameEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEvent];
    }
}

- (SDLKeyboardEvent)event {
    NSObject *obj = [parameters objectForKey:SDLNameEvent];
    return (SDLKeyboardEvent)obj;
}

- (void)setData:(nullable NSString *)data {
    if (data != nil) {
        [parameters setObject:data forKey:SDLNameData];
    } else {
        [parameters removeObjectForKey:SDLNameData];
    }
}

- (nullable NSString *)data {
    return [parameters objectForKey:SDLNameData];
}

@end

NS_ASSUME_NONNULL_END
