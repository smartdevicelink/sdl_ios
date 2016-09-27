//  SDLSetDisplayLayout.m
//


#import "SDLSetDisplayLayout.h"

#import "SDLNames.h"

@implementation SDLSetDisplayLayout

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetDisplayLayout]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDisplayLayout:(NSString *)displayLayout {
    if (displayLayout != nil) {
        [parameters setObject:displayLayout forKey:SDLNameDisplayLayout];
    } else {
        [parameters removeObjectForKey:SDLNameDisplayLayout];
    }
}

- (NSString *)displayLayout {
    return [parameters objectForKey:SDLNameDisplayLayout];
}

@end
