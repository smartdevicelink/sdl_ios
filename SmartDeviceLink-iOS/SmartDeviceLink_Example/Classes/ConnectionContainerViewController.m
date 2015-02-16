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



@interface ConnectionContainerViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionTypeSegmentedControl;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentViewController;

@end



@implementation ConnectionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *tcpControllerStoryboard = [UIStoryboard storyboardWithName:@"ConnectionTCPTableViewController" bundle:[NSBundle mainBundle]];
    UIStoryboard *iapControllerStoryboard = [UIStoryboard storyboardWithName:@"ConnectionIAPTableViewController" bundle:[NSBundle mainBundle]];
    ConnectionTCPTableViewController *tcpController = [tcpControllerStoryboard instantiateInitialViewController];
    ConnectionIAPTableViewController *iapController = [iapControllerStoryboard instantiateInitialViewController];
    self.viewControllers = @[tcpController, iapController];
    
    self.connectionTypeSegmentedControl.selectedSegmentIndex = 0;
    [self loadViewControllerForSelectedIndex:0];
}


#pragma mark - IBActions

- (IBAction)connectionTypeSegmentedControlSelectedIndexDidChange:(UISegmentedControl *)sender {
    [self loadViewControllerForSelectedIndex:sender.selectedSegmentIndex];
}


#pragma mark - Private API

- (void)loadViewControllerForSelectedIndex:(NSInteger)selectedIndex {
    UIViewController *viewController = self.viewControllers[selectedIndex];
    
    if (viewController == nil || viewController == self.currentViewController) {
        return;
    }
    
    if (self.currentViewController != nil) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self addChildViewController:viewController];
        
        viewController.view.alpha = 0.0;
        [self transitionFromViewController:self.currentViewController toViewController:viewController duration:0.25 options:(UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut) animations:^{
            self.currentViewController.view.alpha = 0.0;
            viewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            NSLog(@"Transition Connection Container View Controller complete");
            [self.currentViewController removeFromParentViewController];
            [viewController didMoveToParentViewController:self];
            
            self.currentViewController = viewController;
        }];
    } else {
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        self.currentViewController = viewController;
    }
}

@end
