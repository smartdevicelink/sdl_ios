//
//  SDLHapticHitTester.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLTouch;

@protocol SDLHapticHitTester <NSObject>

- (nullable UIView *)viewForSDLTouch:(SDLTouch *_Nonnull)touch;

@end
