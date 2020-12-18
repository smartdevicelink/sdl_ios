//  SDLKeyboardProperties.m
//

#import "SDLKeyboardProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLKeyboardProperties

- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText autoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList {
    self = [[self init] initWithLanguage:language keyboardLayout:layout keypressMode:keypressMode limitedCharacterList:limitedCharacterList autoCompleteList:autoCompleteList];
    if (!self) { return nil; }
    self.autoCompleteText = autoCompleteText;

    return self;
}

- (instancetype)initWithLanguage:(nullable SDLLanguage)language keyboardLayout:(nullable SDLKeyboardLayout)keyboardLayout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList {
    self = [self initWithLanguage:language keyboardLayout:keyboardLayout keypressMode:keypressMode limitedCharacterList:limitedCharacterList autoCompleteList:autoCompleteList maskInputCharacters:nil customizeKeys:nil];
    return self;
}

- (instancetype)initWithLanguage:(nullable SDLLanguage)language keyboardLayout:(nullable SDLKeyboardLayout)keyboardLayout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList maskInputCharacters:(nullable SDLKeyboardInputMask)maskInputCharacters customizeKeys:(nullable NSArray<NSString *> *)customizeKeys {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.language = language;
    self.keyboardLayout = keyboardLayout;
    self.keypressMode = keypressMode;
    self.limitedCharacterList = limitedCharacterList;
    self.autoCompleteList = autoCompleteList;
    self.maskInputCharacters = maskInputCharacters;
    self.customizeKeys = customizeKeys;
    return self;
}

- (void)setLanguage:(nullable SDLLanguage)language {
    [self.store sdl_setObject:language forName:SDLRPCParameterNameLanguage];
}

- (nullable SDLLanguage)language {
    return [self.store sdl_enumForName:SDLRPCParameterNameLanguage error:nil];
}

- (void)setKeyboardLayout:(nullable SDLKeyboardLayout)keyboardLayout {
    [self.store sdl_setObject:keyboardLayout forName:SDLRPCParameterNameKeyboardLayout];
}

- (nullable SDLKeyboardLayout)keyboardLayout {
    return [self.store sdl_enumForName:SDLRPCParameterNameKeyboardLayout error:nil];
}

- (void)setKeypressMode:(nullable SDLKeypressMode)keypressMode {
    [self.store sdl_setObject:keypressMode forName:SDLRPCParameterNameKeypressMode];
}

- (nullable SDLKeypressMode)keypressMode {
    return [self.store sdl_enumForName:SDLRPCParameterNameKeypressMode error:nil];
}

- (void)setLimitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList {
    [self.store sdl_setObject:limitedCharacterList forName:SDLRPCParameterNameLimitedCharacterList];
}

- (nullable NSArray<NSString *> *)limitedCharacterList {
    return [self.store sdl_objectsForName:SDLRPCParameterNameLimitedCharacterList ofClass:NSString.class error:nil];
}

- (void)setAutoCompleteText:(nullable NSString *)autoCompleteText {
    [self.store sdl_setObject:autoCompleteText forName:SDLRPCParameterNameAutoCompleteText];
}

- (nullable NSString *)autoCompleteText {
    return [self.store sdl_objectForName:SDLRPCParameterNameAutoCompleteText ofClass:NSString.class error:nil];
}

- (void)setAutoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList {
    [self.store sdl_setObject:autoCompleteList forName:SDLRPCParameterNameAutoCompleteList];
}

- (nullable NSArray<NSString *> *)autoCompleteList {
    return [self.store sdl_objectsForName:SDLRPCParameterNameAutoCompleteList ofClass:NSString.class error:nil];
}

- (void)setMaskInputCharacters:(nullable SDLKeyboardInputMask)maskInputCharacters {
    [self.store sdl_setObject:maskInputCharacters forName:SDLRPCParameterNameMaskInputCharacters];
}

- (nullable SDLKeyboardInputMask)maskInputCharacters {
    return [self.store sdl_enumForName:SDLRPCParameterNameMaskInputCharacters error:nil];
}

- (void)setCustomizeKeys:(nullable NSArray<NSString *> *)customizeKeys {
    [self.store sdl_setObject:customizeKeys forName:SDLRPCParameterNameCustomizeKeys];
}

- (nullable NSArray<NSString *> *)customizeKeys {
    return [self.store sdl_objectsForName:SDLRPCParameterNameCustomizeKeys ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
