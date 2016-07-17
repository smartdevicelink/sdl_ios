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

@interface SDLTouch : NSObject

- (instancetype)initWithTouchEvent:(SDLTouchEvent*)touchEvent;

@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, readonly) CGPoint location;
@property (nonatomic, readonly) NSUInteger timeStamp;

@property (nonatomic, readonly) BOOL isFirstFinger;
@property (nonatomic, readonly) BOOL isSecondFinger;

@end