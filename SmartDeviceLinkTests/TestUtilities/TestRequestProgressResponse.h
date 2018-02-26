//
//  TestRequestProgressResponse.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

@interface TestRequestProgressResponse : NSObject

@property (strong, nonatomic) NSNumber<SDLInt> *correlationId;
@property (nonatomic) float percentComplete;
@property (strong, nonatomic) NSError *error;

- (instancetype)initWithCorrelationId:(NSNumber<SDLInt> *)correlationId percentComplete:(float)percentComplete error:(NSError *)error;

@end
