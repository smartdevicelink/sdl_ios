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

- (instancetype)initWithTouchEvent:(SDLTouchEvent*)touchEvent;

@property (nonatomic, assign, readonly) NSInteger identifier;
@property (nonatomic, assign, readonly) CGPoint location;
@property (nonatomic, assign, readonly) NSUInteger timeStamp;

@property (nonatomic, assign, readonly) BOOL isFirstFinger;
@property (nonatomic, assign, readonly) BOOL isSecondFinger;

@end

NS_ASSUME_NONNULL_END