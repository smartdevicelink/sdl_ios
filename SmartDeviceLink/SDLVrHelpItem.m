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
    [self setObject:text forName:SDLNameText];
}

- (NSString *)text {
    return [self objectForName:SDLNameText];
}

- (void)setImage:(SDLImage *)image {
    [self setObject:image forName:SDLNameImage];
}

- (SDLImage *)image {
    return [self objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [self setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    return [self objectForName:SDLNamePosition];
}

@end
