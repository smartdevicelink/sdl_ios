//
//  SDLTouchManager.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLTouchManagerListener.h"

@interface SDLTouchManager : NSObject

@property (nonatomic, weak) id<SDLTouchManagerListener> touchEventListener;

/*
 *  Distance between taps.
 */
@property (nonatomic) CGFloat tapDistanceThreshold;

/*
 *  Duration between taps (in seconds).
 */
@property (nonatomic) CGFloat tapTimeThreshold;

/*
 *  Time between pan events (in seconds).
 */
@property (nonatomic) CGFloat movementTimeThreshold;

@property (nonatomic, getter=isTouchEnabled) BOOL touchEnabled;

@end
