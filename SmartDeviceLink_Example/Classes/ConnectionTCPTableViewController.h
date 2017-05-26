//
//  ConnectionTCPTableViewController.h
//  SmartDeviceLink-iOS

#import <UIKit/UIKit.h>

@interface ConnectionTCPTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *connectTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end
