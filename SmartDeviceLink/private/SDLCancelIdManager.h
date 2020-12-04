//
//  SDLCancelIdManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/30/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLCancelIdManager : NSObject

/// Stop the manager and reset all properties
- (void)stop;

/// Gets the next available cancel id
- (UInt16)nextCancelId;

@end

NS_ASSUME_NONNULL_END
