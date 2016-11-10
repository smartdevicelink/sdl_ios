//  SDLImageField.m
//

#import "SDLImageField.h"

#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"
#import "SDLNames.h"

@implementation SDLImageField

- (void)setName:(SDLImageFieldName)name {
    [store sdl_setObject:name forName:SDLNameName];
}

- (SDLImageFieldName)name {
    return [store sdl_objectForName:SDLNameName];
}

- (void)setImageTypeSupported:(NSMutableArray<SDLFileType> *)imageTypeSupported {
    [store sdl_setObject:imageTypeSupported forName:SDLNameImageTypeSupported];
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
    [store sdl_setObject:imageResolution forName:SDLNameImageResolution];
}

- (SDLImageResolution *)imageResolution {
    return [store sdl_objectForName:SDLNameImageResolution ofClass:SDLImageResolution.class];
}

@end
