//  SDLOnDriverDistraction.m
//

#import "SDLOnDriverDistraction.h"

#import "SDLDriverDistractionState.h"
#import "SDLNames.h"


@implementation SDLOnDriverDistraction

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnDriverDistraction]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setState:(SDLDriverDistractionState *)state {
    if (state != nil) {
        [parameters setObject:state forKey:NAMES_state];
    } else {
        [parameters removeObjectForKey:NAMES_state];
    }
}

- (SDLDriverDistractionState *)state {
    NSObject *obj = [parameters objectForKey:NAMES_state];
    if (obj == nil || [obj isKindOfClass:SDLDriverDistractionState.class]) {
        return (SDLDriverDistractionState *)obj;
    } else {
        return [SDLDriverDistractionState valueOf:(NSString *)obj];
    }
}

@end
