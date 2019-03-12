//  SDLVRHelpItem.m
//


#import "SDLVrHelpItem.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"

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
    [store sdl_setObject:text forName:SDLRPCParameterNameText];
}

- (NSString *)text {
    return [store sdl_objectForName:SDLRPCParameterNameText];
}

- (void)setImage:(nullable SDLImage *)image {
    [store sdl_setObject:image forName:SDLRPCParameterNameImage];
}

- (nullable SDLImage *)image {
    return [store sdl_objectForName:SDLRPCParameterNameImage ofClass:SDLImage.class];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [store sdl_setObject:position forName:SDLRPCParameterNamePosition];
}

- (NSNumber<SDLInt> *)position {
    return [store sdl_objectForName:SDLRPCParameterNamePosition];
}

@end

NS_ASSUME_NONNULL_END
