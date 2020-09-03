//
//  SDLLogTargetOSLog.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogTargetOSLog.h"

#import <os/log.h>

#import "SDLLogModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLogTargetOSLog ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, os_log_t> *clients;

@end


@implementation SDLLogTargetOSLog

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _clients = [NSMutableDictionary dictionary];

    return self;
}

+ (id<SDLLogTarget>)logger {
    return [[self alloc] init];
}

- (BOOL)setupLogger {
    return YES;
}

- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog {
    NSString *moduleName = log.moduleName ? log.moduleName : @"";
    if (self.clients[moduleName] == nil) {
        self.clients[moduleName] = os_log_create("com.sdl.log", moduleName.UTF8String);
    }

    os_log_with_type(self.clients[moduleName], [self oslogLevelForSDLLogLevel:log.level], "%{public}@", log.message);
}

- (void)teardownLogger {
    self.clients = [NSMutableDictionary dictionary];
}

- (os_log_type_t)oslogLevelForSDLLogLevel:(SDLLogLevel)level {
    switch (level) {
        case SDLLogLevelVerbose: return OS_LOG_TYPE_DEBUG;
        case SDLLogLevelDebug: return OS_LOG_TYPE_INFO;
        case SDLLogLevelWarning: return OS_LOG_TYPE_ERROR;
        case SDLLogLevelError: return OS_LOG_TYPE_FAULT;
        default:
            NSAssert(NO, @"The OFF and DEFAULT log levels are not valid to log with.");
            return OS_LOG_TYPE_DEFAULT;
    }
}


#pragma mark - NSObject

- (NSUInteger)hash {
    return NSStringFromClass(self.class).hash;
}

// For the target classes, we're going to assume that if they're the same class, they're the same. The reason for this is so that NSSet, for instance, will only allow one of each target type in a set.
- (BOOL)isEqual:(id)object {
    return [object isMemberOfClass:self.class];
}

@end

NS_ASSUME_NONNULL_END
