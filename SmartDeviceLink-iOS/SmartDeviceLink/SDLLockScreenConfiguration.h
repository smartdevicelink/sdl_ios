//
//  SDLLockScreenConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenConfiguration : NSObject <NSCopying>

@property (assign, nonatomic) BOOL showInOptional;
@property (copy, nonatomic, null_resettable) UIColor *backgroundColor;
@property (copy, nonatomic, nullable) UIImage *appIcon;

+ (instancetype)disabledConfiguration;
+ (instancetype)enabledConfiguration;
+ (instancetype)enabledConfigurationWithBackgroundColor:(UIColor *)lockScreenBackgroundColor appIcon:(UIImage *)lockScreenAppIcon;

@end

NS_ASSUME_NONNULL_END
