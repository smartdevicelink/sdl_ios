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
    return [self initWithLayout:predefinedLayout.value];
}

- (instancetype)initWithLayout:(NSString *)displayLayout {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.displayLayout = displayLayout;

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
