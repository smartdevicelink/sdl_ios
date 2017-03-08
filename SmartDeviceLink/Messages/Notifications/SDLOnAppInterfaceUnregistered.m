//  SDLOnAppInterfaceUnregistered.m
//

#import "SDLOnAppInterfaceUnregistered.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAppInterfaceUnregistered

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnAppInterfaceUnregistered]) {
    }
    return self;
}

- (void)setReason:(SDLAppInterfaceUnregisteredReason)reason {
    [parameters sdl_setObject:reason forName:SDLNameReason];
}

- (SDLAppInterfaceUnregisteredReason)reason {
    return [parameters sdl_objectForName:SDLNameReason];
}

@end

NS_ASSUME_NONNULL_END
