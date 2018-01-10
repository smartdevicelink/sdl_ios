//  SDLImage.m
//

#import "SDLImage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImage

- (instancetype)init {
    if (self = [super init]) {
        self.isTemplateImage = NO;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType)imageType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.value = name;
    self.imageType = imageType;
    
    return self;
}

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType)imageType isTemplateImage:(BOOL) isTemplate
{
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.value = name;
    self.imageType = imageType;
    self.isTemplateImage = isTemplate;
    
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

-(void) setIsTemplateImage:(BOOL)isTemplateImage {
    [store sdl_setObject:[NSNumber numberWithBool:isTemplateImage] forName:SDLNameIsTemplateImage];
}

- (BOOL) isTemplateImage {
    NSObject *obj = [store sdl_objectForName:SDLNameIsTemplateImage];
    if (obj != nil && [obj isKindOfClass:NSNumber.class]) {
        NSNumber* val = (NSNumber*) obj;
        return [val boolValue];
    } else {
        return NO;
    }
}

@end

NS_ASSUME_NONNULL_END
