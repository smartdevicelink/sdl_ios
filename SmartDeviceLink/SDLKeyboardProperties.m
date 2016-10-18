//  SDLKeyboardProperties.m
//

#import "SDLKeyboardProperties.h"

#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLLanguage.h"
#import "SDLNames.h"

@implementation SDLKeyboardProperties

- (void)setLanguage:(SDLLanguage *)language {
    if (language != nil) {
        [store setObject:language forKey:SDLNameLanguage];
    } else {
        [store removeObjectForKey:SDLNameLanguage];
    }
}

- (SDLLanguage *)language {
    NSObject *obj = [store objectForKey:SDLNameLanguage];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setKeyboardLayout:(SDLKeyboardLayout *)keyboardLayout {
    if (keyboardLayout != nil) {
        [store setObject:keyboardLayout forKey:SDLNameKeyboardLayout];
    } else {
        [store removeObjectForKey:SDLNameKeyboardLayout];
    }
}

- (SDLKeyboardLayout *)keyboardLayout {
    NSObject *obj = [store objectForKey:SDLNameKeyboardLayout];
    if (obj == nil || [obj isKindOfClass:SDLKeyboardLayout.class]) {
        return (SDLKeyboardLayout *)obj;
    } else {
        return [SDLKeyboardLayout valueOf:(NSString *)obj];
    }
}

- (void)setKeypressMode:(SDLKeypressMode *)keypressMode {
    if (keypressMode != nil) {
        [store setObject:keypressMode forKey:SDLNameKeypressMode];
    } else {
        [store removeObjectForKey:SDLNameKeypressMode];
    }
}

- (SDLKeypressMode *)keypressMode {
    NSObject *obj = [store objectForKey:SDLNameKeypressMode];
    if (obj == nil || [obj isKindOfClass:SDLKeypressMode.class]) {
        return (SDLKeypressMode *)obj;
    } else {
        return [SDLKeypressMode valueOf:(NSString *)obj];
    }
}

- (void)setLimitedCharacterList:(NSMutableArray<NSString *> *)limitedCharacterList {
    if (limitedCharacterList != nil) {
        [store setObject:limitedCharacterList forKey:SDLNameLimitedCharacterList];
    } else {
        [store removeObjectForKey:SDLNameLimitedCharacterList];
    }
}

- (NSMutableArray<NSString *> *)limitedCharacterList {
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
