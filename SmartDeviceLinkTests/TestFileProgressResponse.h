//
//  TestFileProgressResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/17/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestFileProgressResponse : NSObject

@property (strong, nonatomic) NSString *testFileName;
@property (nonatomic) float testUploadPercentage;
@property (strong, nonatomic) NSError *testError;

- (instancetype)initWithFileName:(NSString *)testFileName testUploadPercentage:(float)testUploadPercentage error:(NSError *)testError;

@end
