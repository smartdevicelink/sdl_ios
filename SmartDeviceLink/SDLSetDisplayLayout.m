//  SDLSetDisplayLayout.m
//


#import "SDLSetDisplayLayout.h"

#import "SDLNames.h"
#import "SDLPredefinedLayout.h"

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

- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout *)predefinedLayout {
    if (self = [self initWithLayout:predefinedLayout.value]) {
    }
    return self;
}

- (instancetype)initWithLayout:(NSString *)displayLayout {
    if (self = [self init]) {
        self.displayLayout = displayLayout;
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
