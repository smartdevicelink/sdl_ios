//
//  TestUIAppViewController.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 5/25/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <UIKit/UIKit.h>
#import "SDLCarWindowViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestUIAppViewController : UIViewController <SDLCarWindowViewControllerProtocol>

+ (TestUIAppViewController*)createViewController;

@end

NS_ASSUME_NONNULL_END
