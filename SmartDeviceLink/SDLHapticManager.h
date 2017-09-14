//
//  SDLHapticManager.h
//  SmartDeviceLink-iOS
//
//  Created by EBUser on 9/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLHapticInterface.h"
#import "SDLHapticHitTester.h"
#import "SDLManager.h"

@interface SDLHapticManager : NSObject <SDLHapticInterface, SDLHapticHitTester>
- (instancetype)initWithWindow:(UIWindow *)window sdlManager:(SDLManager *)sdlManager;
- (void)updateInterfaceLayout;

@end
