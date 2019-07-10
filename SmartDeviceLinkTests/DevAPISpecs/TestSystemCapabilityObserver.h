//
//  TestSystemCapabilityObserver.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 5/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLSystemCapabilityManager;

NS_ASSUME_NONNULL_BEGIN

@interface TestSystemCapabilityObserver : NSObject

@property (assign, nonatomic) NSUInteger selectorCalledCount;

- (void)capabilityUpdated;
- (void)capabilityUpdatedWithNotification:(SDLSystemCapabilityManager *)capabilityManager;

@end

NS_ASSUME_NONNULL_END
