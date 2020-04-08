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
        // We have ~1 second to do cleanup before ending the background task. If we take too long, the system will kill the app.
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"The background task %@ expired", strongSelf.backgroundTaskName);
        if (strongSelf.taskEndedHandler != nil) {
            SDLLogD(@"Waiting for cleanup to finish before ending the background task");
            strongSelf.taskEndedHandler();
        } else {
            [strongSelf endBackgroundTask];
        }
    }];

    SDLLogD(@"The %@ background task started with id: %lu", self.backgroundTaskName, (unsigned long)self.currentBackgroundTaskId);
}

- (void)endBackgroundTask {
    SDLLogV(@"Attempting to end background task %@", self.backgroundTaskName);

    if (self.taskEndedHandler != nil) {
        SDLLogD(@"Background task %@ cleanup finished", self.backgroundTaskName);
        self.taskEndedHandler = nil;
    }

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
