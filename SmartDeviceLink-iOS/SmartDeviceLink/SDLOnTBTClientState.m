//  SDLOnTBTClientState.m
//

#import "SDLOnTBTClientState.h"

#import "SDLNames.h"
#import "SDLTBTState.h"


@implementation SDLOnTBTClientState

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnTBTClientState]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setState:(SDLTBTState *)state {
    if (state != nil) {
        [parameters setObject:state forKey:NAMES_state];
    } else {
        [parameters removeObjectForKey:NAMES_state];
    }
}

- (SDLTBTState *)state {
    NSObject *obj = [parameters objectForKey:NAMES_state];
    if (obj == nil || [obj isKindOfClass:SDLTBTState.class]) {
        return (SDLTBTState *)obj;
    } else {
        return [SDLTBTState valueOf:(NSString *)obj];
    }
}

@end
