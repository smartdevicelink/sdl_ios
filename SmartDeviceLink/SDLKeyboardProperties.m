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
    [store sdl_setObject:language forName:SDLNameLanguage];
}

- (SDLLanguage)language {
    return [store sdl_objectForName:SDLNameLanguage];
}

- (void)setKeyboardLayout:(SDLKeyboardLayout)keyboardLayout {
    [store sdl_setObject:keyboardLayout forName:SDLNameKeyboardLayout];
}

- (SDLKeyboardLayout)keyboardLayout {
    return [store sdl_objectForName:SDLNameKeyboardLayout];
}

- (void)setKeypressMode:(SDLKeypressMode)keypressMode {
    [store sdl_setObject:keypressMode forName:SDLNameKeypressMode];
}

- (SDLKeypressMode)keypressMode {
    return [store sdl_objectForName:SDLNameKeypressMode];
}

- (void)setLimitedCharacterList:(NSMutableArray<NSString *> *)limitedCharacterList {
    [store sdl_setObject:limitedCharacterList forName:SDLNameLimitedCharacterList];
}

- (NSMutableArray<NSString *> *)limitedCharacterList {
    return [store sdl_objectForName:SDLNameLimitedCharacterList];
}

- (void)setAutoCompleteText:(NSString *)autoCompleteText {
    [store sdl_setObject:autoCompleteText forName:SDLNameAutoCompleteText];
}

- (NSString *)autoCompleteText {
    return [store sdl_objectForName:SDLNameAutoCompleteText];
}

@end
