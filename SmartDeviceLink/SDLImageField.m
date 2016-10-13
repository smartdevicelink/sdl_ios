//  SDLImageField.m
//

#import "SDLImageField.h"

#import "SDLImageResolution.h"
#import "SDLFileType.h"
#import "SDLNames.h"

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

- (void)setImageTypeSupported:(NSMutableArray *)imageTypeSupported {
    if (imageTypeSupported != nil) {
        [store setObject:imageTypeSupported forKey:SDLNameImageTypeSupported];
    } else {
        [store removeObjectForKey:SDLNameImageTypeSupported];
    }
}

- (NSMutableArray *)imageTypeSupported {
    NSMutableArray *array = [store objectForKey:SDLNameImageTypeSupported];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLFileType)enumString];
        }
        return newList;
    }
}

- (void)setImageResolution:(SDLImageResolution *)imageResolution {
    if (imageResolution != nil) {
        [store setObject:imageResolution forKey:SDLNameImageResolution];
    } else {
        [store removeObjectForKey:SDLNameImageResolution];
    }
}

- (SDLImageResolution *)imageResolution {
    NSObject *obj = [store objectForKey:SDLNameImageResolution];
    if (obj == nil || [obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution *)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
