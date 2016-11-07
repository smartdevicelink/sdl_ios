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
    [self setObject:state forName:SDLNameState];
}

- (SDLTBTState)state {
    NSObject *obj = [parameters objectForKey:SDLNameState];
    return (SDLTBTState)obj;
}

@end
