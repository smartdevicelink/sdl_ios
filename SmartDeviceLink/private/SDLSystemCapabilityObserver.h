//
//  SDLSystemCapabilityObserver.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLSystemCapability;

NS_ASSUME_NONNULL_BEGIN

/// A handler mirroring the one in SDLSystemCapabilityManager.h for `initWithObserver:block:`
typedef void (^SDLCapabilityUpdateHandler)(SDLSystemCapability *capability);

/// A handler mirroring the one in SDLSystemCapabilityManager.h for `initWithObserver:updateHandler:`
typedef void (^SDLCapabilityUpdateWithErrorHandler)(SDLSystemCapability *_Nullable capability, BOOL subscribed, NSError *_Nullable error);

/**
 An observer object for SDLSystemCapabilityManager
 */
@interface SDLSystemCapabilityObserver : NSObject

/**
 The object that will be used to call the selector if available, and to unsubscribe this observer
 */
@property (strong, nonatomic) id<NSObject> observer;

/**
 A selector called when the observer is triggered
 */
@property (assign, nonatomic) SEL selector;

/// A block called when the observer is triggered
@property (copy, nonatomic) SDLCapabilityUpdateWithErrorHandler updateBlock;

/**
 Create an observer using an object and a selector on that object

 @param observer The object to be called when the subscription triggers
 @param selector The selector to be called when the subscription triggers
 @return The observer
 */
- (instancetype)initWithObserver:(id<NSObject>)observer selector:(SEL)selector;

/// Create an observer using an object and a callback block

/// @param observer The object that can be used to unsubscribe the block
/// @param block The block that will be called when the subscription triggers
/// @return The observer
- (instancetype)initWithObserver:(id<NSObject>)observer updateHandler:(SDLCapabilityUpdateWithErrorHandler)block;

@end

NS_ASSUME_NONNULL_END
