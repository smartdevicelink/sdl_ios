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
    [self setObject:reason forName:SDLNameReason];
}

- (SDLAppInterfaceUnregisteredReason)reason {
    NSObject *obj = [parameters objectForKey:SDLNameReason];
    return (SDLAppInterfaceUnregisteredReason)obj;
}

@end
