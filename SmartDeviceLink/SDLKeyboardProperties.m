//  SDLKeyboardProperties.m
//

#import "SDLKeyboardProperties.h"

#import "SDLNames.h"

@implementation SDLKeyboardProperties

- (instancetype)initWithLanguage:(SDLLanguage)language layout:(SDLKeyboardLayout)layout keypressMode:(SDLKeypressMode)keypressMode limitedCharacterList:(NSArray<NSString *> *)limitedCharacterList autoCompleteText:(NSString *)autoCompleteText {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.language = language;
    self.keyboardLayout = layout;
    self.keypressMode = keypressMode;
    self.limitedCharacterList = [limitedCharacterList mutableCopy];
    self.autoCompleteText = autoCompleteText;

    return self;
}

- (void)setLanguage:(SDLLanguage)language {
    [self setObject:language forName:SDLNameLanguage];
}

- (SDLLanguage)language {
    return [self objectForName:SDLNameLanguage];
}

- (void)setKeyboardLayout:(SDLKeyboardLayout)keyboardLayout {
    [self setObject:keyboardLayout forName:SDLNameKeyboardLayout];
}

- (SDLKeyboardLayout)keyboardLayout {
    return [self objectForName:SDLNameKeyboardLayout];
}

- (void)setKeypressMode:(SDLKeypressMode)keypressMode {
    [self setObject:keypressMode forName:SDLNameKeypressMode];
}

- (SDLKeypressMode)keypressMode {
    return [self objectForName:SDLNameKeypressMode];
}

- (void)setLimitedCharacterList:(NSMutableArray<NSString *> *)limitedCharacterList {
    [self setObject:limitedCharacterList forName:SDLNameLimitedCharacterList];
}

- (NSMutableArray<NSString *> *)limitedCharacterList {
    return [self objectForName:SDLNameLimitedCharacterList];
}

- (void)setAutoCompleteText:(NSString *)autoCompleteText {
    [self setObject:autoCompleteText forName:SDLNameAutoCompleteText];
}

- (NSString *)autoCompleteText {
    return [self objectForName:SDLNameAutoCompleteText];
}

@end
