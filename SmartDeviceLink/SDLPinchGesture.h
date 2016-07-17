//
//  SDLPinchGesture.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLTouch.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLPinchGesture : NSObject

- (instancetype)initWithFirstTouch:(SDLTouch*)firstTouch secondTouch:(SDLTouch*)secondTouch;

@property (nonatomic, copy) SDLTouch* firstTouch;
@property (nonatomic, copy) SDLTouch* secondTouch;

@property (nonatomic, assign, readonly) CGFloat distance;
@property (nonatomic, assign, readonly) CGPoint center;
@property (nonatomic, assign, readonly) BOOL isValid;

@end

NS_ASSUME_NONNULL_END