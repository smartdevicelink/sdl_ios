//
//  SDLChoiceSetManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLChoiceSetManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLChoiceSetManager

- (void)deleteChoices:(NSArray<SDLChoiceCell *> *)choices andAttachedImages:(BOOL)deleteImages {

}

- (void)preloadChoices:(NSArray<SDLChoiceCell *> *)choices withCompletionHandler:(nullable SDLPreloadChoiceCompletionHandler)handler {

}

- (void)presentChoiceSet:(SDLChoiceSet *)set mode:(SDLInteractionMode)mode {

}

- (void)presentSearchableChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(id<SDLKeyboardDelegate>)delegate {

}

- (void)presentKeyboardWithInitialText:(NSString *)initialText delegate:(id<SDLKeyboardDelegate>)delegate {

}

@end

NS_ASSUME_NONNULL_END
