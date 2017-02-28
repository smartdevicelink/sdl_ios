//
//  SDLLogTargetOSLog.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogTargetOSLog.h"

#import "SDLLogModel.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLLogTargetOSLog

+ (id<SDLLogTarget>)logger {
    return [[self alloc] init];
}

- (BOOL)setupLogger {
    return YES;
}

- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog {

}

- (void)teardownLogger {

}

@end

NS_ASSUME_NONNULL_END
