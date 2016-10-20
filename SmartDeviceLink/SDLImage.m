//  SDLImage.m
//

#import "SDLImage.h"

#import "SDLNames.h"


@implementation SDLImage

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
