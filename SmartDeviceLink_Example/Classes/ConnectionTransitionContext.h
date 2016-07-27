//
//  ConnectionTransitionContext.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


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
