//
//  VideoSourceViewController.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import <UIKit/UIKit.h>
#import "SDLStreamingMediaDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoSourceViewController : UIViewController <SDLStreamingMediaDelegate>

+ (instancetype)createInstance;

@end

NS_ASSUME_NONNULL_END
