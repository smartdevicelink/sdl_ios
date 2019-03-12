//  SDLTextField.m
//

#import "SDLTextField.h"

#import "NSMutableDictionary+Store.h"
#import "SDLCharacterSet.h"
#import "SDLRPCParameterNames.h"
#import "SDLTextFieldName.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTextField

- (void)setName:(SDLTextFieldName)name {
    [store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLTextFieldName)name {
    return [store sdl_objectForName:SDLRPCParameterNameName];
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    [store sdl_setObject:characterSet forName:SDLRPCParameterNameCharacterSet];
}

- (SDLCharacterSet)characterSet {
    return [store sdl_objectForName:SDLRPCParameterNameCharacterSet];
}

- (void)setWidth:(NSNumber<SDLInt> *)width {
    [store sdl_setObject:width forName:SDLRPCParameterNameWidth];
}

- (NSNumber<SDLInt> *)width {
    return [store sdl_objectForName:SDLRPCParameterNameWidth];
}

- (void)setRows:(NSNumber<SDLInt> *)rows {
    [store sdl_setObject:rows forName:SDLRPCParameterNameRows];
}

- (NSNumber<SDLInt> *)rows {
    return [store sdl_objectForName:SDLRPCParameterNameRows];
}

@end

NS_ASSUME_NONNULL_END
