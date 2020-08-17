//
//  VideoStreamingSettingsViewController.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 7/28/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <UIKit/UIKit.h>
#import "VideoStreamSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoStreamingSettingsViewController : UIViewController
@property(nonatomic, strong) VideoStreamSettings *videoStreamSettings;
@end

NS_ASSUME_NONNULL_END
