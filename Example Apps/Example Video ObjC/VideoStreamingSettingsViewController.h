//
//  VideoStreamingSettingsViewController.h
//  SmartDeviceLink-Example-ObjC
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import <UIKit/UIKit.h>
#import "VideoStreamSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoStreamingSettingsViewController : UIViewController
@property(nonatomic, strong) VideoStreamSettings *videoStreamSettings;
@end

NS_ASSUME_NONNULL_END
