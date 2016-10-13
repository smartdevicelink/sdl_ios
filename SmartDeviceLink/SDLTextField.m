//  SDLTextField.m
//

#import "SDLTextField.h"

#import "SDLCharacterSet.h"
#import "SDLNames.h"
#import "SDLTextFieldName.h"


@implementation SDLTextField

- (void)setName:(SDLTextFieldName)name {
    if (name != nil) {
        [store setObject:name forKey:SDLNameName];
    } else {
        [store removeObjectForKey:SDLNameName];
    }
}

- (SDLTextFieldName)name {
    NSObject *obj = [store objectForKey:SDLNameName];
    return (SDLTextFieldName)obj;
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    if (characterSet != nil) {
        [store setObject:characterSet forKey:SDLNameCharacterSet];
    } else {
        [store removeObjectForKey:SDLNameCharacterSet];
    }
}

- (SDLCharacterSet)characterSet {
    NSObject *obj = [store objectForKey:SDLNameCharacterSet];
    return (SDLCharacterSet)obj;
}

- (void)setWidth:(NSNumber *)width {
    if (width != nil) {
        [store setObject:width forKey:SDLNameWidth];
    } else {
        [store removeObjectForKey:SDLNameWidth];
    }
}

- (NSNumber *)width {
    return [store objectForKey:SDLNameWidth];
}

- (void)setRows:(NSNumber *)rows {
    if (rows != nil) {
        [store setObject:rows forKey:SDLNameRows];
    } else {
        [store removeObjectForKey:SDLNameRows];
    }
}

- (NSNumber *)rows {
    return [store objectForKey:SDLNameRows];
}

@end
