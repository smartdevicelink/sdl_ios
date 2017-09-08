//
//  SDLHapticHitTester.h
//  SmartDeviceLink-iOS
//
//  Created by EBUser on 9/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLTouch;

@protocol SDLHapticHitTester <NSObject>

- (nullable UIView *)viewForSDLTouch:(SDLTouch *_Nonnull)touch;

@end
