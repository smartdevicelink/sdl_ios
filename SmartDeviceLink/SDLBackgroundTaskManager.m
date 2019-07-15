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
    SDLLogV(@"SDLBackgroundTaskManager init with name %@", backgroundTaskName);
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

    __weak typeof(self) weakself = self;
    self.currentBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:self.backgroundTaskName expirationHandler:^{
        SDLLogD(@"The %@ background task expired", self.backgroundTaskName);
        [weakself endBackgroundTask];
    }];

    SDLLogD(@"The %@ background task started with id: %lu", self.backgroundTaskName, (unsigned long)self.currentBackgroundTaskId);
}

- (void)endBackgroundTask {
    if (self.currentBackgroundTaskId == UIBackgroundTaskInvalid) {
        SDLLogV(@"Background task already ended. Returning...");
        return;
    }

    SDLLogD(@"Ending background task with id: %lu",  (unsigned long)self.currentBackgroundTaskId);
    [[UIApplication sharedApplication] endBackgroundTask:self.currentBackgroundTaskId];
    self.currentBackgroundTaskId = UIBackgroundTaskInvalid;
}

- (void)dealloc {
    [self endBackgroundTask];
}

@end

NS_ASSUME_NONNULL_END
