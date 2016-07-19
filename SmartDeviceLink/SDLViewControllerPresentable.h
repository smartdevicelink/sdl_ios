//
//  SDLDialogPresenting.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDLViewControllerPresentable <NSObject>

@property (strong, nonatomic) UIViewController *viewController;
@property (assign, nonatomic, readonly) BOOL presented;

- (void)present;
- (void)dismiss;

@end
