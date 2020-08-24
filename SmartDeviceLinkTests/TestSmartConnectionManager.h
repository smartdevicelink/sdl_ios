//
//  TestSmartConnectionManager.h
//  SmartDeviceLinkTests
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>
#import "TestConnectionManager.h"
#import "TestSmartConnection.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestSmartConnectionManager : TestConnectionManager
- (void)addConnectionModel:(TestSmartConnection *)model;
@end

NS_ASSUME_NONNULL_END
