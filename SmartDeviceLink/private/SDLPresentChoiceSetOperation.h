//
//  SDLPresentChoiceSetOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"
#import "SDLInteractionMode.h"
#import "SDLTriggerSource.h"

@class SDLChoiceCell;
@class SDLChoiceSet;
@class SDLKeyboardProperties;
@class SDLWindowCapability;

@protocol SDLConnectionManagerType;
@protocol SDLKeyboardDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentChoiceSetOperation : SDLAsynchronousOperation

/**
 An operation to present a choice set.

 @param connectionManager The connection manager
 @param choiceSet The choice set to be displayed
 @param mode If the set should be presented for the user to interact via voice, touch, or both
 @param originalKeyboardProperties The keyboard configuration
 @param keyboardDelegate The keyboard delegate called when the user interacts with the keyboard
 @param cancelID A unique ID for this specific choice set that allows cancellation through the `CancelInteraction` RPC.
 @param loadedCells The cells that are loaded on the head unit
 @return A SDLPresentChoiceSetOperation object
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode keyboardProperties:(nullable SDLKeyboardProperties *)originalKeyboardProperties keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate cancelID:(UInt16)cancelID windowCapability:(SDLWindowCapability *)windowCapability loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells completionHandler:(SDLPresentChoiceSetCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
