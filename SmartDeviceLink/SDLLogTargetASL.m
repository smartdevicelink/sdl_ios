//
//  SDLLogTargetASL.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogTargetASL.h"

#import <asl.h>

#import "SDLLogModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLogTargetASL ()

@property (assign, nonatomic, nullable) aslclient client;

@end


@implementation SDLLogTargetASL

+ (id<SDLLogTarget>)logger {
    return [[self alloc] init];
}

- (BOOL)setupLogger {
    self.client = asl_open(NULL, "com.apple.console", 0);

    return !!self.client;
}

- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog {
    int result = 0;
    const char *charLog = [stringLog UTF8String];

    aslmsg message = asl_new(ASL_TYPE_MSG);
    result += asl_set(message, ASL_KEY_MSG, charLog);

    if (result != 0) {
        // Something failed
    }

    int aslLevel = [self sdl_aslLevelForSDLLogLevel:log.level];
    result = asl_log(self.client, message, aslLevel, NULL);

    if (result != 0) {
        // Something failed
    }
}

- (void)teardownLogger {
    asl_close(self.client);
    self.client = NULL;
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
