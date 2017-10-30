//
//  SDLHapticRect.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLRPCStruct.h"

@class SDLRectangle;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Defines spatial for each user control object for video streaming application
 */
@interface SDLHapticRect : SDLRPCStruct

- (instancetype)initWithId:(UInt32)id rect:(SDLRectangle *)rect;

/**
 *  A user control spatial identifier
 *  Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *id;

@property (strong, nonatomic) SDLRectangle *rect;

@end

NS_ASSUME_NONNULL_END
