//
//  SDLHapticManager.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLHapticInterface.h"
#import "SDLHapticHitTester.h"
#import "SDLManager.h"

@interface SDLHapticManager : NSObject <SDLHapticInterface, SDLHapticHitTester>
- (instancetype)initWithWindow:(UIWindow *)window sdlManager:(SDLManager *)sdlManager;
- (void)updateInterfaceLayout;
- (UIView *)viewForSDLTouch:(SDLTouch *)touch;

@end
