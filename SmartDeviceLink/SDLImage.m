//  SDLImage.m
//

#import "SDLImage.h"

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
    if (value != nil) {
        [store setObject:value forKey:SDLNameValue];
    } else {
        [store removeObjectForKey:SDLNameValue];
    }
}

- (NSString *)value {
    return [store objectForKey:SDLNameValue];
}

- (void)setImageType:(SDLImageType)imageType {
    if (imageType != nil) {
        [store setObject:imageType forKey:SDLNameImageType];
    } else {
        [store removeObjectForKey:SDLNameImageType];
    }
}

- (SDLImageType)imageType {
    NSObject *obj = [store objectForKey:SDLNameImageType];
    return (SDLImageType)obj;
}

@end

NS_ASSUME_NONNULL_END
