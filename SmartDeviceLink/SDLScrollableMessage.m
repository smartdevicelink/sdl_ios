//  SDLScrollableMessage.m
//


#import "SDLScrollableMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSoftButton.h"

@implementation SDLScrollableMessage

- (instancetype)init {
    if (self = [super initWithName:SDLNameScrollableMessage]) {
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    self = [self initWithMessage:message];
    if (!self) {
        return nil;
    }

    self.timeout = @(timeout);
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (instancetype)initWithMessage:(NSString *)message {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.scrollableMessageBody = message;

    return self;
}

- (void)setScrollableMessageBody:(NSString *)scrollableMessageBody {
    [parameters sdl_setObject:scrollableMessageBody forName:SDLNameScrollableMessageBody];
}

- (NSString *)scrollableMessageBody {
    return [parameters sdl_objectForName:SDLNameScrollableMessageBody];
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLNameTimeout];
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLNameTimeout];
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    return [parameters sdl_objectsForName:SDLNameSoftButtons ofClass:SDLSoftButton.class];
}

@end
