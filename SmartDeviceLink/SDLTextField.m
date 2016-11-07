//  SDLTextField.m
//

#import "SDLTextField.h"

#import "SDLCharacterSet.h"
#import "SDLNames.h"
#import "SDLTextFieldName.h"


@implementation SDLTextField

- (void)setName:(SDLTextFieldName)name {
    [self setObject:name forName:SDLNameName];
}

- (SDLTextFieldName)name {
    return [self objectForName:SDLNameName];
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    [self setObject:characterSet forName:SDLNameCharacterSet];
}

- (SDLCharacterSet)characterSet {
    return [self objectForName:SDLNameCharacterSet];
}

- (void)setWidth:(NSNumber<SDLInt> *)width {
    [self setObject:width forName:SDLNameWidth];
}

- (NSNumber<SDLInt> *)width {
    return [self objectForName:SDLNameWidth];
}

- (void)setRows:(NSNumber<SDLInt> *)rows {
    [self setObject:rows forName:SDLNameRows];
}

- (NSNumber<SDLInt> *)rows {
    return [self objectForName:SDLNameRows];
}

@end
