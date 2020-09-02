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
    [self.store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLTextFieldName)name {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    [self.store sdl_setObject:characterSet forName:SDLRPCParameterNameCharacterSet];
}

- (SDLCharacterSet)characterSet {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameCharacterSet error:&error];
}

- (void)setWidth:(NSNumber<SDLInt> *)width {
    [self.store sdl_setObject:width forName:SDLRPCParameterNameWidth];
}

- (NSNumber<SDLInt> *)width {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameWidth ofClass:NSNumber.class error:&error];
}

- (void)setRows:(NSNumber<SDLInt> *)rows {
    [self.store sdl_setObject:rows forName:SDLRPCParameterNameRows];
}

- (NSNumber<SDLInt> *)rows {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRows ofClass:NSNumber.class error:&error];
}

- (instancetype)initWithName:(SDLTextFieldName)name characterSet:(SDLCharacterSet)characterSet width:(NSUInteger)width rows:(NSUInteger)rows {
    self = [self init];
    if (!self) { return nil; }

    self.name = name;
    self.characterSet = characterSet;
    self.width = @(width);
    self.rows = @(rows);

    return self;
}

@end

NS_ASSUME_NONNULL_END
