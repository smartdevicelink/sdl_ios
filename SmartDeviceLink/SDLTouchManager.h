//
//  SDLTouchManager.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLTouchManagerListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTouchManager : NSObject

@property (nonatomic, weak, nullable) id<SDLTouchManagerListener> touchEventListener;

/*
 *  Distance between taps.
 */
@property (nonatomic, assign) CGFloat tapDistanceThreshold;

/*
 *  Duration between taps (in seconds).
 */
@property (nonatomic, assign) CGFloat tapTimeThreshold;

/*
 *  Time between pan events (in seconds).
 */
@property (nonatomic, assign) CGFloat movementTimeThreshold;

@property (nonatomic, assign, getter=isTouchEnabled) BOOL touchEnabled;

@end

NS_ASSUME_NONNULL_END