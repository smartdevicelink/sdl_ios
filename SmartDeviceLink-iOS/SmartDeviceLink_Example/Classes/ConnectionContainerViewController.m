//
//  ConnectionContainerViewController.m
//  SmartDeviceLink-iOS

#import "ConnectionContainerViewController.h"

#import "ConnectionTCPTableViewController.h"
#import "ConnectionIAPTableViewController.h"
#import "ConnectionTransitionContext.h"
#import "ConnectionAnimatedTransition.h"



@interface ConnectionContainerViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionTypeSegmentedControl;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentViewController;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end



@implementation ConnectionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    // Setup the child VCs
    UIStoryboard *tcpControllerStoryboard = [UIStoryboard storyboardWithName:@"ConnectionTCPTableViewController" bundle:[NSBundle mainBundle]];
    UIStoryboard *iapControllerStoryboard = [UIStoryboard storyboardWithName:@"ConnectionIAPTableViewController" bundle:[NSBundle mainBundle]];
    ConnectionTCPTableViewController *tcpController = [tcpControllerStoryboard instantiateInitialViewController];
    ConnectionIAPTableViewController *iapController = [iapControllerStoryboard instantiateInitialViewController];
    self.viewControllers = @[tcpController, iapController];
    
    // Setup the pan gesture
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDidFire:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    // Setup initial view controller state
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


#pragma mark - Gestures

- (void)panGestureRecognizerDidFire:(UIPanGestureRecognizer *)gesture {
    BOOL goingRight = ([gesture velocityInView:gesture.view].x < 0.0f);
    
    NSUInteger currentSegmentIndex = self.connectionTypeSegmentedControl.selectedSegmentIndex;
    if (goingRight && (currentSegmentIndex != self.viewControllers.count - 1)) {
        // If we're swiping left (going right) and current segment is not all the way to the right
        NSUInteger nextIndex = currentSegmentIndex + 1;
        self.connectionTypeSegmentedControl.selectedSegmentIndex = nextIndex;
        [self transitionToViewControllerForSelectedIndex:nextIndex];
    } else if (!goingRight && (currentSegmentIndex > 0)) {
        // If we're swiping right (going left) and the current segment is not all the way to the left
        NSUInteger nextIndex = currentSegmentIndex - 1;
        self.connectionTypeSegmentedControl.selectedSegmentIndex = nextIndex;
        [self transitionToViewControllerForSelectedIndex:nextIndex];
    }
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
}

@end
