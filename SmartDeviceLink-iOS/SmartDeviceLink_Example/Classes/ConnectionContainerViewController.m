//
//  ConnectionContainerViewController.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/13/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "ConnectionContainerViewController.h"

#import "ConnectionTCPTableViewController.h"
#import "ConnectionIAPTableViewController.h"
#import "ConnectionTransitionContext.h"
#import "ConnectionAnimatedTransition.h"



@interface ConnectionContainerViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionTypeSegmentedControl;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentViewController;

@end



@implementation ConnectionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIStoryboard *tcpControllerStoryboard = [UIStoryboard storyboardWithName:@"ConnectionTCPTableViewController" bundle:[NSBundle mainBundle]];
    UIStoryboard *iapControllerStoryboard = [UIStoryboard storyboardWithName:@"ConnectionIAPTableViewController" bundle:[NSBundle mainBundle]];
    ConnectionTCPTableViewController *tcpController = [tcpControllerStoryboard instantiateInitialViewController];
    ConnectionIAPTableViewController *iapController = [iapControllerStoryboard instantiateInitialViewController];
    self.viewControllers = @[tcpController, iapController];
    
    self.connectionTypeSegmentedControl.selectedSegmentIndex = 0;
    [self loadInitialChildViewController];
}

- (void)loadInitialChildViewController {
    // On the initial load, we just add the new child VC with no animation
    UIViewController *initialViewController = self.viewControllers[0];
    [self addChildViewController:initialViewController];
    [self.view addSubview:initialViewController.view];
    [initialViewController didMoveToParentViewController:self];
    
    self.currentViewController = initialViewController;
}


#pragma mark - IBActions

- (IBAction)connectionTypeSegmentedControlSelectedIndexDidChange:(UISegmentedControl *)sender {
    [self transitionToViewControllerForSelectedIndex:sender.selectedSegmentIndex];
}


#pragma mark - Private API

- (void)transitionToViewControllerForSelectedIndex:(NSInteger)selectedIndex {
    UIViewController *toViewController = self.viewControllers[selectedIndex];
    
    if (toViewController == nil || toViewController == self.currentViewController) {
        return;
    }
    
    [self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    id<UIViewControllerAnimatedTransitioning> animator = [[ConnectionAnimatedTransition alloc] init];
    NSUInteger fromIndex = [self.viewControllers indexOfObject:self.currentViewController];
    
    ConnectionTransitionContext *transitionContext = [[ConnectionTransitionContext alloc] initWithFromViewController:self.currentViewController toViewController:toViewController direction:((selectedIndex > fromIndex) ? ConnectionTransitionDirectionRight : ConnectionTransitionDirectionLeft) transitionComplete:^(BOOL didComplete) {
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        
        if ([animator respondsToSelector:@selector(animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
        
        self.connectionTypeSegmentedControl.userInteractionEnabled = YES;
        self.currentViewController = toViewController;
    }];
    transitionContext.animated = YES;
    transitionContext.interactive = NO;
    
    self.connectionTypeSegmentedControl.userInteractionEnabled = NO;
    [animator animateTransition:transitionContext];
    
//    toViewController.view.alpha = 0.0;
//    [self transitionFromViewController:self.currentViewController toViewController:toViewController duration:0.25 options:(UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut) animations:^{
//        self.currentViewController.view.alpha = 0.0;
//        toViewController.view.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        NSLog(@"Transition Connection Container View Controller complete");
//        [self.currentViewController removeFromParentViewController];
//        [toViewController didMoveToParentViewController:self];
//        
//        self.currentViewController = toViewController;
//    }];
}

@end
