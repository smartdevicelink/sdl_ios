//  SDLOnAppInterfaceUnregistered.m
//

#import "SDLOnAppInterfaceUnregistered.h"

#import "SDLNames.h"

@implementation SDLOnAppInterfaceUnregistered

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnAppInterfaceUnregistered]) {
    }
    return self;
}

- (void)setReason:(SDLAppInterfaceUnregisteredReason)reason {
    if (reason != nil) {
        [parameters setObject:reason forKey:SDLNameReason];
    } else {
        [parameters removeObjectForKey:SDLNameReason];
    }
}

- (SDLAppInterfaceUnregisteredReason)reason {
    NSObject *obj = [parameters objectForKey:SDLNameReason];
    return (SDLAppInterfaceUnregisteredReason)obj;
}

@end
