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

- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout {
    return [self initWithLayout:predefinedLayout];
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
    [self setObject:displayLayout forName:SDLNameDisplayLayout];
}

- (NSString *)displayLayout {
    return [parameters objectForKey:SDLNameDisplayLayout];
}

@end
