//
//  SDLSubscribeButtonObserver.h
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLNotificationConstants.h"

NS_ASSUME_NONNULL_BEGIN

/// A handler mirroring the one in SDLSubscribeButtonManager.h for `subscribeButton:withBlock:`
typedef void (^SDLSubscribeButtonUpdateHandler)(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error);

/// An observer object for SDLSubscribeButtonManager
@interface SDLSubscribeButtonObserver : NSObject

/// The object that will be used to call the selector if available, and to unsubscribe this observer
@property (weak, nonatomic) id<NSObject> observer;

/// A selector called when the observer is triggered
@property (assign, nonatomic) SEL selector;

/// A block called when the observer is triggered
@property (copy, nonatomic) SDLSubscribeButtonUpdateHandler updateBlock;

/// Create an observer using an object and a selector on that object
/// @param observer The object to be called when the subscription triggers
/// @param selector The selector to be called when the subscription triggers
/// @return The observer
- (instancetype)initWithObserver:(id<NSObject>)observer selector:(SEL)selector;

/// Create an observer using an object and a callback block
/// @param observer The object that can be used to unsubscribe the block
/// @param block The block that will be called when the subscription triggers
/// @return The observer
- (instancetype)initWithObserver:(id<NSObject>)observer updateHandler:(SDLSubscribeButtonUpdateHandler)block;

@end

NS_ASSUME_NONNULL_END
