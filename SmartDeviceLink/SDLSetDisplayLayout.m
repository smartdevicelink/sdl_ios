//  SDLSetDisplayLayout.m
//


#import "SDLSetDisplayLayout.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
    [parameters sdl_setObject:displayLayout forName:SDLNameDisplayLayout];
}

- (NSString *)displayLayout {
    return [parameters sdl_objectForName:SDLNameDisplayLayout];
}

@end

NS_ASSUME_NONNULL_END
