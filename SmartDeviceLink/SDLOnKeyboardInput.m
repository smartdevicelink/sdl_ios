//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "SDLKeyboardEvent.h"
#import "SDLNames.h"


@implementation SDLOnKeyboardInput

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnKeyboardInput]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setEvent:(SDLKeyboardEvent *)event {
    if (event != nil) {
        [parameters setObject:event forKey:NAMES_event];
    } else {
        [parameters removeObjectForKey:NAMES_event];
    }
}

- (SDLKeyboardEvent *)event {
    NSObject *obj = [parameters objectForKey:NAMES_event];
    if (obj == nil || [obj isKindOfClass:SDLKeyboardEvent.class]) {
        return (SDLKeyboardEvent *)obj;
    } else {
        return [SDLKeyboardEvent valueOf:(NSString *)obj];
    }
}

- (void)setData:(NSString *)data {
    if (data != nil) {
        [parameters setObject:data forKey:NAMES_data];
    } else {
        [parameters removeObjectForKey:NAMES_data];
    }
}

- (NSString *)data {
    return [parameters objectForKey:NAMES_data];
}

@end
