//  SDLImage.m
//

#import "SDLImage.h"

#import "SDLImageType.h"
#import "SDLNames.h"


@implementation SDLImage

- (void)setValue:(NSString *)value {
    if (value != nil) {
        [store setObject:value forKey:NAMES_value];
    } else {
        [store removeObjectForKey:NAMES_value];
    }
}

- (NSString *)value {
    return [store objectForKey:NAMES_value];
}

- (void)setImageType:(SDLImageType *)imageType {
    if (imageType != nil) {
        [store setObject:imageType forKey:NAMES_imageType];
    } else {
        [store removeObjectForKey:NAMES_imageType];
    }
}

- (SDLImageType *)imageType {
    NSObject *obj = [store objectForKey:NAMES_imageType];
    if (obj == nil || [obj isKindOfClass:SDLImageType.class]) {
        return (SDLImageType *)obj;
    } else {
        return [SDLImageType valueOf:(NSString *)obj];
    }
}

@end
