//
//  SDLPresentKeyboardOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

@protocol SDLConnectionManagerType;
@protocol SDLKeyboardDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentKeyboardOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager initialText:(NSString *)initialText keyboardDelegate:(id<SDLKeyboardDelegate>)keyboardDelegate;

@end

NS_ASSUME_NONNULL_END
