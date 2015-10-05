//  SDLSetDisplayLayout.m
//


#import "SDLSetDisplayLayout.h"

#import "SDLNames.h"

@implementation SDLSetDisplayLayout

- (instancetype)init {
    if (self = [super initWithName:NAMES_SetDisplayLayout]) {
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
        [parameters setObject:displayLayout forKey:NAMES_displayLayout];
    } else {
        [parameters removeObjectForKey:NAMES_displayLayout];
    }
}

- (NSString *)displayLayout {
    return [parameters objectForKey:NAMES_displayLayout];
}

@end
