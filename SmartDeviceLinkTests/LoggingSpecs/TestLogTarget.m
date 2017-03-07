//
//  TestLogTarget.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestLogTarget.h"

@interface TestLogTarget ()

@property (strong, nonatomic) NSMutableArray<NSString *> *mutableLoggedMessages;

@end

@implementation TestLogTarget

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _mutableLoggedMessages = [NSMutableArray array];

    return self;
}

- (NSArray<NSString *> *)loggedMessages {
    return [_mutableLoggedMessages copy];
}

+ (id<SDLLogTarget>)logger {
    return [[self alloc] init];
}

- (BOOL)setupLogger {
    return YES;
}

- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog {
    [_mutableLoggedMessages addObject:stringLog];
}

- (void)teardownLogger {

}

@end
