//
//  SDLPinchGesture.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLTouch.h"

@interface SDLPinchGesture : NSObject

- (instancetype)initWithFirstTouch:(SDLTouch*)firstTouch secondTouch:(SDLTouch*)secondTouch;

@property (nonatomic, strong) SDLTouch* firstTouch;
@property (nonatomic, strong) SDLTouch* secondTouch;

@property (nonatomic, readonly) CGFloat distance;
@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) BOOL isValid;

@end
