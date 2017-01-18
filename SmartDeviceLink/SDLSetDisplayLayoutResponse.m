//  SDLSetDisplayLayoutResponse.m
//


#import "SDLSetDisplayLayoutResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLNames.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetDisplayLayoutResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetDisplayLayout]) {
    }
    return self;
}

- (void)setDisplayCapabilities:(nullable SDLDisplayCapabilities *)displayCapabilities {
    [parameters sdl_setObject:displayCapabilities forName:SDLNameDisplayCapabilities];
}

- (nullable SDLDisplayCapabilities *)displayCapabilities {
    return [parameters sdl_objectForName:SDLNameDisplayCapabilities ofClass:SDLDisplayCapabilities.class];
}

- (void)setButtonCapabilities:(nullable NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [parameters sdl_setObject:buttonCapabilities forName:SDLNameButtonCapabilities];
}

- (nullable NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [parameters sdl_objectsForName:SDLNameButtonCapabilities ofClass:SDLButtonCapabilities.class];
}

- (void)setSoftButtonCapabilities:(nullable NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [parameters sdl_setObject:softButtonCapabilities forName:SDLNameSoftButtonCapabilities];
}

- (nullable NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    return [parameters sdl_objectsForName:SDLNameSoftButtonCapabilities ofClass:SDLSoftButtonCapabilities.class];
}

- (void)setPresetBankCapabilities:(nullable SDLPresetBankCapabilities *)presetBankCapabilities {
    [parameters sdl_setObject:presetBankCapabilities forName:SDLNamePresetBankCapabilities];
}

- (nullable SDLPresetBankCapabilities *)presetBankCapabilities {
    return [parameters sdl_objectForName:SDLNamePresetBankCapabilities ofClass:SDLPresetBankCapabilities.class];
}

@end

NS_ASSUME_NONNULL_END
