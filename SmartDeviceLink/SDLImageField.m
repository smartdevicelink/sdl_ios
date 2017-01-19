//  SDLImageField.m
//

#import "SDLImageField.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
    return [store sdl_enumsForName:SDLNameImageTypeSupported];
}

- (void)setImageResolution:(nullable SDLImageResolution *)imageResolution {
    [store sdl_setObject:imageResolution forName:SDLNameImageResolution];
}

- (nullable SDLImageResolution *)imageResolution {
    return [store sdl_objectForName:SDLNameImageResolution ofClass:SDLImageResolution.class];
}

@end

NS_ASSUME_NONNULL_END
