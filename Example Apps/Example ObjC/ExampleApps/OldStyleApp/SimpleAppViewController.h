//
//  SimpleAppViewController.h
//  SmartDeviceLink-iOS
//
//  Created by Leonid Lokhmatov on 5/25/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <UIKit/UIKit.h>
#import "SDLStreamingMediaDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimpleAppViewController<SDLStreamingMediaDelegate> : UIViewController

+ (instancetype)createViewController;

@end

NS_ASSUME_NONNULL_END
