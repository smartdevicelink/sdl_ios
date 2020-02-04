//
//  TestSystemCapabilityObserver.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 5/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLSystemCapability;

NS_ASSUME_NONNULL_BEGIN

@interface TestSystemCapabilityObserver : NSObject

@property (assign, nonatomic) NSUInteger selectorCalledCount;

- (void)capabilityUpdated;
- (void)capabilityUpdatedWithCapability:(SDLSystemCapability *)capability;
- (void)capabilityUpdatedWithCapability:(SDLSystemCapability *)capability error:(NSError *)error;
- (void)capabilityUpdatedWithCapability:(SDLSystemCapability *)capability error:(NSError *)error subscribed:(BOOL)subscribed;

@end

NS_ASSUME_NONNULL_END
