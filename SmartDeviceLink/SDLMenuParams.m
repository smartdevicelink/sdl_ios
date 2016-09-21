//  SDLMenuParams.m
//


#import "SDLMenuParams.h"



@implementation SDLMenuParams

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setParentID:(NSNumber *)parentID {
    if (parentID != nil) {
        [store setObject:parentID forKey:SDLNameParentId];
    } else {
        [store removeObjectForKey:SDLNameParentId];
    }
}

- (NSNumber *)parentID {
    return [store objectForKey:SDLNameParentId];
}

- (void)setPosition:(NSNumber *)position {
    if (position != nil) {
        [store setObject:position forKey:SDLNamePosition];
    } else {
        [store removeObjectForKey:SDLNamePosition];
    }
}

- (NSNumber *)position {
    return [store objectForKey:SDLNamePosition];
}

- (void)setMenuName:(NSString *)menuName {
    if (menuName != nil) {
        [store setObject:menuName forKey:SDLNameMenuName];
    } else {
        [store removeObjectForKey:SDLNameMenuName];
    }
}

- (NSString *)menuName {
    return [store objectForKey:SDLNameMenuName];
}

@end
