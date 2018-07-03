//
//  SDLOnSeekMediaClockTimer.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/3/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLRPCNotification.h"

@class SDLStartTime;

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnSeekMediaClockTimer : SDLRPCNotification

@property (strong, nonatomic) SDLStartTime *seekTime;

@end

NS_ASSUME_NONNULL_END
