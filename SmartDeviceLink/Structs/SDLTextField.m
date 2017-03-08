//  SDLTextField.m
//

#import "SDLTextField.h"

#import "NSMutableDictionary+Store.h"
#import "SDLCharacterSet.h"
#import "SDLNames.h"
#import "SDLTextFieldName.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTextField

- (void)setName:(SDLTextFieldName)name {
    [store sdl_setObject:name forName:SDLNameName];
}

- (SDLTextFieldName)name {
    return [store sdl_objectForName:SDLNameName];
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    [store sdl_setObject:characterSet forName:SDLNameCharacterSet];
}

- (SDLCharacterSet)characterSet {
    return [store sdl_objectForName:SDLNameCharacterSet];
}

- (void)setWidth:(NSNumber<SDLInt> *)width {
    [store sdl_setObject:width forName:SDLNameWidth];
}

- (NSNumber<SDLInt> *)width {
    return [store sdl_objectForName:SDLNameWidth];
}

- (void)setRows:(NSNumber<SDLInt> *)rows {
    [store sdl_setObject:rows forName:SDLNameRows];
}

- (NSNumber<SDLInt> *)rows {
    return [store sdl_objectForName:SDLNameRows];
}

@end

NS_ASSUME_NONNULL_END
