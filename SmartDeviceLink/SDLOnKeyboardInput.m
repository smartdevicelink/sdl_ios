//  SDLOnKeyboardInput.m
//

#import "SDLOnKeyboardInput.h"

#import "SDLKeyboardEvent.h"



@implementation SDLOnKeyboardInput

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnKeyboardInput]) {
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
        [parameters setObject:event forKey:SDLNameEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEvent];
    }
}

- (SDLKeyboardEvent *)event {
    NSObject *obj = [parameters objectForKey:SDLNameEvent];
    if (obj == nil || [obj isKindOfClass:SDLKeyboardEvent.class]) {
        return (SDLKeyboardEvent *)obj;
    } else {
        return [SDLKeyboardEvent valueOf:(NSString *)obj];
    }
}

- (void)setData:(NSString *)data {
    if (data != nil) {
        [parameters setObject:data forKey:SDLNameData];
    } else {
        [parameters removeObjectForKey:SDLNameData];
    }
}

- (NSString *)data {
    return [parameters objectForKey:SDLNameData];
}

@end
