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
    self.isTemplate = @NO;

    return self;
}

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType)imageType isTemplate:(BOOL)isTemplate {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.value = name;
    self.imageType = imageType;
    self.isTemplate = @(isTemplate);

    return self;
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name ofType:SDLImageTypeDynamic];
}

- (instancetype)initWithName:(NSString *)name isTemplate:(BOOL)isTemplate {
    return [self initWithName:name ofType:SDLImageTypeDynamic isTemplate:isTemplate];
}

- (instancetype)initWithStaticImageValue:(UInt16)staticImageValue {
    NSString *value = [NSString stringWithFormat:@"%hu", staticImageValue];
    // All static images are templated by default
    return [self initWithName:value ofType:SDLImageTypeStatic isTemplate:YES];
}

- (instancetype)initWithStaticIconName:(SDLStaticIconName)staticIconName {
    return [self initWithName:staticIconName ofType:SDLImageTypeStatic isTemplate:YES];
}

#pragma mark - Getters / Setters

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

- (void)setIsTemplate:(NSNumber<SDLBool> *)isTemplate {
    [store sdl_setObject:isTemplate forName:SDLNameImageTemplate];
}

- (NSNumber<SDLBool> *)isTemplate {
    return [store sdl_objectForName:SDLNameImageTemplate];
}

@end

NS_ASSUME_NONNULL_END
