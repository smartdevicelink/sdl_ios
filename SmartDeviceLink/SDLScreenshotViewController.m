//
//  SDLScreenShotViewController.m
//  ios
//
//  Created by Muller, Alexander (A.) on 2/6/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

#import "SDLScreenshotViewController.h"

@interface SDLScreenshotViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SDLScreenshotViewController

- (instancetype)init {
    if (self = [super init]) {
        
        self.view.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    self.imageView.frame = self.view.bounds;
}

- (void)loadScreenshotOfWindow:(UIWindow *)window {
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0.0f);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.imageView.image = image;
}


@end
