//  SDLKeyboardProperties.m
//

#import "SDLKeyboardProperties.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLKeyboardProperties

- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText {
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

- (void)setLanguage:(nullable SDLLanguage)language {
    if (language != nil) {
        [store setObject:language forKey:SDLNameLanguage];
    } else {
        [store removeObjectForKey:SDLNameLanguage];
    }
}

- (nullable SDLLanguage)language {
    NSObject *obj = [store objectForKey:SDLNameLanguage];
    return (SDLLanguage )obj;
}

- (void)setKeyboardLayout:(nullable SDLKeyboardLayout)keyboardLayout {
    if (keyboardLayout != nil) {
        [store setObject:keyboardLayout forKey:SDLNameKeyboardLayout];
    } else {
        [store removeObjectForKey:SDLNameKeyboardLayout];
    }
}

- (nullable SDLKeyboardLayout)keyboardLayout {
    NSObject *obj = [store objectForKey:SDLNameKeyboardLayout];
    return (SDLKeyboardLayout)obj;
}

- (void)setKeypressMode:(nullable SDLKeypressMode)keypressMode {
    if (keypressMode != nil) {
        [store setObject:keypressMode forKey:SDLNameKeypressMode];
    } else {
        [store removeObjectForKey:SDLNameKeypressMode];
    }
}

- (nullable SDLKeypressMode)keypressMode {
    NSObject *obj = [store objectForKey:SDLNameKeypressMode];
    return (SDLKeypressMode)obj;
}

- (void)setLimitedCharacterList:(nullable NSMutableArray<NSString *> *)limitedCharacterList {
    if (limitedCharacterList != nil) {
        [store setObject:limitedCharacterList forKey:SDLNameLimitedCharacterList];
    } else {
        [store removeObjectForKey:SDLNameLimitedCharacterList];
    }
}

- (nullable NSMutableArray<NSString *> *)limitedCharacterList {
    return [store objectForKey:SDLNameLimitedCharacterList];
}

- (void)setAutoCompleteText:(nullable NSString *)autoCompleteText {
    if (autoCompleteText != nil) {
        [store setObject:autoCompleteText forKey:SDLNameAutoCompleteText];
    } else {
        [store removeObjectForKey:SDLNameAutoCompleteText];
    }
}

- (nullable NSString *)autoCompleteText {
    return [store objectForKey:SDLNameAutoCompleteText];
}

@end

NS_ASSUME_NONNULL_END
