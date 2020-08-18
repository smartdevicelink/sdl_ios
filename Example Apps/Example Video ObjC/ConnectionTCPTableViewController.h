//
//  ConnectionTCPTableViewController.h
//  SmartDeviceLink-iOS

#import <UIKit/UIKit.h>

@class VideoStreamSettings;

@interface ConnectionTCPTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic, nullable) VideoStreamSettings *videoStreamSettings;
@end
