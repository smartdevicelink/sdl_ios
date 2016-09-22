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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setState:(SDLDriverDistractionState *)state {
    if (state != nil) {
        [parameters setObject:state forKey:SDLNameState];
    } else {
        [parameters removeObjectForKey:SDLNameState];
    }
}

- (SDLDriverDistractionState *)state {
    NSObject *obj = [parameters objectForKey:SDLNameState];
    if (obj == nil || [obj isKindOfClass:SDLDriverDistractionState.class]) {
        return (SDLDriverDistractionState *)obj;
    } else {
        return [SDLDriverDistractionState valueOf:(NSString *)obj];
    }
}

@end
