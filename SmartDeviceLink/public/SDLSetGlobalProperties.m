//  SDLSetGlobalProperties.m
//


#import "SDLSetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"
#import "SDLSeatLocation.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetGlobalProperties

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetGlobalProperties]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(nullable NSString *)menuTitle menuIcon:(nullable SDLImage *)menuIcon keyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties menuLayout:(nullable SDLMenuLayout)menuLayout {
    return [self initWithUserLocation:nil helpPrompt:[SDLTTSChunk textChunksFromString:helpText] timeoutPrompt:[SDLTTSChunk textChunksFromString:timeoutText] vrHelpTitle:vrHelpTitle vrHelp:vrHelp menuTitle:menuTitle menuIcon:menuIcon keyboardProperties:keyboardProperties menuLayout:menuLayout];
}

- (instancetype)initWithUserLocation:(nullable SDLSeatLocation *)userLocation helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(nullable NSString *)menuTitle menuIcon:(nullable SDLImage *)menuIcon keyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties menuLayout:(nullable SDLMenuLayout)menuLayout {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.helpPrompt = helpPrompt;
    self.timeoutPrompt = timeoutPrompt;
    self.vrHelpTitle = vrHelpTitle;
    self.vrHelp = [vrHelp mutableCopy];
    self.menuTitle = menuTitle;
    self.menuIcon = menuIcon;
    self.keyboardProperties = keyboardProperties;
    self.userLocation = userLocation;
    self.menuLayout = menuLayout;

    return self;
}

- (void)setHelpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    [self.parameters sdl_setObject:helpPrompt forName:SDLRPCParameterNameHelpPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameHelpPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setTimeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    [self.parameters sdl_setObject:timeoutPrompt forName:SDLRPCParameterNameTimeoutPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTimeoutPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setVrHelpTitle:(nullable NSString *)vrHelpTitle {
    [self.parameters sdl_setObject:vrHelpTitle forName:SDLRPCParameterNameVRHelpTitle];
}

- (nullable NSString *)vrHelpTitle {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameVRHelpTitle ofClass:NSString.class error:nil];
}

- (void)setVrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    [self.parameters sdl_setObject:vrHelp forName:SDLRPCParameterNameVRHelp];
}

- (nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameVRHelp ofClass:SDLVRHelpItem.class error:nil];
}

- (void)setMenuTitle:(nullable NSString *)menuTitle {
    [self.parameters sdl_setObject:menuTitle forName:SDLRPCParameterNameMenuTitle];
}

- (nullable NSString *)menuTitle {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuTitle ofClass:NSString.class error:nil];
}

- (void)setMenuIcon:(nullable SDLImage *)menuIcon {
    [self.parameters sdl_setObject:menuIcon forName:SDLRPCParameterNameMenuIcon];
}

- (nullable SDLImage *)menuIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuIcon ofClass:SDLImage.class error:nil];
}

- (void)setKeyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties {
    [self.parameters sdl_setObject:keyboardProperties forName:SDLRPCParameterNameKeyboardProperties];
}

- (nullable SDLKeyboardProperties *)keyboardProperties {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameKeyboardProperties ofClass:SDLKeyboardProperties.class error:nil];
}

- (void)setUserLocation:(nullable SDLSeatLocation *)userLocation {
    [self.parameters sdl_setObject:userLocation forName:SDLRPCParameterNameUserLocation];
}

- (nullable SDLSeatLocation *)userLocation {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameUserLocation ofClass:SDLSeatLocation.class error:nil];
}

- (void)setMenuLayout:(nullable SDLMenuLayout)menuLayout {
    [self.parameters sdl_setObject:menuLayout forName:SDLRPCParameterNameMenuLayout];
}

- (nullable SDLMenuLayout)menuLayout {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameMenuLayout error:nil];
}

@end

NS_ASSUME_NONNULL_END
