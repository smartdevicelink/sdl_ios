//  SDLImage.m
//

#import "SDLImage.h"

#import "SDLImageType.h"



@implementation SDLImage

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

- (void)setImageType:(SDLImageType *)imageType {
    if (imageType != nil) {
        [store setObject:imageType forKey:SDLNameImageType];
    } else {
        [store removeObjectForKey:SDLNameImageType];
    }
}

- (SDLImageType *)imageType {
    NSObject *obj = [store objectForKey:SDLNameImageType];
    if (obj == nil || [obj isKindOfClass:SDLImageType.class]) {
        return (SDLImageType *)obj;
    } else {
        return [SDLImageType valueOf:(NSString *)obj];
    }
}

@end
