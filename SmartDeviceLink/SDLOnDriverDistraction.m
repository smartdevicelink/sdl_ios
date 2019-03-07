//  SDLOnDriverDistraction.m
//

#import "SDLOnDriverDistraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLDriverDistractionState.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnDriverDistraction

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnDriverDistraction]) {
    }
    return self;
}

- (void)setState:(SDLDriverDistractionState)state {
    [parameters sdl_setObject:state forName:SDLNameState];
}

- (SDLDriverDistractionState)state {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameState error:&error];
}

@end

NS_ASSUME_NONNULL_END
