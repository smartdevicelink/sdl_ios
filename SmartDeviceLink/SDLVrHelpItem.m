//  SDLVRHelpItem.m
//


#import "SDLVRHelpItem.h"

#import "SDLImage.h"
#import "SDLNames.h"

@implementation SDLVRHelpItem

- (instancetype)initWithText:(NSString *)text image:(SDLImage *)image position:(UInt8)position {
    self = [self initWithText:text image:image];
    if (!self) {
        return nil;
    }

    self.position = @(position);

    return self;
}

- (instancetype)initWithText:(NSString *)text image:(SDLImage *)image {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.text = text;
    self.image = image;

    return self;
}

- (void)setText:(NSString *)text {
    [store sdl_setObject:text forName:SDLNameText];
}

- (NSString *)text {
    return [store sdl_objectForName:SDLNameText];
}

- (void)setImage:(SDLImage *)image {
    [store sdl_setObject:image forName:SDLNameImage];
}

- (SDLImage *)image {
    return [store sdl_objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [store sdl_setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    return [store sdl_objectForName:SDLNamePosition];
}

@end
