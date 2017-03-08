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
    NSObject *obj = [parameters sdl_objectForName:SDLNameState];
    return (SDLDriverDistractionState)obj;
}

@end

NS_ASSUME_NONNULL_END
