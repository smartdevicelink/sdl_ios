//
//  SDLTouch.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLTouchEvent;

typedef enum {
    SDLTouchIdentifierFirstFinger = 0,
    SDLTouchIdentifierSecondFinger = 1
} SDLTouchIdentifier;

NS_ASSUME_NONNULL_BEGIN

@interface SDLTouch : NSObject

/**
 *  @abstract
 *      Initializes a touch.
 *  @param touchEvent
 *      Incoming touch event from onOnTouchEvent notification.
 *  @return SDLTouch
 *      Instance of SDLTouch.
 */
- (instancetype)initWithTouchEvent:(SDLTouchEvent *)touchEvent;

/**
 *  @abstract
 *      Identifier of the touch's finger. Refer to SDLTouchIdentifier for valid 
 *      identifiers.
 */
@property (nonatomic, assign, readonly) NSInteger identifier;

/**
 *  @abstract
 *      Location of touch point, in the head unit's coordinate system.
 */
@property (nonatomic, assign, readonly) CGPoint location;

/**
 *  @abstract
 *      Timestamp in which the touch occured.
 */
@property (nonatomic, assign, readonly) NSUInteger timeStamp;

/**
 *  @abstract
 *      Returns whether or not this touch is a first finger.
 */
@property (nonatomic, assign, readonly) BOOL isFirstFinger;

/**
 *  @abstract
 *      Returns whether or not this touch is a second finger.
 */
@property (nonatomic, assign, readonly) BOOL isSecondFinger;

@end

NS_ASSUME_NONNULL_END