//  SDLButtonCapabilities.m
//

#import "SDLButtonCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonCapabilities

- (instancetype)initWithNameParam:(SDLButtonName)nameParam shortPressAvailable:(BOOL)shortPressAvailable longPressAvailable:(BOOL)longPressAvailable upDownAvailable:(BOOL)upDownAvailable {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.nameParam = nameParam;
    self.shortPressAvailable = @(shortPressAvailable);
    self.longPressAvailable = @(longPressAvailable);
    self.upDownAvailable = @(upDownAvailable);
    return self;
}

- (instancetype)initWithNameParam:(SDLButtonName)nameParam shortPressAvailable:(BOOL)shortPressAvailable longPressAvailable:(BOOL)longPressAvailable upDownAvailable:(BOOL)upDownAvailable moduleInfo:(nullable SDLModuleInfo *)moduleInfo {
    self = [self initWithNameParam:nameParam shortPressAvailable:shortPressAvailable longPressAvailable:longPressAvailable upDownAvailable:upDownAvailable];
    if (!self) {
        return nil;
    }
    self.moduleInfo = moduleInfo;
    return self;
}

- (void)setNameParam:(SDLButtonName)nameParam {
    [self.store sdl_setObject:nameParam forName:SDLRPCParameterNameName];
}

- (SDLButtonName)nameParam {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setName:(SDLButtonName)name {
    [self.store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLButtonName)name {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setShortPressAvailable:(NSNumber<SDLBool> *)shortPressAvailable {
    [self.store sdl_setObject:shortPressAvailable forName:SDLRPCParameterNameShortPressAvailable];
}

- (NSNumber<SDLBool> *)shortPressAvailable {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameShortPressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setLongPressAvailable:(NSNumber<SDLBool> *)longPressAvailable {
    [self.store sdl_setObject:longPressAvailable forName:SDLRPCParameterNameLongPressAvailable];
}

- (NSNumber<SDLBool> *)longPressAvailable {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLongPressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setUpDownAvailable:(NSNumber<SDLBool> *)upDownAvailable {
    [self.store sdl_setObject:upDownAvailable forName:SDLRPCParameterNameUpDownAvailable];
}

- (NSNumber<SDLBool> *)upDownAvailable {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameUpDownAvailable ofClass:NSNumber.class error:&error];
}

- (void)setModuleInfo:(nullable SDLModuleInfo *)moduleInfo {
    [self.store sdl_setObject:moduleInfo forName:SDLRPCParameterNameModuleInfo];
}

- (nullable SDLModuleInfo *)moduleInfo {
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleInfo ofClass:SDLModuleInfo.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
