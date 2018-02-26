//
//  TestMultipleRequestsConnectionManager.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/8/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestConnectionManager.h"

@interface TestMultipleRequestsConnectionManager : TestConnectionManager

/**
 *  A response and error to pass into the last request's block
 */
@property (copy, nonatomic) NSMutableDictionary *responses;

@end
