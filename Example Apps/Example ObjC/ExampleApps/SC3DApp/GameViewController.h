//
//  GameViewController.h
//  TestMetal
//
//  Created by Leonid Lokhmatov on 5/24/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "SDLStreamingMediaDelegate.h"

@interface GameViewController<SDLStreamingMediaDelegate> : UIViewController
+ (instancetype)createViewController;
@end
