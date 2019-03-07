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
    NSError *error;
    return [store sdl_enumForName:SDLNameName error:&error];
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    [store sdl_setObject:characterSet forName:SDLNameCharacterSet];
}

- (SDLCharacterSet)characterSet {
    NSError *error;
    return [store sdl_enumForName:SDLNameCharacterSet error:&error];
}

- (void)setWidth:(NSNumber<SDLInt> *)width {
    [store sdl_setObject:width forName:SDLNameWidth];
}

- (NSNumber<SDLInt> *)width {
    NSError *error;
    return [store sdl_objectForName:SDLNameWidth ofClass:NSNumber.class error:&error];
}

- (void)setRows:(NSNumber<SDLInt> *)rows {
    [store sdl_setObject:rows forName:SDLNameRows];
}

- (NSNumber<SDLInt> *)rows {
    NSError *error;
    return [store sdl_objectForName:SDLNameRows ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
