//
//  SDLLogTargetASL.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogTargetAppleSystemLog.h"

#import <asl.h>

#import "SDLLogModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLogTargetAppleSystemLog ()

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation SDLLogTargetAppleSystemLog
#pragma clang diagnostic pop

+ (id<SDLLogTarget>)logger {
    return [[self alloc] init];
}

- (BOOL)setupLogger {
    return YES;
}

- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog {
    const char *charLog = [stringLog UTF8String];

    int aslLevel = [self sdl_aslLevelForSDLLogLevel:log.level];
    int result = asl_log_message(aslLevel, "%s", charLog);

    if (result != 0) {
        // Something failed
    }
}

- (void)teardownLogger {

}


#pragma mark - Utilities

- (int)sdl_aslLevelForSDLLogLevel:(SDLLogLevel)level {
    switch (level) {
        case SDLLogLevelVerbose: return ASL_LEVEL_NOTICE;
        case SDLLogLevelDebug: return ASL_LEVEL_NOTICE;
        case SDLLogLevelWarning: return ASL_LEVEL_ERR;
        case SDLLogLevelError: return ASL_LEVEL_CRIT;
        default:
            NSAssert(NO, @"The OFF and DEFAULT log levels are not valid to log with.");
            return ASL_LEVEL_DEBUG;
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
