//
//  TestProgressResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/17/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestFileProgressResponse.h"

@implementation TestFileProgressResponse

- (instancetype)initWithFileName:(NSString *)testFileName testUploadPercentage:(float)testUploadPercentage error:(NSError *)testError {
    self = [super init];
    if (!self) {
        return nil;
    }

    _testFileName = testFileName;
    _testUploadPercentage = testUploadPercentage;
    _testError = testError;

    return self;
}

@end
