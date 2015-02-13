//
//  ConnectionTCPTableViewController.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/13/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "ConnectionTCPTableViewController.h"



@interface ConnectionTCPTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@end



@implementation ConnectionTCPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self.ipAddressTextField becomeFirstResponder];
        } break;
        case 1: {
            [self.portTextField becomeFirstResponder];
        } break;
        default: break;
    }
}


@end
