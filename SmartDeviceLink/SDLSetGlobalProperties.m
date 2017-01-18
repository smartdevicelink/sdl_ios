//  SDLSetGlobalProperties.m
//


#import "SDLSetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVRHelpItem.h"


@implementation SDLSetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:nil vrHelp:nil];
}

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:vrHelpTitle vrHelp:vrHelp menuTitle:nil menuIcon:nil keyboardProperties:nil];
}

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(NSString *)menuTitle menuIcon:(SDLImage *)menuIcon keyboardProperties:(SDLKeyboardProperties *)keyboardProperties {
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


- (void)setHelpPrompt:(NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    [parameters sdl_setObject:helpPrompt forName:SDLNameHelpPrompt];
}

- (NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    return [parameters sdl_objectsForName:SDLNameHelpPrompt ofClass:SDLTTSChunk.class];
}

- (void)setTimeoutPrompt:(NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    [parameters sdl_setObject:timeoutPrompt forName:SDLNameTimeoutPrompt];
}

- (NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    return [parameters sdl_objectsForName:SDLNameTimeoutPrompt ofClass:SDLTTSChunk.class];
}

- (void)setVrHelpTitle:(NSString *)vrHelpTitle {
    [parameters sdl_setObject:vrHelpTitle forName:SDLNameVRHelpTitle];
}

- (NSString *)vrHelpTitle {
    return [parameters sdl_objectForName:SDLNameVRHelpTitle];
}

- (void)setVrHelp:(NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    [parameters sdl_setObject:vrHelp forName:SDLNameVRHelp];
}

- (NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    return [parameters sdl_objectsForName:SDLNameVRHelp ofClass:SDLVRHelpItem.class];
}

- (void)setMenuTitle:(NSString *)menuTitle {
    [parameters sdl_setObject:menuTitle forName:SDLNameMenuTitle];
}

- (NSString *)menuTitle {
    return [parameters sdl_objectForName:SDLNameMenuTitle];
}

- (void)setMenuIcon:(SDLImage *)menuIcon {
    [parameters sdl_setObject:menuIcon forName:SDLNameMenuIcon];
}

- (SDLImage *)menuIcon {
    return [parameters sdl_objectForName:SDLNameMenuIcon ofClass:SDLImage.class];
}

- (void)setKeyboardProperties:(SDLKeyboardProperties *)keyboardProperties {
    [parameters sdl_setObject:keyboardProperties forName:SDLNameKeyboardProperties];
}

- (SDLKeyboardProperties *)keyboardProperties {
    return [parameters sdl_objectForName:SDLNameKeyboardProperties ofClass:SDLKeyboardProperties.class];
}

@end
