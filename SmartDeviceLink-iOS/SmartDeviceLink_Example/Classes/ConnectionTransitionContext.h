//
//  ConnectionTransitionContext.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/18/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;


typedef NS_ENUM(NSUInteger, ConnectionTransitionDirection) {
    ConnectionTransitionDirectionLeft,
    ConnectionTransitionDirectionRight
};

typedef void (^TransitionCompleteBlock)(BOOL didComplete);


@interface ConnectionTransitionContext : NSObject <UIViewControllerContextTransitioning>

@property (assign, nonatomic, getter=isAnimated) BOOL animated;
@property (assign, nonatomic, getter=isInteractive) BOOL interactive;

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController direction:(ConnectionTransitionDirection)direction transitionComplete:(TransitionCompleteBlock)completion;

@end
