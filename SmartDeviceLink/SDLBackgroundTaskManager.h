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

/// Handler called when the background task is about to expire. Use this handler to perform some cleanup before the background task is destroyed. When you have finished cleanup, you must call the `endBackgroundTask` function so the background task can be destroyed. If you do not call `endBackgroundTask`, the system may kill the app.
/// @return Whether or not to wait for the subscriber to cleanup. If NO, the background task will be killed immediately. If YES, the background task will not be destroyed until the `endBackgroundTask` method is called by the subscriber.
@property (copy, nonatomic, nullable) BOOL (^taskExpiringHandler)(void);

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Convenience init for starting a background task with a specific name.
 *
 *  @param backgroundTaskName  The name for the background task
 *  @return                    A SDLBackgroundTaskManager object
 */
- (instancetype)initWithBackgroundTaskName:(NSString *)backgroundTaskName;

/// Starts a background task. If the app is not currently backgrounded, the background task will remain dormant until the app moves to the background.
- (void)startBackgroundTask;

/// Destroys the background task.
- (void)endBackgroundTask;

@end

NS_ASSUME_NONNULL_END
