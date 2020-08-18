//
//  ConnectionTransitionContext.m
//  SmartDeviceLink-iOS

#import "ConnectionTransitionContext.h"



@interface ConnectionTransitionContext ()

@property (assign, nonatomic) UIModalPresentationStyle presentationStyle;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSDictionary *viewControllers;

@property (assign, nonatomic) CGRect disappearingFromRect;
@property (assign, nonatomic) CGRect disappearingToRect;
@property (assign, nonatomic) CGRect appearingFromRect;
@property (assign, nonatomic) CGRect appearingToRect;

@property (copy, nonatomic) TransitionCompleteBlock block;

@end



@implementation ConnectionTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController direction:(ConnectionTransitionDirection)direction transitionComplete:(TransitionCompleteBlock)completion {
    NSAssert((fromViewController.isViewLoaded && fromViewController.view.superview), @"The fromViewController must reside in the container view when initializing the transition context");
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.presentationStyle = UIModalPresentationCustom;
    self.containerView = fromViewController.view.superview;
    self.viewControllers = @{
                             UITransitionContextFromViewControllerKey: fromViewController,
                             UITransitionContextToViewControllerKey: toViewController
                             };
    
    CGFloat travelDistance = (direction == ConnectionTransitionDirectionRight) ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width;
    self.disappearingFromRect = self.appearingToRect = self.containerView.bounds;
    self.disappearingToRect = CGRectOffset(self.containerView.bounds, travelDistance, 0);
    self.appearingFromRect = CGRectOffset(self.containerView.bounds, -travelDistance, 0);
    
    self.block = completion;
    
    return self;
}


#pragma mark - UIViewControllerContextTransitioning

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.disappearingFromRect;
    } else {
        return self.appearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.disappearingToRect;
    } else {
        return self.appearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.viewControllers[key];
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.block != NULL) {
        self.block(didComplete);
    }
}

- (BOOL)transitionWasCancelled {
    return NO;
}

- (UIView *)viewForKey:(NSString *)key {
    UIViewController *viewController = nil;
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        viewController = [self viewControllerForKey:UITransitionContextFromViewControllerKey];
    } else {
        viewController = [self viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    return viewController.view;
}

- (CGAffineTransform)targetTransform {
    return CGAffineTransformIdentity;
}


#pragma mark Interactive Transition

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}
- (void)pauseInteractiveTransition {}


@end
