//
//  SDLBackgroundTaskManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 6/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLBackgroundTaskManager.h"

#import "SDLLogMacros.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLBackgroundTaskManager ()
@property (nonatomic, assign) NSString *backgroundTaskName;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
@end

@implementation SDLBackgroundTaskManager

- (instancetype)initWithBackgroundTaskName:(NSString *)backgroundTaskName {
    SDLLogV(@"SDLBackgroundTaskManager init with name %@", backgroundTaskName);
    self = [super init];
    if (!self) {
        return nil;
    }

    _backgroundTaskName = backgroundTaskName;

    return self;
}

/**
 *  Starts a background task that allows the app to establish a session while app is backgrounded. If the app is not currently backgrounded, the background task will remain dormant until the app moves to the background.
 */
- (void)startBackgroundTask {
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        SDLLogV(@"The %@ background task is already running.", self.backgroundTaskName);
        return;
    }

    __weak typeof(self) weakself = self;
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:self.backgroundTaskName expirationHandler:^{
        SDLLogD(@"The %@ background task expired", self.backgroundTaskName);
        [weakself endBackgroundTask];
    }];

    SDLLogD(@"The %@ background task started with id: %lu", self.backgroundTaskName, (unsigned long)self.backgroundTaskId);
}

/**
 *  Cleans up a background task when it is stopped. This should be called when:
 *
 *  1. The app has established a session
 *  2. The system has called the `expirationHandler` for the background task. The system may kill the app if the background task is not ended.
 *
 */
- (void)endBackgroundTask {
    if (self.backgroundTaskId == UIBackgroundTaskInvalid) {
        SDLLogV(@"Background task already ended. Returning...");
        return;
    }

    SDLLogD(@"Ending background task with id: %lu",  (unsigned long)self.backgroundTaskId);
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
    self.backgroundTaskId = UIBackgroundTaskInvalid;
}

@end

NS_ASSUME_NONNULL_END
