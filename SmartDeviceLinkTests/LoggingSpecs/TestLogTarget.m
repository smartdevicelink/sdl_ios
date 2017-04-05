//
//  TestLogTarget.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestLogTarget.h"

#import "SDLLogModel.h"


@interface TestLogTarget ()

@property (strong, nonatomic) NSMutableArray<SDLLogModel *> *mutableLoggedMessages;
@property (strong, nonatomic) NSMutableArray<NSString *> *mutableFormattedLogMessages;

@end

@implementation TestLogTarget

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _mutableLoggedMessages = [NSMutableArray array];
    _mutableFormattedLogMessages = [NSMutableArray array];

    return self;
}

- (NSArray<SDLLogModel *> *)loggedMessages {
    return [_mutableLoggedMessages copy];
}

- (NSArray<NSString *> *)formattedLogMessages {
    return [_mutableFormattedLogMessages copy];
}

+ (id<SDLLogTarget>)logger {
    return [[self alloc] init];
}

- (BOOL)setupLogger {
    return YES;
}

- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog {
    [_mutableLoggedMessages addObject:log];
    [_mutableFormattedLogMessages addObject:stringLog];
}

- (void)teardownLogger {

}

@end
