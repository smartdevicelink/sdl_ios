//
//  ConnectionAnimatedTransition.m
//  SmartDeviceLink-iOS

#import "ConnectionAnimatedTransition.h"


static CGFloat const ChildViewPadding = 16;
static CGFloat const DampingFactor = 0.8;
static CGFloat const InitialSpringVelocity = 0.6;


@implementation ConnectionAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL goingRight = ([transitionContext initialFrameForViewController:toViewController].origin.x < [transitionContext finalFrameForViewController:toViewController].origin.x);
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width + ChildViewPadding;
    CGAffineTransform travel = CGAffineTransformMakeTranslation((goingRight ? travelDistance : -travelDistance), 0);
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformInvert(travel);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:DampingFactor initialSpringVelocity:InitialSpringVelocity options:kNilOptions animations:^{
        fromViewController.view.transform = travel;
        fromViewController.view.alpha = 0;
        
        toViewController.view.transform = [transitionContext targetTransform];
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = [transitionContext targetTransform];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
