//  SDLVRHelpItem.m
//


#import "SDLVrHelpItem.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVRHelpItem

- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image position:(UInt8)position {
    self = [self initWithText:text image:image];
    if (!self) {
        return nil;
    }

    self.position = @(position);

    return self;
}

- (instancetype)initWithText:(NSString *)text image:(nullable SDLImage *)image {
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
    NSError *error;
    return [store sdl_objectForName:SDLNameText ofClass:NSString.class error:&error];
}

- (void)setImage:(nullable SDLImage *)image {
    [store sdl_setObject:image forName:SDLNameImage];
}

- (nullable SDLImage *)image {
    return [store sdl_objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [store sdl_setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    NSError *error;
    return [store sdl_objectForName:SDLNamePosition ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
