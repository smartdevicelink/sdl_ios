//
//  SDLDialogPresenting.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  A protocol used to tell a view controller to present another view controller. This makes testing of modal VCs' presentation easier.
 */
@protocol SDLViewControllerPresentable <NSObject>

@property (strong, nonatomic) UIViewController *lockViewController;
@property (assign, nonatomic, readonly) BOOL presented;

- (void)present;
- (void)dismiss;

@end
