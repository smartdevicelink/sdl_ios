//
//  SDLLockScreenViewController.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *primaryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondaryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vehicleIconImageView;

@end


@implementation SDLLockScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self sdl_layoutImages];
}


#pragma mark - Setters

- (void)setAppIcon:(UIImage *_Nullable)appIcon {
    _appIcon = appIcon;
    
    [self sdl_layoutImages];
}

- (void)setVehicleIcon:(UIImage *_Nullable)vehicleIcon {
    _vehicleIcon = vehicleIcon;
    
    [self sdl_layoutImages];
}

- (void)setBackgroundColor:(UIColor *_Nullable)backgroundColor {
    _backgroundColor = backgroundColor;
    
    [self sdl_setBackgroundColor];
}


#pragma mark - Layout

- (void)sdl_layoutImages {
    if (self.vehicleIcon) {
        self.vehicleIconImageView.image = self.vehicleIcon;
    }
    
    UIImage *sdlLogo = [self.class sdl_logoImageForBackgroundColor:self.backgroundColor];
    
    if (self.appIcon != nil) {
        self.primaryImageView.image = self.appIcon;
        self.secondaryImageView.image = sdlLogo;
    } else {
        self.primaryImageView.image = sdlLogo;
        self.secondaryImageView.image = nil;
    }
}

- (void)sdl_setBackgroundColor {
    self.view.backgroundColor = self.backgroundColor;
}


#pragma mark - Private Image

+ (UIImage *)sdl_logoImageForBackgroundColor:(UIColor *)backgroundColor {
    NSBundle *sdlBundle = [NSBundle bundleForClass:[self class]];
    CGFloat red, green, blue;
    
    [backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    
    // http://stackoverflow.com/a/3943023
    red = (red <= 0.3928) ? (red / 12.92) : pow(((red + 0.055) / 1.055), 2.4);
    green = (green <= 0.3928) ? (green / 12.92) : pow(((green + 0.055) / 1.055), 2.4);
    blue = (blue <= 0.3928) ? (blue / 12.92) : pow(((blue + 0.055) / 1.055), 2.4);
    CGFloat luminescence = 0.2126 * red + 0.7152 * green + 0.0722 * blue;
    
    if (luminescence > 0.179) {
        // Use black icon
        return [UIImage imageNamed:@"sdl-logo-black" inBundle:sdlBundle compatibleWithTraitCollection:nil];
    } else {
        // Use white icon
        return [UIImage imageNamed:@"sdl-logo-white" inBundle:sdlBundle compatibleWithTraitCollection:nil];
    }
}

@end

NS_ASSUME_NONNULL_END