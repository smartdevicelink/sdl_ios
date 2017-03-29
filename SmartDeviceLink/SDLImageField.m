//  SDLImageField.m
//

#import "SDLImageField.h"

#import "SDLFileType.h"
#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"
#import "SDLNames.h"


@implementation SDLImageField

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

- (void)setName:(SDLImageFieldName *)name {
    if (name != nil) {
        [store setObject:name forKey:NAMES_name];
    } else {
        [store removeObjectForKey:NAMES_name];
    }
}

- (SDLImageFieldName *)name {
    NSObject *obj = [store objectForKey:NAMES_name];
    if (obj == nil || [obj isKindOfClass:SDLImageFieldName.class]) {
        return (SDLImageFieldName *)obj;
    } else {
        return [SDLImageFieldName valueOf:(NSString *)obj];
    }
}

- (void)setImageTypeSupported:(NSMutableArray *)imageTypeSupported {
    if (imageTypeSupported != nil) {
        [store setObject:imageTypeSupported forKey:NAMES_imageTypeSupported];
    } else {
        [store removeObjectForKey:NAMES_imageTypeSupported];
    }
}

- (NSMutableArray *)imageTypeSupported {
    NSMutableArray *array = [store objectForKey:NAMES_imageTypeSupported];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLFileType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLFileType valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setImageResolution:(SDLImageResolution *)imageResolution {
    if (imageResolution != nil) {
        [store setObject:imageResolution forKey:NAMES_imageResolution];
    } else {
        [store removeObjectForKey:NAMES_imageResolution];
    }
}

- (SDLImageResolution *)imageResolution {
    NSObject *obj = [store objectForKey:NAMES_imageResolution];
    if (obj == nil || [obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution *)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
