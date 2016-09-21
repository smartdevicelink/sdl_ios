//  SDLImageResolution.m
//


#import "SDLImageResolution.h"



@implementation SDLImageResolution

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

- (void)setResolutionWidth:(NSNumber *)resolutionWidth {
    if (resolutionWidth != nil) {
        [store setObject:resolutionWidth forKey:SDLNameResolutionWidth];
    } else {
        [store removeObjectForKey:SDLNameResolutionWidth];
    }
}

- (NSNumber *)resolutionWidth {
    return [store objectForKey:SDLNameResolutionWidth];
}

- (void)setResolutionHeight:(NSNumber *)resolutionHeight {
    if (resolutionHeight != nil) {
        [store setObject:resolutionHeight forKey:SDLNameResolutionHeight];
    } else {
        [store removeObjectForKey:SDLNameResolutionHeight];
    }
}

- (NSNumber *)resolutionHeight {
    return [store objectForKey:SDLNameResolutionHeight];
}

@end
