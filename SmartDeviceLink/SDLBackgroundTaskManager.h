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

/**
 * Class for managing a background task. 
 */
@interface SDLBackgroundTaskManager : NSObject

/// Handler called when the background task has ended.
@property (copy, nonatomic, nullable) void (^taskEndedHandler)(void);

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Convenience init for starting a background task with a specific name.
 *
 *  @param backgroundTaskName  The name for the background task
 *  @return                    A SDLBackgroundTaskManager object
 */
- (instancetype)initWithBackgroundTaskName:(NSString *)backgroundTaskName;

/**
 *  Starts a background task that allows the app to establish a session while app is backgrounded. If the app is not currently backgrounded, the background task will remain dormant until the app moves to the background.
 */
- (void)startBackgroundTask;

/**
 *  Cleans up a background task when it is stopped. This should be called when:
 *
 *  1. The app has established a session.
 *  2. The system has called the `expirationHandler` for the background task. The system may kill the app if the background task is not ended when `expirationHandler` is called.
 */
- (void)endBackgroundTask;

@end

NS_ASSUME_NONNULL_END
