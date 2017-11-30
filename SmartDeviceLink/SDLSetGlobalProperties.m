//  SDLSetGlobalProperties.m
//


#import "SDLSetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:nil vrHelp:nil];
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:vrHelpTitle vrHelp:vrHelp menuTitle:nil menuIcon:nil keyboardProperties:nil];
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(nullable NSString *)menuTitle menuIcon:(nullable SDLImage *)menuIcon keyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.helpPrompt = [SDLTTSChunk textChunksFromString:helpText];
    self.timeoutPrompt = [SDLTTSChunk textChunksFromString:timeoutText];
    self.vrHelpTitle = vrHelpTitle;
    self.vrHelp = [vrHelp mutableCopy];
    self.menuTitle = menuTitle;
    self.menuIcon = menuIcon;
    self.keyboardProperties = keyboardProperties;

    return self;
}

- (void)setHelpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    [parameters sdl_setObject:helpPrompt forName:SDLNameHelpPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    return [parameters sdl_objectsForName:SDLNameHelpPrompt ofClass:SDLTTSChunk.class];
}

- (void)setTimeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    [parameters sdl_setObject:timeoutPrompt forName:SDLNameTimeoutPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    return [parameters sdl_objectsForName:SDLNameTimeoutPrompt ofClass:SDLTTSChunk.class];
}

- (void)setVrHelpTitle:(nullable NSString *)vrHelpTitle {
    [parameters sdl_setObject:vrHelpTitle forName:SDLNameVRHelpTitle];
}

- (nullable NSString *)vrHelpTitle {
    return [parameters sdl_objectForName:SDLNameVRHelpTitle];
}

- (void)setVrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    [parameters sdl_setObject:vrHelp forName:SDLNameVRHelp];
}

- (nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [parameters sdl_objectsForName:SDLNameVRHelp ofClass:SDLVRHelpItem.class];
}

- (void)setMenuTitle:(nullable NSString *)menuTitle {
    [parameters sdl_setObject:menuTitle forName:SDLNameMenuTitle];
}

- (nullable NSString *)menuTitle {
    return [parameters sdl_objectForName:SDLNameMenuTitle];
}

- (void)setMenuIcon:(nullable SDLImage *)menuIcon {
    [parameters sdl_setObject:menuIcon forName:SDLNameMenuIcon];
}

- (nullable SDLImage *)menuIcon {
    return [parameters sdl_objectForName:SDLNameMenuIcon ofClass:SDLImage.class];
}

- (void)setKeyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties {
    [parameters sdl_setObject:keyboardProperties forName:SDLNameKeyboardProperties];
}

- (nullable SDLKeyboardProperties *)keyboardProperties {
    return [parameters sdl_objectForName:SDLNameKeyboardProperties ofClass:SDLKeyboardProperties.class];
}

@end

NS_ASSUME_NONNULL_END
