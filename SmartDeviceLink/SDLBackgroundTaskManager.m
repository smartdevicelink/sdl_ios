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
    SDLLogV(@"Creating manager with name %@", backgroundTaskName);
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
        SDLLogD(@"The %@ background task expired", strongSelf.backgroundTaskName);
        [strongSelf endBackgroundTask];
    }];

    SDLLogD(@"The %@ background task started with id: %lu", self.backgroundTaskName, (unsigned long)self.currentBackgroundTaskId);
}

- (void)endBackgroundTask {
    if (self.taskEndedHandler != nil) {
        self.taskEndedHandler();
        self.taskEndedHandler = nil;
    }

    if (self.currentBackgroundTaskId == UIBackgroundTaskInvalid) {
        SDLLogV(@"Background task already ended. Returning...");
        return;
    }

    SDLLogD(@"Ending background task with id: %lu", (unsigned long)self.currentBackgroundTaskId);
    [[UIApplication sharedApplication] endBackgroundTask:self.currentBackgroundTaskId];
    self.currentBackgroundTaskId = UIBackgroundTaskInvalid;
}

- (void)dealloc {
    SDLLogV(@"Destroying the manager");
    [self endBackgroundTask];
}

@end

NS_ASSUME_NONNULL_END
