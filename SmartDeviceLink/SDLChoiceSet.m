//
//  SDLChoiceSet.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLChoiceSet.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLChoiceSet

static NSTimeInterval _defaultTimeout = 0.0;
static SDLChoiceSetLayout _defaultLayout = SDLChoiceSetLayoutList;

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _timeout = self.class.defaultTimeout;
    _layout = self.class.defaultLayout;

    return self;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate choices:(NSArray<SDLChoiceCell *> *)choices {
    return [self initWithTitle:title delegate:delegate layout:SDLChoiceSet.defaultLayout timeout:SDLChoiceSet.defaultTimeout initialPrompt:nil timeoutPrompt:nil helpPrompt:nil vrHelpList:nil choices:choices];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate layout:(SDLChoiceSetLayout)layout timeout:(NSTimeInterval)timeout initialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt vrHelpList:(nullable NSArray<SDLVRHelpItem *> *)helpList choices:(NSArray<SDLChoiceCell *> *)choices {
    self = [self init];
    if (!self) { return nil; }

    _title = title;
    _delegate = delegate;
    _layout = layout;
    _timeout = timeout;
    _initialPrompt = initialPrompt;
    _timeoutPrompt = timeoutPrompt;
    _helpPrompt = helpPrompt;
    _helpList = helpList;
    _choices = choices;

    return self;
}

#pragma mark - Getters / Setters

+ (NSTimeInterval)defaultTimeout {
    return _defaultTimeout;
}

+ (void)setDefaultTimeout:(NSTimeInterval)defaultTimeout {
    _defaultTimeout = defaultTimeout;
}

+ (SDLChoiceSetLayout)defaultLayout {
    return _defaultLayout;
}

+ (void)setDefaultLayout:(SDLChoiceSetLayout)defaultLayout {
    _defaultLayout = defaultLayout;
}

@end

NS_ASSUME_NONNULL_END
