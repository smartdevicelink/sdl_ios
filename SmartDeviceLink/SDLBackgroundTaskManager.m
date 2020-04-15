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
@property (copy, nonatomic) NSString *backgroundTaskName;
@property (assign, nonatomic) UIBackgroundTaskIdentifier currentBackgroundTaskId;

@end

@implementation SDLBackgroundTaskManager

- (instancetype)initWithBackgroundTaskName:(NSString *)backgroundTaskName {
    SDLLogV(@"Creating background task manager with name %@", backgroundTaskName);
    self = [super init];
    if (!self) {
        return nil;
    }

    _backgroundTaskName = backgroundTaskName;

    return self;
}

- (void)startBackgroundTask {
    if (self.currentBackgroundTaskId != UIBackgroundTaskInvalid) {
        SDLLogV(@"The %@ background task is already running.", self.backgroundTaskName);
        return;
    }

    __weak typeof(self) weakSelf = self;
    self.currentBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:self.backgroundTaskName expirationHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"The background task %@ is expiring.", strongSelf.backgroundTaskName);

        // We have ~1 second to do cleanup before ending the background task. If we take too long, the system will kill the app.
        if (strongSelf.taskExpiringHandler != nil) {
            SDLLogD(@"Checking if subscriber wants to to perform some cleanup before ending the background task %@", strongSelf.backgroundTaskName);
            BOOL waitForCleanupToFinish = strongSelf.taskExpiringHandler();
            if (waitForCleanupToFinish) {
                SDLLogD(@"The subscriber will end background task itself %@. Waiting...", self.backgroundTaskName);
            } else {
                SDLLogV(@"Subscriber does not want to perform cleanup. Ending the background task %@", strongSelf.backgroundTaskName);
                [strongSelf endBackgroundTask];
            }
        } else {
            // No subscriber. Just end the background task.
            SDLLogV(@"Ending background task %@", strongSelf.backgroundTaskName);
            [strongSelf endBackgroundTask];
        }
    }];

    SDLLogD(@"The %@ background task started with id: %lu", self.backgroundTaskName, (unsigned long)self.currentBackgroundTaskId);
}

- (void)endBackgroundTask {
    SDLLogV(@"Attempting to end background task %@", self.backgroundTaskName);
    self.taskExpiringHandler = nil;

    if (self.currentBackgroundTaskId == UIBackgroundTaskInvalid) {
        SDLLogV(@"Background task %@ with id %lu already ended. Returning...", self.backgroundTaskName, (unsigned long)self.currentBackgroundTaskId);
        return;
    }

    SDLLogD(@"Ending background task %@ with id: %lu", self.backgroundTaskName, (unsigned long)self.currentBackgroundTaskId);
    [[UIApplication sharedApplication] endBackgroundTask:self.currentBackgroundTaskId];
    self.currentBackgroundTaskId = UIBackgroundTaskInvalid;
}

- (void)dealloc {
    SDLLogV(@"Destroying the manager");
    [self endBackgroundTask];
}

@end

NS_ASSUME_NONNULL_END
