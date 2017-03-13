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


@implementation SDLLogTargetAppleSystemLog

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

@end

NS_ASSUME_NONNULL_END
