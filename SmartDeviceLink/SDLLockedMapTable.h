//
//  SDLLockedMapTable.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockedMapTable<KeyType, ObjectType> : NSObject

#pragma mark - Initializers
- (instancetype)init NS_UNAVAILABLE;

/// Create a new locked mutable dictionary with a given dispatch queue. All calls will be reader/writer locked on the queue so that only one operation will occur at a time.
///
/// @param queue The queue to use. It can be either a serial or concurrent queue.
- (instancetype)initWithQueue:(dispatch_queue_t)queue;

@end

NS_ASSUME_NONNULL_END
