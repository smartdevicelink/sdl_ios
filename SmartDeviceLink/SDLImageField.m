//  SDLImageField.m
//

#import "SDLImageField.h"

#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImageField

- (void)setName:(SDLImageFieldName)name {
    if (name != nil) {
        [store setObject:name forKey:SDLNameName];
    } else {
        [store removeObjectForKey:SDLNameName];
    }
}

- (SDLImageFieldName)name {
    NSObject *obj = [store objectForKey:SDLNameName];
    return (SDLImageFieldName)obj;
}

- (void)setImageTypeSupported:(NSMutableArray<SDLFileType> *)imageTypeSupported {
    if (imageTypeSupported != nil) {
        [store setObject:imageTypeSupported forKey:SDLNameImageTypeSupported];
    } else {
        [store removeObjectForKey:SDLNameImageTypeSupported];
    }
}

- (NSMutableArray<SDLFileType> *)imageTypeSupported {
    NSMutableArray<SDLFileType> *array = [store objectForKey:SDLNameImageTypeSupported];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLFileType> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLFileType)enumString];
        }
        return newList;
    }
}

- (void)setImageResolution:(nullable SDLImageResolution *)imageResolution {
    if (imageResolution != nil) {
        [store setObject:imageResolution forKey:SDLNameImageResolution];
    } else {
        [store removeObjectForKey:SDLNameImageResolution];
    }
}

- (nullable SDLImageResolution *)imageResolution {
    NSObject *obj = [store objectForKey:SDLNameImageResolution];
    if (obj == nil || [obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution *)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end

NS_ASSUME_NONNULL_END
