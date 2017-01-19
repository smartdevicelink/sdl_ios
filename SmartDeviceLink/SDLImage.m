//  SDLImage.m
//

#import "SDLImage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImage

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType)imageType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.value = name;
    self.imageType = imageType;

    return self;
}

- (void)setValue:(NSString *)value {
    [store sdl_setObject:value forName:SDLNameValue];
}

- (NSString *)value {
    return [store sdl_objectForName:SDLNameValue];
}

- (void)setImageType:(SDLImageType)imageType {
    [store sdl_setObject:imageType forName:SDLNameImageType];
}

- (SDLImageType)imageType {
    return [store sdl_objectForName:SDLNameImageType];
}

@end

NS_ASSUME_NONNULL_END
