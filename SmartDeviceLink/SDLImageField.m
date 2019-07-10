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
    [self.store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLImageFieldName)name {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setImageTypeSupported:(NSArray<SDLFileType> *)imageTypeSupported {
    [self.store sdl_setObject:imageTypeSupported forName:SDLRPCParameterNameImageTypeSupported];
}

- (NSArray<SDLFileType> *)imageTypeSupported {
    NSError *error = nil;
    return [self.store sdl_enumsForName:SDLRPCParameterNameImageTypeSupported error:&error];
}

- (void)setImageResolution:(nullable SDLImageResolution *)imageResolution {
    [self.store sdl_setObject:imageResolution forName:SDLRPCParameterNameImageResolution];
}

- (nullable SDLImageResolution *)imageResolution {
    return [self.store sdl_objectForName:SDLRPCParameterNameImageResolution ofClass:SDLImageResolution.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
