//  SDLVRHelpItem.m
//


#import "SDLVRHelpItem.h"

#import "SDLImage.h"
#import "SDLNames.h"

@implementation SDLVRHelpItem

- (void)setText:(NSString *)text {
    if (text != nil) {
        [store setObject:text forKey:SDLNameText];
    } else {
        [store removeObjectForKey:SDLNameText];
    }
}

- (NSString *)text {
    return [store objectForKey:SDLNameText];
}

- (void)setImage:(SDLImage *)image {
    if (image != nil) {
        [store setObject:image forKey:SDLNameImage];
    } else {
        [store removeObjectForKey:SDLNameImage];
    }
}

- (SDLImage *)image {
    NSObject *obj = [store objectForKey:SDLNameImage];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    if (position != nil) {
        [store setObject:position forKey:SDLNamePosition];
    } else {
        [store removeObjectForKey:SDLNamePosition];
    }
}

- (NSNumber<SDLInt> *)position {
    return [store objectForKey:SDLNamePosition];
}

@end
