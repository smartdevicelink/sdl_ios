//
//  SDLTouchManager.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLTouchManagerListener.h"

@class SDLOnTouchEvent;

typedef NS_ENUM(NSUInteger, SDLPerformingTouchType) {
    SDLPerformingTouchTypeNone,
    SDLPerformingTouchTypeSingleTouch,
    SDLPerformingTouchTypeMultiTouch,
    SDLPerformingTouchTypePanningTouch
};


@interface SDLTouchManager : NSObject

@property (nonatomic, weak) id<SDLTouchManagerListener> touchEventListener;

/*
 *  Distance between taps.
 */
@property (nonatomic) CGFloat tapDistanceThreshold;

/*
 *  Duration between taps (in milliseconds).
 */
@property (nonatomic) CGFloat tapTimeThreshold;

/*
 *  Time between pan events (in milliseconds).
 */
@property (nonatomic) CGFloat panTimeThreshold;

@property (nonatomic, getter=isTouchEnabled) BOOL touchEnabled;

@property (nonatomic, readonly) SDLPerformingTouchType performingTouchType;

@end
