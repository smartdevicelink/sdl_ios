//  SDLOnTBTClientState.m
//

#import "SDLOnTBTClientState.h"

#import "SDLNames.h"

@implementation SDLOnTBTClientState

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnTBTClientState]) {
    }
    return self;
}

- (void)setState:(SDLTBTState)state {
    if (state != nil) {
        [parameters setObject:state forKey:SDLNameState];
    } else {
        [parameters removeObjectForKey:SDLNameState];
    }
}

- (SDLTBTState)state {
    NSObject *obj = [parameters objectForKey:SDLNameState];
    return (SDLTBTState)obj;
}

@end
