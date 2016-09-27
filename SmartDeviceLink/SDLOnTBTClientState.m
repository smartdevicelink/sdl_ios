//  SDLOnTBTClientState.m
//

#import "SDLOnTBTClientState.h"

#import "SDLNames.h"
#import "SDLTBTState.h"

@implementation SDLOnTBTClientState

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnTBTClientState]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setState:(SDLTBTState *)state {
    if (state != nil) {
        [parameters setObject:state forKey:SDLNameState];
    } else {
        [parameters removeObjectForKey:SDLNameState];
    }
}

- (SDLTBTState *)state {
    NSObject *obj = [parameters objectForKey:SDLNameState];
    if (obj == nil || [obj isKindOfClass:SDLTBTState.class]) {
        return (SDLTBTState *)obj;
    } else {
        return [SDLTBTState valueOf:(NSString *)obj];
    }
}

@end
