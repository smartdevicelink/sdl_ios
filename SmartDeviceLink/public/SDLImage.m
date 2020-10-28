//  SDLImage.m
//

#import "SDLImage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImage

- (instancetype)initWithValueParam:(NSString *)valueParam imageType:(SDLImageType)imageType {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.valueParam = valueParam;
    self.imageType = imageType;
    return self;
}

- (instancetype)initWithValueParam:(NSString *)valueParam imageType:(SDLImageType)imageType isTemplate:(nullable NSNumber<SDLBool> *)isTemplate {
    self = [self initWithValueParam:valueParam imageType:imageType];
    if (!self) {
        return nil;
    }
    self.isTemplate = isTemplate;
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

- (instancetype)initWithName:(NSString *)name isTemplate:(BOOL)isTemplate {
    return [self initWithName:name ofType:SDLImageTypeDynamic isTemplate:isTemplate];
}

- (instancetype)initWithStaticImageValue:(UInt16)staticImageValue {
    NSString *value = [NSString stringWithFormat:@"%hu", staticImageValue];
    // All static images are templated by default
    return [self initWithName:value ofType:SDLImageTypeStatic isTemplate:YES];
}

- (instancetype)initWithStaticIconName:(SDLStaticIconName)staticIconName {
    return [self initWithValueParam:staticIconName imageType:SDLImageTypeStatic isTemplate:@YES];
}

#pragma mark - Getters / Setters

- (void)setValueParam:(NSString *)valueParam {
    [self.store sdl_setObject:valueParam forName:SDLRPCParameterNameValue];
}

- (NSString *)valueParam {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameValue ofClass:NSString.class error:&error];
}

- (void)setValue:(NSString *)value {
    [self.store sdl_setObject:value forName:SDLRPCParameterNameValue];
}

- (NSString *)value {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameValue ofClass:NSString.class error:&error];
}

- (void)setImageType:(SDLImageType)imageType {
    [self.store sdl_setObject:imageType forName:SDLRPCParameterNameImageType];
}

- (SDLImageType)imageType {
    return [self.store sdl_enumForName:SDLRPCParameterNameImageType error:nil];
}

- (void)setIsTemplate:(NSNumber<SDLBool> *)isTemplate {
    [self.store sdl_setObject:isTemplate forName:SDLRPCParameterNameImageTemplate];
}

- (NSNumber<SDLBool> *)isTemplate {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameImageTemplate ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
