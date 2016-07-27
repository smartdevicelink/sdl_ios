//  SDLVRHelpItem.m
//


#import "SDLVRHelpItem.h"

#import "SDLImage.h"
#import "SDLNames.h"

@implementation SDLVRHelpItem

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setText:(NSString *)text {
    if (text != nil) {
        [store setObject:text forKey:NAMES_text];
    } else {
        [store removeObjectForKey:NAMES_text];
    }
}

- (NSString *)text {
    return [store objectForKey:NAMES_text];
}

- (void)setImage:(SDLImage *)image {
    if (image != nil) {
        [store setObject:image forKey:NAMES_image];
    } else {
        [store removeObjectForKey:NAMES_image];
    }
}

- (SDLImage *)image {
    NSObject *obj = [store objectForKey:NAMES_image];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setPosition:(NSNumber *)position {
    if (position != nil) {
        [store setObject:position forKey:NAMES_position];
    } else {
        [store removeObjectForKey:NAMES_position];
    }
}

- (NSNumber *)position {
    return [store objectForKey:NAMES_position];
}

@end
