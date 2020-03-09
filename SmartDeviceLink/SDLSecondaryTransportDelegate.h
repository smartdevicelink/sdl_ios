//
//  SDLSecondaryTransportDelegate.h
//  SmartDeviceLink
//
//  Created by Nicole on 3/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLSecondaryTransportDelegate <NSObject>

/// Called when the secondary transport should be destroyed.
- (void)destroySecondaryTransport;

@end

NS_ASSUME_NONNULL_END
