//
//  SDLScreenManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 3/5/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLScreenManager.h"
#import "SDLArtwork.h"
#import "SDLChoiceSetManager.h"
#import "SDLMenuManager.h"
#import "SDLSoftButtonManager.h"
#import "SDLSubscribeButtonManager.h"
#import "SDLTextAndGraphicManager.h"
#import "SDLVoiceCommandManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLScreenManager()

@property (strong, nonatomic) SDLTextAndGraphicManager *textAndGraphicManager;
@property (strong, nonatomic) SDLSoftButtonManager *softButtonManager;
@property (strong, nonatomic) SDLMenuManager *menuManager;
@property (strong, nonatomic) SDLVoiceCommandManager *voiceCommandMenuManager;
@property (strong, nonatomic) SDLChoiceSetManager *choiceSetManager;
@property (strong, nonatomic) SDLSubscribeButtonManager *subscribeButtonManager;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@end

@implementation SDLScreenManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;

    _textAndGraphicManager = [[SDLTextAndGraphicManager alloc] initWithConnectionManager:connectionManager fileManager:fileManager systemCapabilityManager:systemCapabilityManager];
    _softButtonManager = [[SDLSoftButtonManager alloc] initWithConnectionManager:connectionManager fileManager:fileManager systemCapabilityManager:systemCapabilityManager];
    _subscribeButtonManager = [[SDLSubscribeButtonManager alloc] initWithConnectionManager:connectionManager];
    _menuManager = [[SDLMenuManager alloc] initWithConnectionManager:connectionManager fileManager:fileManager systemCapabilityManager:systemCapabilityManager];
    _voiceCommandMenuManager = [[SDLVoiceCommandManager alloc] initWithConnectionManager:connectionManager];
    _choiceSetManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:connectionManager fileManager:fileManager systemCapabilityManager:systemCapabilityManager];

    return self;
}

- (void)startWithCompletionHandler:(void (^)(NSError * _Nullable))handler {
    [self.textAndGraphicManager start];
    [self.softButtonManager start];
    [self.menuManager start];
    [self.choiceSetManager start];
    [self.subscribeButtonManager start];

    handler(nil);
}

- (void)stop {
    [self.textAndGraphicManager stop];
    [self.softButtonManager stop];
    [self.menuManager stop];
    [self.voiceCommandMenuManager stop];
    [self.choiceSetManager stop];
    [self.subscribeButtonManager stop];
}

#pragma mark - Setters

- (void)setTextField1:(nullable NSString *)textField1 {
    self.textAndGraphicManager.textField1 = textField1;
    self.softButtonManager.currentMainField1 = textField1;
}

- (void)setTextField2:(nullable NSString *)textField2 {
    self.textAndGraphicManager.textField2 = textField2;
}

- (void)setTextField3:(nullable NSString *)textField3 {
    self.textAndGraphicManager.textField3 = textField3;
}

- (void)setTextField4:(nullable NSString *)textField4 {
    self.textAndGraphicManager.textField4 = textField4;
}

- (void)setMediaTrackTextField:(nullable NSString *)mediaTrackTextField {
    self.textAndGraphicManager.mediaTrackTextField = mediaTrackTextField;
}

- (void)setPrimaryGraphic:(nullable SDLArtwork *)primaryGraphic {
    if (primaryGraphic == nil) {
        self.textAndGraphicManager.primaryGraphic = self.textAndGraphicManager.blankArtwork;
        return;
    }

    self.textAndGraphicManager.primaryGraphic = primaryGraphic;
}

- (void)setSecondaryGraphic:(nullable SDLArtwork *)secondaryGraphic {
    if (secondaryGraphic == nil) {
        self.textAndGraphicManager.secondaryGraphic = self.textAndGraphicManager.blankArtwork;
        return;
    }

    self.textAndGraphicManager.secondaryGraphic = secondaryGraphic;
}

- (void)setTextAlignment:(SDLTextAlignment)textAlignment {
    self.textAndGraphicManager.alignment = textAlignment;
}

- (void)setTextField1Type:(nullable SDLMetadataType)textField1Type {
    self.textAndGraphicManager.textField1Type = textField1Type;
}

- (void)setTextField2Type:(nullable SDLMetadataType)textField2Type {
    self.textAndGraphicManager.textField2Type = textField2Type;
}

- (void)setTextField3Type:(nullable SDLMetadataType)textField3Type {
    self.textAndGraphicManager.textField3Type = textField3Type;
}

- (void)setTextField4Type:(nullable SDLMetadataType)textField4Type {
    self.textAndGraphicManager.textField4Type = textField4Type;
}

- (void)setTitle:(nullable NSString *)title {
    self.textAndGraphicManager.title = title;
}

- (void)setSoftButtonObjects:(NSArray<SDLSoftButtonObject *> *)softButtonObjects {
    self.softButtonManager.softButtonObjects = softButtonObjects;
}

- (void)setMenuConfiguration:(SDLMenuConfiguration *)menuConfiguration {
    self.menuManager.menuConfiguration = menuConfiguration;
}

- (void)setMenu:(NSArray<SDLMenuCell *> *)menu {
    self.menuManager.menuCells = menu;
}

- (void)setVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    self.voiceCommandMenuManager.voiceCommands = voiceCommands;
}

- (void)setKeyboardConfiguration:(nullable SDLKeyboardProperties *)keyboardConfiguration {
    self.choiceSetManager.keyboardConfiguration = keyboardConfiguration;
}

- (void)setDynamicMenuUpdatesMode:(SDLDynamicMenuUpdatesMode)dynamicMenuUpdatesMode {
    self.menuManager.dynamicMenuUpdatesMode = dynamicMenuUpdatesMode;
}

#pragma mark - Getters

- (nullable NSString *)textField1 {
    return _textAndGraphicManager.textField1;
}

- (nullable NSString *)textField2 {
    return _textAndGraphicManager.textField2;
}

- (nullable NSString *)textField3 {
    return _textAndGraphicManager.textField3;
}

- (nullable NSString *)textField4 {
    return _textAndGraphicManager.textField4;
}

- (nullable NSString *)mediaTrackTextField {
    return _textAndGraphicManager.mediaTrackTextField;
}

- (nullable SDLArtwork *)primaryGraphic {
    if ([_textAndGraphicManager.primaryGraphic.name isEqualToString:_textAndGraphicManager.blankArtwork.name]) {
        return nil;
    }

    return _textAndGraphicManager.primaryGraphic;
}

- (nullable SDLArtwork *)secondaryGraphic {
    if ([_textAndGraphicManager.secondaryGraphic.name isEqualToString:_textAndGraphicManager.blankArtwork.name]) {
        return nil;
    }

    return _textAndGraphicManager.secondaryGraphic;
}

- (SDLTextAlignment)alignment {
    return _textAndGraphicManager.alignment;
}

- (nullable SDLMetadataType)textField1Type {
    return _textAndGraphicManager.textField1Type;
}

- (nullable SDLMetadataType)textField2Type {
    return _textAndGraphicManager.textField2Type;
}

- (nullable SDLMetadataType)textField3Type {
    return _textAndGraphicManager.textField3Type;
}

- (nullable SDLMetadataType)textField4Type {
    return _textAndGraphicManager.textField4Type;
}

- (NSArray<SDLSoftButtonObject *> *)softButtonObjects {
    return _softButtonManager.softButtonObjects;
}

- (SDLMenuConfiguration *)menuConfiguration {
    return _menuManager.menuConfiguration;
}

- (NSArray<SDLMenuCell *> *)menu {
    return _menuManager.menuCells;
}

- (NSArray<SDLVoiceCommand *> *)voiceCommands {
    return _voiceCommandMenuManager.voiceCommands;
}

- (NSSet<SDLChoiceCell *> *)preloadedChoices {
    return _choiceSetManager.preloadedChoices;
}

- (SDLKeyboardProperties *)keyboardConfiguration {
    return _choiceSetManager.keyboardConfiguration;
}

#pragma mark - Begin / End Updates

- (void)beginUpdates {
    self.softButtonManager.batchUpdates = YES;
    self.textAndGraphicManager.batchUpdates = YES;
}

- (void)endUpdates {
    [self endUpdatesWithCompletionHandler:nil];
}

- (void)endUpdatesWithCompletionHandler:(nullable SDLScreenManagerUpdateCompletionHandler)handler {
    self.softButtonManager.batchUpdates = NO;
    self.textAndGraphicManager.batchUpdates = NO;

    [self.textAndGraphicManager updateWithCompletionHandler:handler];
}

#pragma mark - Subscribe Buttons

- (id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(SDLSubscribeButtonHandler)updateHandler {
    return [self.subscribeButtonManager subscribeButton:buttonName withUpdateHandler:updateHandler];
}

- (void)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector {
    [self.subscribeButtonManager subscribeButton:buttonName withObserver:observer selector:selector];
}

- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(SDLScreenManagerUpdateCompletionHandler)completionHandler {
    [self.subscribeButtonManager unsubscribeButton:buttonName withObserver:observer withCompletionHandler:completionHandler];
}

#pragma mark - Soft Buttons

- (nullable SDLSoftButtonObject *)softButtonObjectNamed:(NSString *)name {
    return [self.softButtonManager softButtonObjectNamed:name];
}

#pragma mark - Choice Sets

- (void)deleteChoices:(NSArray<SDLChoiceCell *> *)choices {
    [self.choiceSetManager deleteChoices:choices];
}

- (void)preloadChoices:(NSArray<SDLChoiceCell *> *)choices withCompletionHandler:(nullable SDLPreloadChoiceCompletionHandler)handler {
    [self.choiceSetManager preloadChoices:choices withCompletionHandler:handler];
}

- (void)presentChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode {
    [self.choiceSetManager presentChoiceSet:choiceSet mode:mode withKeyboardDelegate:nil];
}

- (void)presentSearchableChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(id<SDLKeyboardDelegate>)delegate {
    [self.choiceSetManager presentChoiceSet:choiceSet mode:mode withKeyboardDelegate:delegate];
}

- (nullable NSNumber<SDLInt> *)presentKeyboardWithInitialText:(NSString *)initialText delegate:(id<SDLKeyboardDelegate>)delegate {
    return [self.choiceSetManager presentKeyboardWithInitialText:initialText delegate:delegate];
}

- (void)dismissKeyboardWithCancelID:(NSNumber<SDLInt> *)cancelID{
    [self.choiceSetManager dismissKeyboardWithCancelID:cancelID];
}

#pragma mark - Menu

- (BOOL)openMenu {
   return [self.menuManager openMenu];
}

- (BOOL)openSubmenu:(SDLMenuCell *)cell {
  return [self.menuManager openSubmenu:cell];
}

@end

NS_ASSUME_NONNULL_END
