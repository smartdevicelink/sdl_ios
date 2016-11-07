//  SDLOnDriverDistraction.m
//

#import "SDLOnDriverDistraction.h"

#import "SDLNames.h"
#import "SDLDriverDistractionState.h"

@implementation SDLOnDriverDistraction

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnDriverDistraction]) {
    }
    return self;
}

- (void)setState:(SDLDriverDistractionState)state {
    [self setObject:state forName:SDLNameState];
}

- (SDLDriverDistractionState)state {
    NSObject *obj = [parameters objectForKey:SDLNameState];
    return (SDLDriverDistractionState)obj;
}

@end
