//
//  SDLBackgroundTaskManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 6/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLBackgroundTaskManager : NSObject

- (instancetype)initWithBackgroundTaskName:(NSString *)backgroundTaskName;
- (void)startBackgroundTask;
- (void)endBackgroundTask;

@end

NS_ASSUME_NONNULL_END
