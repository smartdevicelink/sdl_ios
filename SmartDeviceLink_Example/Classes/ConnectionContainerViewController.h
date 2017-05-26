//
//  ConnectionContainerViewController.h
//  SmartDeviceLink-iOS

#import <UIKit/UIKit.h>

@interface ConnectionContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionTypeSegmentedControl;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end
