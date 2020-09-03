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

- (instancetype)initWithName:(SDLImageFieldName)name imageTypeSupported:(NSArray<SDLFileType> *)imageTypeSupported imageResolution:(nullable SDLImageResolution *)imageResolution {
    self = [self init];
    if (!self) { return nil; }

    self.name = name;
    self.imageTypeSupported = imageTypeSupported;
    self.imageResolution = imageResolution;

    return self;
}

@end

NS_ASSUME_NONNULL_END
