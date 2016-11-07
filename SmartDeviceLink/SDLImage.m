//  SDLImage.m
//

#import "SDLImage.h"

#import "SDLNames.h"

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
    [self setObject:value forName:SDLNameValue];
}

- (NSString *)value {
    return [self objectForName:SDLNameValue];
}

- (void)setImageType:(SDLImageType)imageType {
    [self setObject:imageType forName:SDLNameImageType];
}

- (SDLImageType)imageType {
    return [self objectForName:SDLNameImageType];
}

@end
