//  SDLKeyboardProperties.m
//

#import "SDLKeyboardProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLKeyboardProperties

- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText {
    return [self initWithLanguage:language layout:layout keypressMode:keypressMode limitedCharacterList:limitedCharacterList autoCompleteText:autoCompleteText autoCompleteList:nil];
}

- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText autoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.language = language;
    self.keyboardLayout = layout;
    self.keypressMode = keypressMode;
    self.limitedCharacterList = [limitedCharacterList mutableCopy];
    self.autoCompleteText = autoCompleteText;
    self.autoCompleteList = autoCompleteList;

    return self;
}

- (void)setLanguage:(nullable SDLLanguage)language {
    [store sdl_setObject:language forName:SDLNameLanguage];
}

- (nullable SDLLanguage)language {
    return [store sdl_objectForName:SDLNameLanguage];
}

- (void)setKeyboardLayout:(nullable SDLKeyboardLayout)keyboardLayout {
    [store sdl_setObject:keyboardLayout forName:SDLNameKeyboardLayout];
}

- (nullable SDLKeyboardLayout)keyboardLayout {
    return [store sdl_objectForName:SDLNameKeyboardLayout];
}

- (void)setKeypressMode:(nullable SDLKeypressMode)keypressMode {
    [store sdl_setObject:keypressMode forName:SDLNameKeypressMode];
}

- (nullable SDLKeypressMode)keypressMode {
    return [store sdl_objectForName:SDLNameKeypressMode];
}

- (void)setLimitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList {
    [store sdl_setObject:limitedCharacterList forName:SDLNameLimitedCharacterList];
}

- (nullable NSArray<NSString *> *)limitedCharacterList {
    return [store sdl_objectForName:SDLNameLimitedCharacterList];
}

- (void)setAutoCompleteText:(nullable NSString *)autoCompleteText {
    [store sdl_setObject:autoCompleteText forName:SDLNameAutoCompleteText];
}

- (nullable NSString *)autoCompleteText {
    return [store sdl_objectForName:SDLNameAutoCompleteText];
}

- (void)setAutoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList {
    [store sdl_setObject:autoCompleteList forName:SDLNameAutoCompleteList];
}

- (nullable NSArray<NSString *> *)autoCompleteList {
    return [store sdl_objectForName:SDLNameAutoCompleteList];
}

@end

NS_ASSUME_NONNULL_END
