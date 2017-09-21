//  SDLImageResolution.m
//


#import "SDLImageResolution.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImageResolution

- (instancetype)initWithWidth:(uint16_t)width height:(uint16_t)height {
    self = [self init];
    if (!self) { return nil; }

    self.resolutionWidth = @(width);
    self.resolutionHeight = @(height);

    return self;
}

- (void)setResolutionWidth:(NSNumber<SDLInt> *)resolutionWidth {
    [store sdl_setObject:resolutionWidth forName:SDLNameResolutionWidth];
}

- (NSNumber<SDLInt> *)resolutionWidth {
    return [store sdl_objectForName:SDLNameResolutionWidth];
}

- (void)setResolutionHeight:(NSNumber<SDLInt> *)resolutionHeight {
    [store sdl_setObject:resolutionHeight forName:SDLNameResolutionHeight];
}

- (NSNumber<SDLInt> *)resolutionHeight {
    return [store sdl_objectForName:SDLNameResolutionHeight];
}

@end

NS_ASSUME_NONNULL_END
