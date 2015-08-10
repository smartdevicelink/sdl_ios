//  SDLImageResolution.m
//


#import "SDLImageResolution.h"

#import "SDLNames.h"

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
        [store setObject:resolutionWidth forKey:NAMES_resolutionWidth];
    } else {
        [store removeObjectForKey:NAMES_resolutionWidth];
    }
}

- (NSNumber *)resolutionWidth {
    return [store objectForKey:NAMES_resolutionWidth];
}

- (void)setResolutionHeight:(NSNumber *)resolutionHeight {
    if (resolutionHeight != nil) {
        [store setObject:resolutionHeight forKey:NAMES_resolutionHeight];
    } else {
        [store removeObjectForKey:NAMES_resolutionHeight];
    }
}

- (NSNumber *)resolutionHeight {
    return [store objectForKey:NAMES_resolutionHeight];
}

@end
