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

@class SDLChoiceSet;

@protocol SDLConnectionManagerType;
@protocol SDLKeyboardDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentChoiceSetOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode keyboardProperties:(nullable SDLKeyboardProperties *)originalKeyboardProperties keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate;

@end

NS_ASSUME_NONNULL_END
