//
//  TestResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/17/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLPutFileResponse.h"

@interface TestResponse : NSObject

@property (strong, nonatomic) SDLPutFileResponse *testResponse;
@property (strong, nonatomic) NSError *testError;

- (instancetype)initWithResponse:(SDLPutFileResponse *)testResponse error:(NSError *)testError;

@end
