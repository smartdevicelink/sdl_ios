//
//  SDLHapticManager.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLHapticInterface.h"
#import "SDLHapticHitTester.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLHapticManager : NSObject <SDLHapticInterface, SDLHapticHitTester>

@end

NS_ASSUME_NONNULL_END
