//  SDLOnTBTClientState.m
//

#import "SDLOnTBTClientState.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnTBTClientState

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnTBTClientState]) {
    }
    return self;
}

- (void)setState:(SDLTBTState)state {
    [parameters sdl_setObject:state forName:SDLNameState];
}

- (SDLTBTState)state {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameState error:&error];
}

@end

NS_ASSUME_NONNULL_END
