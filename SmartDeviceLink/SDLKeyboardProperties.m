//  SDLKeyboardProperties.m
//

#import "SDLKeyboardProperties.h"

#import "SDLNames.h"

@implementation SDLKeyboardProperties

- (void)setLanguage:(SDLLanguage)language {
    if (language != nil) {
        [store setObject:language forKey:SDLNameLanguage];
    } else {
        [store removeObjectForKey:SDLNameLanguage];
    }
}

- (SDLLanguage)language {
    NSObject *obj = [store objectForKey:SDLNameLanguage];
    return (SDLLanguage )obj;
}

- (void)setKeyboardLayout:(SDLKeyboardLayout)keyboardLayout {
    if (keyboardLayout != nil) {
        [store setObject:keyboardLayout forKey:SDLNameKeyboardLayout];
    } else {
        [store removeObjectForKey:SDLNameKeyboardLayout];
    }
}

- (SDLKeyboardLayout)keyboardLayout {
    NSObject *obj = [store objectForKey:SDLNameKeyboardLayout];
    return (SDLKeyboardLayout)obj;
}

- (void)setKeypressMode:(SDLKeypressMode)keypressMode {
    if (keypressMode != nil) {
        [store setObject:keypressMode forKey:SDLNameKeypressMode];
    } else {
        [store removeObjectForKey:SDLNameKeypressMode];
    }
}

- (SDLKeypressMode)keypressMode {
    NSObject *obj = [store objectForKey:SDLNameKeypressMode];
    return (SDLKeypressMode)obj;
}

- (void)setLimitedCharacterList:(NSMutableArray *)limitedCharacterList {
    if (limitedCharacterList != nil) {
        [store setObject:limitedCharacterList forKey:SDLNameLimitedCharacterList];
    } else {
        [store removeObjectForKey:SDLNameLimitedCharacterList];
    }
}

- (NSMutableArray *)limitedCharacterList {
    return [store objectForKey:SDLNameLimitedCharacterList];
}

- (void)setAutoCompleteText:(NSString *)autoCompleteText {
    if (autoCompleteText != nil) {
        [store setObject:autoCompleteText forKey:SDLNameAutoCompleteText];
    } else {
        [store removeObjectForKey:SDLNameAutoCompleteText];
    }
}

- (NSString *)autoCompleteText {
    return [store objectForKey:SDLNameAutoCompleteText];
}

@end
