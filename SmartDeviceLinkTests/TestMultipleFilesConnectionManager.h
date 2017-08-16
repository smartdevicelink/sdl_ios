//
//  TestMultipleFilesConnectionManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestConnectionManager.h"
#import "SDLPutFileResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestMultipleFilesConnectionManager : TestConnectionManager

/**
 *  A response to pass into the last request's block
 */
@property (strong, nonatomic) SDLPutFileResponse *multipleFileResponse;
@property (copy, nonatomic) NSError *multipleFileError;

@end

NS_ASSUME_NONNULL_END
