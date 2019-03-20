//  SDLImageField.m
//

#import "SDLImageField.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImageField

- (void)setName:(SDLImageFieldName)name {
    [store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLImageFieldName)name {
    NSError *error;
    return [store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setImageTypeSupported:(NSArray<SDLFileType> *)imageTypeSupported {
    [store sdl_setObject:imageTypeSupported forName:SDLRPCParameterNameImageTypeSupported];
}

- (NSArray<SDLFileType> *)imageTypeSupported {
    NSError *error;
    return [store sdl_enumsForName:SDLRPCParameterNameImageTypeSupported error:&error];
}

- (void)setImageResolution:(nullable SDLImageResolution *)imageResolution {
    [store sdl_setObject:imageResolution forName:SDLRPCParameterNameImageResolution];
}

- (nullable SDLImageResolution *)imageResolution {
    return [store sdl_objectForName:SDLRPCParameterNameImageResolution ofClass:SDLImageResolution.class];
}

@end

NS_ASSUME_NONNULL_END
