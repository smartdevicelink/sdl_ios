//
//  SDLScreenShotViewController.h
//
//  Created by Muller, Alexander (A.) on 2/6/17.
//  Copyright © 2017 Ford Motor Company. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class interacts with `SDLLockScreenPresenter`. It loads a screenshot of the app window and presents it on itself in an image view. This view controller is then presented on the lock window, which then presents the lock view controller over it.
 */
@interface SDLScreenshotViewController : UIViewController

/**
 Load a screenshot of the specified window into the image view on this class

 @param window The window to take a screenshot of
 */
- (void)loadScreenshotOfWindow:(UIWindow *)window;

@end
