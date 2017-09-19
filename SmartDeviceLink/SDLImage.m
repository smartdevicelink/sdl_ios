//  SDLImage.m
//

#import "SDLImage.h"

#import "SDLImageType.h"
#import "SDLNames.h"


@implementation SDLImage

- (instancetype)init {
    if (self = [super init]) {
        self.TemplateImage = NO;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType *)imageType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.value = name;
    self.imageType = imageType;
    self.TemplateImage = NO;

    return self;
}

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType *)imageType isTemplateImage:(BOOL) isTemplate{
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.value = name;
    self.imageType = imageType;
    self.TemplateImage = isTemplate;
    
    return self;
}

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

-(void) setTemplateImage:(BOOL)TemplateImage {
    [store setObject:[NSNumber numberWithBool:TemplateImage] forKey:NAMES_isTemplateImage];
}

- (BOOL) TemplateImage {
    NSObject *obj = [store objectForKey:NAMES_isTemplateImage];
    if (obj != nil && [obj isKindOfClass:NSNumber.class]) {
        NSNumber* val = (NSNumber*) obj;
        return [val boolValue];
    } else {
        return NO;
    }
}

@end
