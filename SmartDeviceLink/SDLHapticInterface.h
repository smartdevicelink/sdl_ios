//
//  SDLHapticInterface.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLManager.h"

@protocol SDLHapticInterface <NSObject>

- (instancetype)initWithWindow:(UIWindow *)window  sdlManager:(SDLManager *)sdlManager;
- (void)updateInterfaceLayout;
// additional method should be added to allow pure openGL apps to specify an array of spatial data directly

@end
