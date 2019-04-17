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
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    [store sdl_setObject:characterSet forName:SDLRPCParameterNameCharacterSet];
}

- (SDLCharacterSet)characterSet {
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameCharacterSet error:&error];
}

- (void)setWidth:(NSNumber<SDLInt> *)width {
    [store sdl_setObject:width forName:SDLRPCParameterNameWidth];
}

- (NSNumber<SDLInt> *)width {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameWidth ofClass:NSNumber.class error:&error];
}

- (void)setRows:(NSNumber<SDLInt> *)rows {
    [store sdl_setObject:rows forName:SDLRPCParameterNameRows];
}

- (NSNumber<SDLInt> *)rows {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameRows ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
