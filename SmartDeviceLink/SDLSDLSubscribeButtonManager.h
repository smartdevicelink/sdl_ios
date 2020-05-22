//
//  SDLSDLSubscribeButtonManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLButtonName.h"
#import "SDLNotificationConstants.h"

NS_ASSUME_NONNULL_BEGIN

/// A handler run when the subscribe button has been selected
/// @param buttonPress Indicates whether this is a long or short button press event
/// @param buttonEvent Indicates that the button has been depressed or released
/// @param error The error if one occurred
typedef void (^SDLSubscribeButtonUpdateHandler)(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error);

/// The handler run when the update has completed
/// @param error An error if the update failed and an error occurred
typedef void(^SDLSubscribeButtonUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLSubscribeButtonManager : NSObject

- (nullable id<NSObject>)subscribeButton:(SDLButtonName)buttonName withBlock:(nullable SDLSubscribeButtonUpdateHandler)block;

- (void)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector;

- (void)unsubscribeButtonWithObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)block;

@end

NS_ASSUME_NONNULL_END
