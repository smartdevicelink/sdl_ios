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
    NSError *error;
    return [store sdl_objectForName:SDLNameResolutionWidth ofClass:NSNumber.class error:&error];
}

- (void)setResolutionHeight:(NSNumber<SDLInt> *)resolutionHeight {
    [store sdl_setObject:resolutionHeight forName:SDLNameResolutionHeight];
}

- (NSNumber<SDLInt> *)resolutionHeight {
    NSError *error;
    return [store sdl_objectForName:SDLNameResolutionHeight ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
