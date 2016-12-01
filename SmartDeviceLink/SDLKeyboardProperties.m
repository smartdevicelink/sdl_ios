//  SDLKeyboardProperties.m
//

#import "SDLKeyboardProperties.h"

#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLLanguage.h"
#import "SDLNames.h"


@implementation SDLKeyboardProperties

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithLanguage:(SDLLanguage *)language layout:(SDLKeyboardLayout *)layout keypressMode:(SDLKeypressMode *)keypressMode limitedCharacterList:(NSArray *)limitedCharacterList autoCompleteText:(NSString *)autoCompleteText {
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

- (void)setLanguage:(SDLLanguage *)language {
    if (language != nil) {
        [store setObject:language forKey:NAMES_language];
    } else {
        [store removeObjectForKey:NAMES_language];
    }
}

- (SDLLanguage *)language {
    NSObject *obj = [store objectForKey:NAMES_language];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setKeyboardLayout:(SDLKeyboardLayout *)keyboardLayout {
    if (keyboardLayout != nil) {
        [store setObject:keyboardLayout forKey:NAMES_keyboardLayout];
    } else {
        [store removeObjectForKey:NAMES_keyboardLayout];
    }
}

- (SDLKeyboardLayout *)keyboardLayout {
    NSObject *obj = [store objectForKey:NAMES_keyboardLayout];
    if (obj == nil || [obj isKindOfClass:SDLKeyboardLayout.class]) {
        return (SDLKeyboardLayout *)obj;
    } else {
        return [SDLKeyboardLayout valueOf:(NSString *)obj];
    }
}

- (void)setKeypressMode:(SDLKeypressMode *)keypressMode {
    if (keypressMode != nil) {
        [store setObject:keypressMode forKey:NAMES_keypressMode];
    } else {
        [store removeObjectForKey:NAMES_keypressMode];
    }
}

- (SDLKeypressMode *)keypressMode {
    NSObject *obj = [store objectForKey:NAMES_keypressMode];
    if (obj == nil || [obj isKindOfClass:SDLKeypressMode.class]) {
        return (SDLKeypressMode *)obj;
    } else {
        return [SDLKeypressMode valueOf:(NSString *)obj];
    }
}

- (void)setLimitedCharacterList:(NSMutableArray *)limitedCharacterList {
    if (limitedCharacterList != nil) {
        [store setObject:limitedCharacterList forKey:NAMES_limitedCharacterList];
    } else {
        [store removeObjectForKey:NAMES_limitedCharacterList];
    }
}

- (NSMutableArray *)limitedCharacterList {
    return [store objectForKey:NAMES_limitedCharacterList];
}

- (void)setAutoCompleteText:(NSString *)autoCompleteText {
    if (autoCompleteText != nil) {
        [store setObject:autoCompleteText forKey:NAMES_autoCompleteText];
    } else {
        [store removeObjectForKey:NAMES_autoCompleteText];
    }
}

- (NSString *)autoCompleteText {
    return [store objectForKey:NAMES_autoCompleteText];
}

@end
