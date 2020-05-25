//
//  SimpleAppViewController.m
//  SmartDeviceLink-iOS
//
//  Created by Leonid Lokhmatov on 5/25/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "SimpleAppViewController.h"

@interface SimpleAppViewController ()
@end

@implementation SimpleAppViewController

+ (SimpleAppViewController*)createViewController {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"ExampleApps" bundle:nil];
    SimpleAppViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"idSimpleAppViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
@end
