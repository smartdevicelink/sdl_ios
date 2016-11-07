//  SDLImageField.m
//

#import "SDLImageField.h"

#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"
#import "SDLNames.h"

@implementation SDLImageField

- (void)setName:(SDLImageFieldName)name {
    [self setObject:name forName:SDLNameName];
}

- (SDLImageFieldName)name {
    return [self objectForName:SDLNameName];
}

- (void)setImageTypeSupported:(NSMutableArray<SDLFileType> *)imageTypeSupported {
    [self setObject:imageTypeSupported forName:SDLNameImageTypeSupported];
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

- (void)setImageResolution:(SDLImageResolution *)imageResolution {
    [self setObject:imageResolution forName:SDLNameImageResolution];
}

- (SDLImageResolution *)imageResolution {
    return [self objectForName:SDLNameImageResolution ofClass:SDLImageResolution.class];
}

@end
